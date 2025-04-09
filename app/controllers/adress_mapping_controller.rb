class BuildingsController < ApplicationController
  include AddressMappingHelpers
  include BuildingsHelper

  # Controller action to handle the building selection and return the address
  def select_building_address
    # Get the selected building from the request parameters
    building_name = params[:building_name]

    # Map the building to its corresponding zone using helper method
    zone = building_zone_map[building_name]

    # Get the corresponding address using the zone
    address = zone_to_address(zone)

    # Return the address as a JSON response
    render json: { address: address }
  end
end
