class RideRequestsController < ApplicationController
  before_action :require_login

  def new
    @ride_request = RideRequest.new
  end

  def create
    @ride_request = RideRequest.new(ride_request_params)
    @ride_request.user = current_user
    team = Team.order(:available_at).first
    unless team
      flash[:alert] = "No team available. Please try again later."
      render :new, status: :unprocessable_entity
      return
    end
    @ride_request.team = team
  
    if @ride_request.valid?
      driver_location = "4103 USF Cedar Cir, Tampa, FL 33620"
      pickup_location = @ride_request.location
      destination = @ride_request.destination
  
      # Validate coordinates
      pickup_coords = TravelTimeService.get_coordinates(pickup_location)
      destination_coords = TravelTimeService.get_coordinates(destination)
  
      if pickup_coords[:error]
        flash[:alert] = "Invalid pickup location: #{pickup_coords[:error]}"
        render :new, status: :unprocessable_entity and return
      end
  
      if destination_coords[:error]
        flash[:alert] = "Invalid destination: #{destination_coords[:error]}"
        render :new, status: :unprocessable_entity and return
      end
  
      # Get travel times
      wait_time_result = TravelTimeService.get_travel_time(driver_location, pickup_location)
      drive_time_result = TravelTimeService.get_travel_time(pickup_location, destination)
  
      if wait_time_result[:error]
        flash[:alert] = wait_time_result[:error]
        render :new, status: :unprocessable_entity and return
      end
  
      if drive_time_result[:error]
        flash[:alert] = drive_time_result[:error]
        render :new, status: :unprocessable_entity and return
      end
  
      
  
      # Compute times
      now = Time.current
      team_ready_at = team.available_at || now
      api_wait_minutes = wait_time_result[:duration].to_i
      api_drive_minutes = drive_time_result[:duration].to_i
  
      estimated_pickup_time = [now, team_ready_at].max + api_wait_minutes.minutes
      team.update(available_at: estimated_pickup_time + api_drive_minutes.minutes)
  
  
      # Final save
      if @ride_request.save
        @waiting_time = ((estimated_pickup_time - now) / 60).ceil
        @waiting_distance = wait_time_result[:distance]
        @driving_time = drive_time_result[:duration]
        @driving_distance = drive_time_result[:distance]
        render :show
      else
        flash[:alert] = "Failed to save ride request."
        render :new, status: :unprocessable_entity
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @ride_request = RideRequest.find(params[:id])
  end

  def index
    @ride_requests = current_user.ride_requests.order(created_at: :desc)
  end

  private

  def ride_request_params
    params.require(:ride_request).permit(:name, :phone, :location, :destination)
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
  