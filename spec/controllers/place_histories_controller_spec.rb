# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceHistoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:place) { create(:place, user:) }
  let(:new_place) { create(:place, user:) }
  let!(:place_history) { create(:place_history, user:, place:) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    render_views

    it 'リクエストが成功すること' do
      get :index
      expect(response).to be_successful
    end

    it '訪問履歴の場所が@placesに割り当てられること' do
      get :index
      expect(response.body).to include(place.name)
      expect(response.body).to include(place.address)
    end

    it '@place_historiesが正しく割り当てられること' do
      get :index
      expect(response.body).to include(place.name)
      expect(response.body).to include(place.address)
    end
  end

  describe 'POST #create' do
    it '訪問履歴が作成されること' do
      expect do
        post :create, params: { place_id: new_place.id, destination: '/some_destination' }, format: :json
      end.to change { PlaceHistory.count }.by(1)
    end

    it '正しいJSONレスポンスが返されること' do
      post :create, params: { place_id: new_place.id, destination: '/some_destination' }, format: :json
      json = JSON.parse(response.body)
      expect(json['redirect_to']).to eq('/some_destination')
    end
  end
end
