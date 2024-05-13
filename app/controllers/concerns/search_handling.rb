# frozen_string_literal: true

module SearchHandling
  extend ActiveSupport::Concern

  def setup_session
    params.each do |key, value|
      session[key] = value if %w[selected_transport address selected_time selected_activity].include?(key) && value.present?
    end
  end

  def generate_user_input
    root = "#{params[:address]}から#{params[:selected_transport]}で"
    time = "正確に#{params[:selected_time]}で到着する"
    age = "#{params[:selected_age]}の子供が遊べる"
    activity = "#{params[:selected_activity]}を場所の正式名称のみ2件回答してください。"
    request = 'なるべく過去に回答していない場所を提示してください。'
    [root, time, age, activity, request].join
  end

  def generate_messages(user_input)
    [
      { role: 'system', content: 'You are a helpful assistant.' },
      { role: 'user', content: user_input }
    ]
  end

  def handle_response(response)
    if response.success?
      process_successful_response(response)
      redirect_to index_path
    else
      redirect_to root_path
      flash[:danger] = '検索に失敗しました'
    end
  end

  private

  def process_successful_response(response)
    @result = response.parsed_response
    message_content = @result['choices'].first['message']['content']
    places = message_content.split("\n").select { |line| line.match(/^\d+\./) }
    @answer = places.join("\n")
    session[:query] = @answer
  end
end
