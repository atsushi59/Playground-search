# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NavitimeRouteService, type: :service do
  let(:api_key) { 'test_api_key' }
  let(:google_api_key) { 'test_google_api_key' }
  let(:service) { described_class.new(api_key) }
  let(:origin) { '東京駅' }
  let(:destination) { '横浜駅' }
  let(:start_time) { '2023-04-01 12:00:00' }

  before do
    allow(ENV).to receive(:[]).with('GOOGLE_API_KEY').and_return(google_api_key)
    response = {
      'results' => [
        {
          'geometry' => {
            'location' => {
              'lat' => 35.681236,
              'lng' => 139.767125
            }
          }
        }
      ]
    }
    allow(HTTParty).to receive(:get).and_return(double(parsed_response: response, success?: true))
  end

  describe '#geocode_address' do
    it '有効な住所を渡した場合、緯度経度に正しく変換されること' do
      expect(service.geocode_address(origin)).to eq('35.681236,139.767125')
    end

    it '無効な住所を渡した場合、エラーメッセージが返されること' do
      allow(HTTParty).to receive(:get).and_return(double(parsed_response: { 'results' => [] }, success?: true))
      expect(service.geocode_address('無効な住所')).to eq('情報を取得できませんでした')
    end
  end

  describe '#get_directions' do
    it '正しい引数を渡した場合、ルート情報を取得できること' do
      allow(service).to receive(:geocode_address).with(origin).and_return('35.681236,139.767125')
      allow(service).to receive(:geocode_address).with(destination).and_return('35.443708,139.638026')
      stub_request(:get, 'https://navitime-route-totalnavi.p.rapidapi.com/route_transit')
        .with(
          headers: {
            'X-RapidAPI-Key' => api_key,
            'X-RapidAPI-Host' => 'navitime-route-totalnavi.p.rapidapi.com'
          },
          query: {
            start: '35.681236,139.767125',
            goal: '35.443708,139.638026',
            start_time: '2023-04-01T12:00:00',
            mode: 'transit'
          }
        )
        .to_return(status: 200, body: { routes: ['route details'] }.to_json)

      response = service.get_directions(origin, destination, start_time)
      expect(response).to include('routes')
    end
  end
end
