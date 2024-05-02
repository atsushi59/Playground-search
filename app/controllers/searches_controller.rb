class SearchesController < ApplicationController
  def search
    api_key = ENV['OPENAI_API_KEY']
    chatgpt_service = ChatgptService.new(api_key)

    selected_transport = params[:selected_transport]
    selected_time = params[:selected_time]
    selected_age = params[:selected_age]
    selected_activity = params[:selected_activity]
    address = params[:address]
    
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
      @error_message = "Error: #{response.parsed_response['error']['message']}"
      puts error_message
    end
  end

  def index
    queries = session[:query].to_s.split("\n").map { |q| q.split('. ').last.strip }
    @places_details = []
  
    queries.each do |query|
      response = @google_places_service.search_places(query)
      if response["candidates"].any?
        first_result = response["candidates"].first
        place_id = first_result["place_id"]
        details_response = @google_places_service.get_place_details(place_id)
        place_detail = details_response["result"]
  
        opening_hours = place_detail['opening_hours'] ? place_detail['opening_hours']['weekday_text'][Time.zone.today.wday.zero? ? 6 : Time.zone.today.wday - 1] : "営業時間の情報はありません。"
        photo_reference = place_detail['photos'] ? @google_places_service.get_photo(place_detail['photos'].first['photo_reference']) : nil

        @places_details.push(place_detail.merge("today_opening_hours" => opening_hours, "photo_url" => photo_reference))
      else
        @places_details.push({ "name" => query, "error" => "No results found" })
      end
    end
  end
end
