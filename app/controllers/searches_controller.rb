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
      #redirect_to index_path
      puts "Answer: #{answer}"
    else
      @error_message = "Error: #{response.parsed_response['error']['message']}"
      puts error_message
    end
  end

  def index
  end
end
