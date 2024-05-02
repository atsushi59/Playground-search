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
    # selected_transportで選択された(車,電車)パラメータをサーバー側のセッションに保存
    session[:address] = address if address.present?
    # addressで選択された(住所)パラメータをサーバー側のセッションに保存　indexで使用
    session[:selected_time] = params[:selected_time]
    # selected_timeで選択された(時間)パラメータをサーバー側のセッションに保存　indexで使用
    
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
        # calculate_travel_time(place_detail)で取得した時間をtravel_time_minutesに格納(指定された場所への所要時間を分単位で計算し、その結果を返す)
        place_detail['travel_time_text'] = "#{travel_time_minutes}分" if travel_time_minutes
        # travel_time_minutesがtrueだった場合"#{travel_time_minutes}分が30分という形になりplace_detail['travel_time_text']に30分が格納される

        if travel_time_minutes && travel_time_minutes <= selected_time
          # travel_time_minutesがnilまたはfalseでなく、かつselected_time（ユーザーが指定した最大所要時間）以下の場合
          @places_details.push(place_detail.merge('today_opening_hours' => opening_hours,
                                                  'photo_url' => photo_reference))
          # 取得した詳細情報を配列に追加 "today_opening_hours" と "photo_url" という新しいキーに割り当てて、元の place_detail ハッシュにマージ
          # place_detailとtoday_opening_hours" と "photo_url"が検索結果として表示
        else
          @places_details.push({ 'name' => query, 'error' => 'No results found' })
          # travel_time_minutesが存在しないか、またはselected_timeよりも大きい場合、結果が見つからなかったとしてエラーメッセージを持つオブジェクトを配列に追加
        end
      else
        @places_details.push({ 'name' => query, 'error' => 'No results found' })
      end
    end
  end

  def calculate_travel_time(place_detail)
    origin = session[:address]
    # ユーザーがフォームで送信した住所
    destination = place_detail['formatted_address']
    # place_detailで提示された住所

    # セッションから選択された交通手段を取得し、それが「車」であるかどうかをチェック
    if session[:selected_transport] == '車'
      response = @directions_service.get_directions(
        origin,
        destination,
        Time.now.to_i
      )
      # @directions_serviceで定義したget_directionsを使用しoriginからdestinationまでを現在の時間からルート検索する
      if response.success? && response.parsed_response['routes'].any?
        # 上記のresponseとparsed_response['routes']がtrueだった場合 routesについては下記に詳細を記載
        travel_time_text = response.parsed_response['routes'].first['legs'].first['duration']['text']
        # response.parsed_response['routes']で取得した一番最初の['legs']の中の['duration']['text']を取得(ルートの時間)
        convert_duration_to_minutes(travel_time_text)
        # convert_duration_to_minutesを使用しルートの時間を1 hours 30 minsから90に変更(privateに定義)(比較する際に90という形に合わせる為)
      else
        '所要時間の情報は利用できません。'
      end
    elsif session[:selected_transport] == '公共交通機関'
      # セッションから選択された交通手段を取得し、それが「公共交通機関」であるかどうかをチェック
      formatted_origin = @navitime_route_service.geocode_address(origin)
      # 指定された住所を@navitime_route_service.geocode_addressを用いて緯度経度に変換
      formatted_destination = @navitime_route_service.geocode_address(destination)
      response = @navitime_route_service.get_directions(
        formatted_origin, # 上記で定義
        formatted_destination, # 上記で定義
        (Time.now.utc + 9.hours).strftime('%Y-%m-%dT%H:%M:%S')
      ) # 現在のUTC時間から9時間加えて日本の標準時に調整
      # @navitime_route_serviceで定義したget_directionsを使用しstartからgoalまでを現在の時間からルート検索する

      if response.success? && response.parsed_response['items'].any?
        # 上記のresponseとparsed_response['items']がtrueだった場合、itemsについては下記に詳細を記載
        response.parsed_response['items'].first['summary']['move']['time']
        # response.parsed_response['items']で取得した一番最初の['summary']['move']['time']を取得（ルートの時間）
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
    api_key = ENV['GOOGLE_API_KEY'] # 環境変数からGoogle Places APIキーを取得
    @directions_service = GoogleDirectionsService.new(api_key) # GoogleDirectionsServiceクラスのインスタンスを作成し、APIキーを渡す
  end

  def set_navitime_route_service
    api_key = ENV['Rapid_API_KEY'] # 環境変数からNAVITIME APIキーを取得
    @navitime_route_service = NavitimeRouteService.new(api_key) # NavitimeRouteServiceクラスのインスタンスを作成し、APIキーを渡す
  end

  def convert_duration_to_minutes(duration_text)
    # 〜時間〜分を整数に変換する(90という形にする)
    hours = duration_text.scan(/(\d+)\s*hour/).flatten.first.to_i
    # 1時間30分を1 30分という形にする(時間をなくす)
    minutes = duration_text.scan(/(\d+)\s*min/).flatten.first.to_i
    # 1時間30分を1時間30という形にする(分をなくす)
    hours * 60 + minutes
    # 1 30 という形になっているので1に60をかけ(時間を分に直す)30に足す = 90

    # 計算された合計
  end
end
