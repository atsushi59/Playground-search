require 'httparty'

class GoogleDirectionsService
  include HTTParty
  base_uri 'https://maps.googleapis.com/maps/api/directions'

  def initialize(api_key)
    @api_key = api_key
  end

  def get_directions(origin, destination, departure_time)
    options = {
      query: {
        origin: origin, 
        destination: destination, 
        mode: 'driving', 
        departure_time: departure_time,
        key: @api_key
      }
    }
    self.class.get('/json', options)
  end 
end