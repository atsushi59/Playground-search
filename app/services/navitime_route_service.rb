require 'httparty'

class NavitimeRouteService
  include HTTParty
  base_uri 'https://navitime-route-totalnavi.p.rapidapi.com'

  def initialize(api_key)
    @api_key = api_key #api_keyの初期化下も
    @google_api_key = ENV['GOOGLE_API_KEY']
    @options = { #APIリクエスト時にHTTPartyライブラリが使用するヘッダー情報を設定
      headers: { 
        "X-RapidAPI-Key" => @api_key,
        "X-RapidAPI-Host" => "navitime-route-totalnavi.p.rapidapi.com"
      }
    }
  end

  # 住所を緯度経度に変換
  def geocode_address(address)
    query = { #query というハッシュを定義 addressキーに引数で受け取った住所をGoogle APIのキーインスタンス変数 @google_api_key から取得）を設定
      address: address,
      key: @google_api_key
    }
    response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json", query: query)
    #HTTParty.get メソッドを使用して、GoogleのGeocoding APIエンドポイントにGETリクエストを送信 query ハッシュがクエリパラメータとして付加
    if response.success?
      #APIリクエストが成功したか
      results = response.parsed_response["results"]
      #APIからのレスポンスを解析し、その中の "results" キーに対応する値を results 変数に格納
      if results.any?
      #results 配列に何か要素が含まれているかどうかを確認
        location = results.first["geometry"]["location"]
        #results 配列の最初の要素から "geometry" キーの "location" キーにアクセスし、その値を location 変数に格納(住所に対応する緯度と経度を含むハッシュ)
        return "#{location['lat']},#{location['lng']}"
        #location ハッシュから緯度（'lat'）と経度（'lng'）を取り出し、これらをカンマで区切った文字列として返す
      end
    end
    "情報を取得できませんでした"
  end

  # get_directionsメソッドは指定されたパラメータを受け取りAPIリクエストを実行します
  def get_directions(origin, destination,start_time)

    formatted_origin = geocode_address(origin)
    #originで取得した住所を緯度経度に変換
    formatted_destination = geocode_address(destination)
    #destinationで取得した住所を緯度経度に変換
    formatted_time = format_departure_time(start_time)
    #format_departure_time(start_time)で定義したのを使う

    query_options = {
      query: {
        start: formatted_origin, #start(必須)
        goal: formatted_destination, #goal(必須)
        start_time: formatted_time, #(省略可だが日にちの指定は必須)
        mode: 'transit'  # 'transit'をデフォルトとして指定(省略可)
      }
    }
    self.class.get('/route_transit', @options.merge(query_options))
    #/route_transit公式に書いてあるエンドポイント
  end


  private

  def format_departure_time(start_time)
    Time.parse(start_time).strftime('%Y-%m-%dT%H:%M:%S')
    #start_time 文字列を解析してISO 8601形式の日時文字列に変換
  end
end