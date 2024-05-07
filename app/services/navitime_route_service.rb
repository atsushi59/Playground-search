# frozen_string_literal: true

require 'httparty'

class NavitimeRouteService
  include HTTParty
  base_uri 'https://navitime-route-totalnavi.p.rapidapi.com'

  def initialize(api_key)
    @api_key = api_key
    @google_api_key = ENV['GOOGLE_API_KEY']
    @options = {
      headers: {
        'X-RapidAPI-Key' => @api_key,
        'X-RapidAPI-Host' => 'navitime-route-totalnavi.p.rapidapi.com'
      }
    }
  end

  def geocode_address(address)
    query = {
      address:,
      key: @google_api_key
    }
    response = HTTParty.get('https://maps.googleapis.com/maps/api/geocode/json', query:)
    if response.success?
      process_geocode_response(response)
    else
      '情報を取得できませんでした'
    end
  end

  def get_directions(origin, destination, start_time)
    formatted_origin = geocode_address(origin)
    formatted_destination = geocode_address(destination)
    formatted_time = format_departure_time(start_time)
    perform_directions_query(formatted_origin, formatted_destination, formatted_time)
  end

  private

  def perform_directions_query(formatted_origin, formatted_destination, formatted_time)
    query_options = {
      query: {
        start: formatted_origin,
        goal: formatted_destination,
        start_time: formatted_time,
        mode: 'transit'
      }
    }
    self.class.get('/route_transit', @options.merge(query_options))
  end

  def process_geocode_response(response)
    results = response.parsed_response['results'] || []
    return '情報を取得できませんでした' if results.empty?

    first_result = results.first
    if first_result && first_result['geometry'] && first_result['geometry']['location']
      location = first_result['geometry']['location']
      "#{location['lat']},#{location['lng']}"
    else
      '情報を取得できませんでした'
    end
  end

  def format_departure_time(start_time)
    Time.parse(start_time).strftime('%Y-%m-%dT%H:%M:%S')
  end
end
