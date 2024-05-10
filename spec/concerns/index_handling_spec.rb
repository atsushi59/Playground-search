# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IndexHandling, type: :module do
  let(:dummy_class) do
    Class.new do
      include IndexHandling
      attr_accessor :google_places_service
    end
  end
  let(:instance) { dummy_class.new }
  let(:google_places_service) { instance_double('GooglePlacesService') }

  before do
    instance.google_places_service = google_places_service
  end

  describe '#process_queries' do
    it 'クエリ結果が見つかる場合、候補が正しく処理されること' do
      candidate = { 'place_id' => '123' }
      allow(google_places_service).to receive(:search_places).and_return({ 'candidates' => [candidate] })
      expect(instance).to receive(:process_candidate).with(candidate)
      instance.process_queries(['公園'])
    end
  end
end
