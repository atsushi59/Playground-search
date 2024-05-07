# frozen_string_literal: true

require 'httparty'

class ChatgptService
  include HTTParty
  base_uri 'https://api.openai.com/v1'

  def initialize(_api_key)
    @api_key = ENV['OPEN_AI_API_KEY']
  end

  def create_chat_completion(messages)
    options = build_request_options(messages)
    self.class.post('/chat/completions', options)
  end

  private

  def build_request_options(messages)
    {
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{@api_key}"
      },
      body: {
        model: 'gpt-4-turbo-preview',
        messages:
      }.to_json
    }
  end
end
