class RideRequestsController < ApplicationController
  before_action :require_login

  # Initializes a new instance of the RideRequest model and assigns it to an instance variable.
  # This action is typically used to render a form for creating a new ride request.
  def new
    @ride_request = RideRequest.new
  end

  include BuildingsHelper
  include AddressMappingHelper

  before_action :load_building_names, only: [:new]

  # Creates a new ride request and associates it with the currently logged-in user.
  # Validates the ride request and calculates the estimated wait time and distance
  # from the driver's location to the pickup location.
  #
  # Steps:
  # - Initializes a new RideRequest object with the provided parameters.
  # - Associates the ride request with the current user.
  # - Validates the ride request.
  # - Retrieves the coordinates for the pickup location using TravelTimeService.
  # - If the pickup location is invalid, displays an error message and re-renders the form.
  # - Calculates the travel time and distance from the driver's location to the pickup location.
  # - If the travel time calculation fails, displays an error message and re-renders the form.
  # - If successful, saves the ride request, calculates waiting time and distance, and renders the show view.
  #
  # Flash Messages:
  # - Displays an alert if the pickup location is invalid or if there is an error in calculating travel time.
  #
  # Renders:
  # - :new with status :unprocessable_entity if validation or service calls fail.
  # - :show if the ride request is successfully created.
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
  
      # Map building names to actual addresses
      #building_zone_map = building_name_to_zone_map
  
      pickup_zone = building_zone_map[@ride_request.location]
      destination_zone = building_zone_map[@ride_request.destination]
  
      if pickup_zone.nil?
        flash[:alert] = "Invalid pickup building name: #{@ride_request.location}"
        render :new, status: :unprocessable_entity and return
      end
  
      if destination_zone.nil?
        flash[:alert] = "Invalid destination building name: #{@ride_request.destination}"
        render :new, status: :unprocessable_entity and return
      end
  
      pickup_address = zone_to_address(pickup_zone)
      destination_address = zone_to_address(destination_zone)
  
      # Get coordinates
      pickup_coords = TravelTimeService.get_coordinates(pickup_address)
      destination_coords = TravelTimeService.get_coordinates(destination_address)
  
      if pickup_coords[:error]
        flash[:alert] = "Invalid pickup location: #{pickup_coords[:error]}"
        render :new, status: :unprocessable_entity and return
      end
  
      if destination_coords[:error]
        flash[:alert] = "Invalid destination: #{destination_coords[:error]}"
        render :new, status: :unprocessable_entity and return
      end
  
      # Get travel times
      wait_time_result = TravelTimeService.get_travel_time(driver_location, pickup_address)
      drive_time_result = TravelTimeService.get_travel_time(pickup_address, destination_address)
  
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
    @ride_requests = RideRequest.includes(:team).order(:created_at)
  end

    

  def destroy
    @ride_request = RideRequest.find(params[:id])
    @ride_request.destroy
    redirect_to admin_dashboard_path, notice: "Ride removed from queue."
  end

  def notify_on_the_way
    @ride_request = RideRequest.find(params[:id])
    rider_name = @ride_request.name.presence || "Hello"
    NotificationService.send_text(@ride_request.phone, "#{rider_name}, your ride is on the way!")
    redirect_to admin_dashboard_path, notice: "Notified rider that the ride is on the way."
  end
  
  def notify_arrived
    @ride_request = RideRequest.find(params[:id])
    rider_name = @ride_request.name.presence || "Hello"
    NotificationService.send_text(@ride_request.phone, "#{rider_name}, your ride has arrived! Please meet them outside.")
    redirect_to admin_dashboard_path, notice: "Notified rider that the ride has arrived."
  end
  
  def complete
    @ride_request = RideRequest.find(params[:id])
    rider_name = @ride_request.name.presence || "Hello"
    NotificationService.send_text(@ride_request.phone, "#{rider_name}, your ride has been completed! Thank you for riding with us!")
    @ride_request.destroy
    redirect_to admin_dashboard_path, notice: "Ride completed and rider notified."
  end
  
   

  private

  # Strong parameter method for ride requests.
  # Ensures only the permitted attributes are allowed through the params.
  # @return [ActionController::Parameters] Filtered parameters containing :name, :phone, :location, and :destination.
  def ride_request_params
    params.require(:ride_request).permit(:name, :phone, :location, :destination, :number_of_passengers)
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def load_building_names
    @building_names = building_name_list
  end

  
  def send_text(phone_number, message)
    TwilioClient.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: phone_number,
      body: message
    )
  
  end

end
  