# class RideRequestsController < ApplicationController
#     def new
#       @user_info = RideRequest.new
#     end
  
#     def create
#       @user_info = RideRequest.new(user_info_params)
  
#       if @user_info.valid?
#         driver_location = "4103 USF Cedar Cir, Tampa, FL 33620" # Driver starts here
#         pickup_location = @user_info.location

#         pickup_coords = TravelTimeService.get_coordinates(pickup_location)

#         if pickup_coords[:error]
#             flash[:alert] = "Invalid pickup location: #{pickup_coords[:error]}"
#             render :new, status: :unprocessable_entity
#             return
#         end
  
#         # Get the estimated waiting time (driver to user)
#         wait_time_result = TravelTimeService.get_travel_time(driver_location, pickup_location)
  
#         if wait_time_result[:error]
#           flash[:alert] = wait_time_result[:error]
#           render :new, status: :unprocessable_entity
#         else
#           @user_info.save
#           @waiting_time = wait_time_result[:duration]
#           @waiting_distance = wait_time_result[:distance]
#           render :show
#         end
#       else
#         render :new, status: :unprocessable_entity
#       end
#     end
  
#     private
  
#     def user_info_params
#       params.require(:user_info).permit(:name, :phone, :location, :destination)
#     end
#   end


class RideRequestsController < ApplicationController
  before_action :require_login

  def new
    @ride_request = RideRequest.new
  end

  def create
    @ride_request = RideRequest.new(ride_request_params)
    @ride_request.user = current_user # 👈 Associate with logged-in user

    if @ride_request.valid?
      driver_location = "4103 USF Cedar Cir, Tampa, FL 33620"
      pickup_location = @ride_request.location

      pickup_coords = TravelTimeService.get_coordinates(pickup_location)

      if pickup_coords[:error]
        flash[:alert] = "Invalid pickup location: #{pickup_coords[:error]}"
        render :new, status: :unprocessable_entity
        return
      end

      wait_time_result = TravelTimeService.get_travel_time(driver_location, pickup_location)

      if wait_time_result[:error]
        flash[:alert] = wait_time_result[:error]
        render :new, status: :unprocessable_entity
      else
        @ride_request.save
        @waiting_time = wait_time_result[:duration]
        @waiting_distance = wait_time_result[:distance]
        render :show
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
  
