require 'httparty'

class ChatgptService
  include HTTParty
  base_uri 'https://api.openai.com/v1'

  def initialize(api_key)
    @api_key = ENV['OPEN_AI_API_KEY']
  end

  def create_chat_completion(messages)
    options = {
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{@api_key}"
      },
      body: {
        model: "gpt-4-turbo-preview",
        messages: messages
      }.to_json
    }

    self.class.post('/chat/completions', options)
  end
end