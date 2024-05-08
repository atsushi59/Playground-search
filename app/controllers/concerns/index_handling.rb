
module IndexHandling
  extend ActiveSupport::Concern

  def process_queries(queries)
    @places_details = []

    queries.each do |query|
      response = @google_places_service.search_places(query)
      if response['candidates'].any?
        process_candidate(response['candidates'].first)
      else
        @places_details.push({ 'name' => query, 'error' => 'No results found' })
      end
    end
  end

  private

  def process_candidate(candidate)
    place_detail = get_place_details(candidate['place_id'])
    process_place_detail(place_detail)
  end

  def get_place_details(place_id)
    details_response = @google_places_service.get_place_details(place_id)
    details_response['result']
  end

  def process_place_detail(place_detail)
    opening_hours = format_opening_hours(place_detail)
    photo_reference = fetch_photo_reference(place_detail)
    travel_time_minutes = calculate_travel_time(place_detail)
    formatted_address = format_address(place_detail['formatted_address'])
    add_place_to_results(place_detail, travel_time_minutes, opening_hours, photo_reference, formatted_address)
  end

  def format_address(address)
    formatted_address = address.sub(/\〒\d{3}-\d{4}\s*/, '').sub(/^日本、\s*/, '')
    formatted_address
  end

  def format_opening_hours(place_detail)
    if place_detail['opening_hours']
      place_detail['opening_hours']['weekday_text'][Time.zone.today.wday.zero? ? 6 : Time.zone.today.wday - 1]
    else
      '営業時間の情報はありません。'
    end
  end

  def fetch_photo_reference(place_detail)
    return unless place_detail['photos']

    @google_places_service.get_photo(place_detail['photos'].first['photo_reference'])
  end

  def add_place_to_results(place_detail, travel_time_minutes, opening_hours, photo_reference, formatted_address)
    place_detail['formatted_address'] = formatted_address
    if travel_time_minutes && travel_time_minutes <= session[:selected_time].to_i
      @places_details.push(place_detail.merge('today_opening_hours' => opening_hours,
                                              'photo_url' => photo_reference))
    else
      @places_details.push({ 'name' => place_detail['name'], 'error' => 'No results found' })
    end
  end
end
