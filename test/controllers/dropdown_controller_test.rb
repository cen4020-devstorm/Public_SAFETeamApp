require "test_helper"

class BuildingsControllerTest < ActionDispatch::IntegrationTest
  test "should return zone and address for a valid building" do
    get buildings_info_url, params: { building_name: "Lawton & Rhea Chiles Center" }
    assert_response :success

    json = JSON.parse(@response.body)
    assert_equal "A_1", json["zone"]
    assert_equal "3010 USF Banyan Circle Tampa, FL 33612", json["address"]
  end

  test "should return nil zone and 'Address not found' for an invalid building" do
    get buildings_info_url, params: { building_name: "Nonexistent Building" }
    assert_response :success

    json = JSON.parse(@response.body)
    assert_nil json["zone"]
    assert_equal "Address not found", json["address"]
  end
end
