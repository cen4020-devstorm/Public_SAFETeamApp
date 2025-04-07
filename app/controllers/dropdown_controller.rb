class BuildingsController < ApplicationController
  include BuildingsHelper

  # Unified controller action to return both zone and address
  def select_building_info
    building_name = params[:building_name]

    zone = building_zone_map[building_name]
    address = zone_to_address(zone)

    render json: { zone: zone, address: address }
  end
end
