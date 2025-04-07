
class RideRequestsController < ApplicationController
  before_action :require_login

  # Initializes a new instance of the RideRequest model and assigns it to an instance variable.
  # This action is typically used to render a form for creating a new ride request.
  def new
    @ride_request = RideRequest.new
  end

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
    @ride_requests = current_user.ride_request.order(created_at: :desc)
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
end
  