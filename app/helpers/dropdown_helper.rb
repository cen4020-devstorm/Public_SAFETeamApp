module BuildingsHelper
  # Dropdown list: returns buildings sorted alphabetically
  def building_dropdown
    building_zone_map.keys.sort
  end

  # Map building names to their corresponding zone
  def building_zone_map
    {
      # ... [full building-to-zone hash from before] ...
    }.sort.to_h
  end

  # Map zone to corresponding address
  def zone_to_address(zone)
    addresses = {
      # ... [full zone-to-address hash from before] ...
    }
    addresses[zone] || "Address not found"
  end
end
