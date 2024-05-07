# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GooglePlacesService, type: :service do
  let(:service) { described_class.new('test_api_key') }
  let(:place_id) { 'ChIJN1t_tDeuEmsRUsoyG83frY4' }
  let(:photo_reference) { 'CmRaAAAAE3q4oh5qp5uexK-0-T1sgbpJvMr9Kf8T' }

  describe '#search_places' do
    it '適切なエンドポイントに適切なクエリでリクエストを送信していることを確認する' do
      query = { input: '東京タワー', key: 'test_api_key' }
      stub_request(:get, 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json')
        .with(query: hash_including(query))
        .to_return(status: 200, body: { status: 'OK' }.to_json)

      service.search_places('東京タワー')

      expect(WebMock).to have_requested(:get, 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json')
        .with(query: hash_including(query))
    end
  end

  describe '#get_place_details' do
    it '適切なエンドポイントに適切なクエリでリクエストを送信していることを確認する' do
      query = { place_id:, key: 'test_api_key' }
      stub_request(:get, 'https://maps.googleapis.com/maps/api/place/details/json')
        .with(query: hash_including(query))
        .to_return(status: 200, body: { result: {} }.to_json)

      service.get_place_details(place_id)

      expect(WebMock).to have_requested(:get, 'https://maps.googleapis.com/maps/api/place/details/json')
        .with(query: hash_including(query))
    end
  end

  describe '#get_photo' do
    it '正しい写真のURLへのリクエストを送信していることを確認する' do
      photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo_reference}&key=test_api_key"
      stub_request(:get, photo_url)
        .to_return(status: 200, body: '', headers: {})

      expect(service.get_photo(photo_reference)).to be_truthy
      expect(WebMock).to have_requested(:get, photo_url)
    end
  end
end
