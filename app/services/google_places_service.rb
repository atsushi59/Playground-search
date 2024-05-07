# frozen_string_literal: true

require 'httparty'

class GooglePlacesService
  include HTTParty
  base_uri 'https://maps.googleapis.com/maps/api/place'

  def initialize(api_key)
    @api_key = api_key
  end

  def search_places(query)
    options = {
      query: {
        input: query,
        inputtype: 'textquery',
        fields: 'place_id,name,formatted_address,business_status',
        key: @api_key,
        language: 'ja'
      }
    }
    self.class.get('/findplacefromtext/json', options)
  end

  def get_place_details(place_id, fields = 'name,formatted_address,opening_hours,website,photo')
    options = {
      query: {
        place_id:,
        fields:,
        key: @api_key,
        language: 'ja'
      }
    }
    self.class.get('/details/json', options)
  end

  def get_photo(photo_reference, max_width = 400)
    options = {
      query: {
        photoreference: photo_reference,
        maxwidth: max_width,
        key: @api_key
      }
    }
    self.class.get('/photo', options).request.last_uri.to_s
  end
end
