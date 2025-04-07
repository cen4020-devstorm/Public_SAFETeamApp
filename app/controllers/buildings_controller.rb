class BuildingsController < ApplicationController
  include BuildingsHelper

  # Controller action to handle the building selection and return the zone
  def select_building_zone
    # Get the selected building from the request parameters
    building_name = params[:building_name]

    # Map the building to its corresponding zone using helper method
    zone = building_zone_map[building_name]

    # Return the zone as a JSON response
    render json: { zone: zone }
  end
end
