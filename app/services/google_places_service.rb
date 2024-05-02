
require "httparty"

class GooglePlacesService
  include HTTParty
  base_uri "https://maps.googleapis.com/maps/api/place"

  def initialize(api_key)
    @api_key = api_key
  end
end  