# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceFavoritesController, type: :controller do
  let(:user) { create(:user) }
  let(:place) { create(:place, user:) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    render_views

    it 'リクエストが成功すること' do
      get :index
      expect(response).to be_successful
    end

    it 'お気に入りの場所が@placesに割り当てられること' do
      create(:places_favorite, user:, place:)
      get :index
      expect(response.body).to include(place.name)
      expect(response.body).to include(place.address)
    end
  end

  describe 'POST #create' do
    it 'お気に入りを登録できること' do
      expect do
        post :create, params: { place_id: place.id }
      end.to change { PlacesFavorite.count }.by(1)
    end

    it 'turbo_streamのレスポンスが返されること' do
      post :create, params: { place_id: place.id }
      expect(response.media_type).to eq 'text/vnd.turbo-stream.html'
    end
  end

  describe 'DELETE #destroy' do
    let!(:places_favorite) { create(:places_favorite, user:, place:) }

    it 'お気に入りが削除されること' do
      expect do
        delete :destroy, params: { place_id: place.id, id: places_favorite.id }
      end.to change { PlacesFavorite.count }.by(-1)
    end

    it 'turbo_streamのレスポンスが返されること' do
      delete :destroy, params: { place_id: place.id, id: places_favorite.id }
      expect(response.media_type).to eq 'text/vnd.turbo-stream.html'
    end
  end
end
