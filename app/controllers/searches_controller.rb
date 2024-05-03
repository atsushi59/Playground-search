class SearchesController < ApplicationController
  before_action :set_google_places_service
  before_action :set_directions_service
  before_action :set_navitime_route_service
  
  def search
    api_key = ENV['OPENAI_API_KEY']
    chatgpt_service = ChatgptService.new(api_key)

    selected_transport = params[:selected_transport]
    selected_time = params[:selected_time]
    selected_age = params[:selected_age]
    selected_activity = params[:selected_activity]
    address = params[:address]

    session[:selected_transport] = selected_transport
    session[:address] = address if address.present?
    session[:selected_time] = params[:selected_time]
    
    user_input = "#{address}から#{selected_transport}で#{selected_time}以内で#{selected_age}の子供が対象の#{selected_activity}できる場所を正式名称で2件提示してください"

    messages = [
      { role: 'system', content: 'You are a helpful assistant.' },
      { role: 'user', content: user_input }
    ]
    response = chatgpt_service.create_chat_completion(messages)

    if response.success?
      @result = response.parsed_response
      message_content = @result['choices'].first['message']['content']

      places = message_content.split("\n").select { |line| line.match(/^\d+\./) }
      @answer = places.join("\n")
      session[:query] = @answer
      redirect_to index_path
    else
      redirect_to root_path
      flash[:danger] = '検索に失敗しました'
    end
  end

  def index
    queries = session[:query].to_s.split("\n").map { |q| q.split('. ').last.strip }
    @places_details = []
    selected_time = session[:selected_time].to_i

    queries.each do |query|
      response = @google_places_service.search_places(query)
      if response["candidates"].any?
        first_result = response["candidates"].first
        place_id = first_result["place_id"]
        details_response = @google_places_service.get_place_details(place_id)
        place_detail = details_response["result"]
  
        opening_hours = place_detail['opening_hours'] ? place_detail['opening_hours']['weekday_text'][Time.zone.today.wday.zero? ? 6 : Time.zone.today.wday - 1] : "営業時間の情報はありません。"
        photo_reference = place_detail['photos'] ? @google_places_service.get_photo(place_detail['photos'].first['photo_reference']) : nil

        travel_time_minutes = calculate_travel_time(place_detail)
        place_detail['travel_time_text'] = "#{travel_time_minutes}分" if travel_time_minutes

        if travel_time_minutes && travel_time_minutes <= selected_time
          @places_details.push(place_detail.merge('today_opening_hours' => opening_hours,
                                                  'photo_url' => photo_reference))
        else
          @places_details.push({ 'name' => query, 'error' => 'No results found' })
        end
      else
        @places_details.push({ 'name' => query, 'error' => 'No results found' })
      end
    end
  end

  def calculate_travel_time(place_detail)
    origin = session[:address]
    destination = place_detail['formatted_address']

    if session[:selected_transport] == '車'
      response = @directions_service.get_directions(
        origin,
        destination,
        Time.now.to_i
      )
      if response.success? && response.parsed_response['routes'].any?
        travel_time_text = response.parsed_response['routes'].first['legs'].first['duration']['text']
        convert_duration_to_minutes(travel_time_text)
      else
        '所要時間の情報は利用できません。'
      end
    elsif session[:selected_transport] == '公共交通機関'
      formatted_origin = @navitime_route_service.geocode_address(origin)
      formatted_destination = @navitime_route_service.geocode_address(destination)
      response = @navitime_route_service.get_directions(
        formatted_origin, 
        formatted_destination, 
        (Time.now.utc + 9.hours).strftime('%Y-%m-%dT%H:%M:%S')
      ) 

      if response.success? && response.parsed_response['items'].any?
        response.parsed_response['items'].first['summary']['move']['time']
      else
        '所要時間の情報は利用できません。'
      end
    end
  end  

  private

  def set_google_places_service
    @google_places_service = GooglePlacesService.new(ENV['GOOGLE_API_KEY'])
  end

  def set_directions_service
    api_key = ENV['GOOGLE_API_KEY'] 
    @directions_service = GoogleDirectionsService.new(api_key) 
  end

  def set_navitime_route_service
    api_key = ENV['Rapid_API_KEY'] 
    @navitime_route_service = NavitimeRouteService.new(api_key) 
  end

  def convert_duration_to_minutes(duration_text)
    hours = duration_text.scan(/(\d+)\s*hour/).flatten.first.to_i
    minutes = duration_text.scan(/(\d+)\s*min/).flatten.first.to_i
    hours * 60 + minutes
  end
end
