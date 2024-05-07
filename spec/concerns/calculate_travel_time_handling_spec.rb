# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateTravelTimeHandling, type: :module do
  include described_class

  let(:origin) { '新宿駅' }
  let(:destination) { '渋谷駅' }
  let(:directions_service) { instance_double('DirectionsService') }
  let(:navitime_route_service) { instance_double('NavitimeRouteService') }
  let(:directions_response) do
    double('HTTParty::Response', success?: true,
                                 parsed_response: { 'routes' => [{ 'legs' => [{ 'duration' => { 'text' => '1 hour 30 mins' } }] }] })
  end

  let(:navitime_response) do
    double('HTTParty::Response', success?: true,
                                 parsed_response: { 'items' => [{ 'summary' => { 'move' => { 'time' => 90 } } }] })
  end

  before do
    @directions_service = directions_service
    @navitime_route_service = navitime_route_service
    allow(directions_service).to receive(:get_directions).and_return(directions_response)
    allow(navitime_route_service).to receive(:geocode_address).with(origin).and_return('35.6895,139.6917')
    allow(navitime_route_service).to receive(:geocode_address).with(destination).and_return('35.6581,139.7017')
    allow(navitime_route_service).to receive(:get_directions).and_return(navitime_response)
  end

  describe '#calculate_travel_time_by_car' do
    it '有効な出発地と目的地を渡した場合、車での旅行時間が正しく計算されること' do
      expect(calculate_travel_time_by_car(origin, destination)).to eq(90)
    end
  end

  describe '#calculate_travel_time_by_public_transport' do
    it '有効な出発地と目的地を渡した場合、公共交通機関での旅行時間が正しく計算されること' do
      expect(calculate_travel_time_by_public_transport(origin, destination)).to eq(90)
    end
  end
end
