require "httparty"
require "json"

class TravelTimeService
  GOOGLE_API_KEY = ENV["GOOGLE_API_KEY"]

  # Get latitude/longitude from a full address
  def self.get_coordinates(address)
    return { error: "Invalid address" } if address.blank?

    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{URI.encode_www_form_component(address)}&key=#{GOOGLE_API_KEY}"

    response = HTTParty.get(url)
    data = JSON.parse(response.body)

    puts "📍 Geocode API Response: #{data.inspect}" # Debug log

    if data["status"] == "OK" && data["results"].any?
      location = data["results"][0]["geometry"]["location"]
      { lat: location["lat"], lng: location["lng"] }
    else
      { error: data["error_message"] || "Failed to get coordinates: #{data['status']}" }
    end
  end

  # Get travel time and distance between two full addresses
  def self.get_travel_time(origin_address, destination_address)
    origin_coords = get_coordinates(origin_address)
    destination_coords = get_coordinates(destination_address)

    return origin_coords if origin_coords[:error]
    return destination_coords if destination_coords[:error]

    url = "https://routes.googleapis.com/directions/v2:computeRoutes?key=#{GOOGLE_API_KEY}"

    headers = {
      "Content-Type" => "application/json",
      "X-Goog-Api-Key" => GOOGLE_API_KEY,
      "X-Goog-FieldMask" => "routes.duration,routes.distanceMeters"
    }

    body = {
      origin: {
        location: {
          latLng: {
            latitude: origin_coords[:lat],
            longitude: origin_coords[:lng]
          }
        }
      },
      destination: {
        location: {
          latLng: {
            latitude: destination_coords[:lat],
            longitude: destination_coords[:lng]
          }
        }
      },
      travelMode: "DRIVE",
      computeAlternativeRoutes: false
    }.to_json

    response = HTTParty.post(url, headers: headers, body: body)
    data = JSON.parse(response.body)

    puts "🚗 Routes API Response: #{data.inspect}" # Debug log

    if data["routes"] && data["routes"].any?
      duration_text = parse_duration(data["routes"][0]["duration"])
      distance_km = (data["routes"][0]["distanceMeters"].to_f / 1000).round(2)

      { duration: duration_text, distance: "#{distance_km} km" }
    else
      { error: data.dig("error", "message") || "Failed to retrieve travel time" }
    end
  end

  # Convert ISO 8601 duration to minutes
  def self.parse_duration(duration_iso8601)
    return "N/A" if duration_iso8601.blank?

    # Duration is ISO8601 format like "3600s" (seconds)
    seconds = duration_iso8601.gsub("s", "").to_i
    minutes = (seconds / 60).round

    minutes
  end
end
