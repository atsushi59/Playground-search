# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewFavoritesController, type: :controller do
    render_views
    let(:user) { create(:user) }
    let(:place) { create(:place, user: user) }
    let(:review) { create(:review, user: user, place: place) }
    let!(:review_favorite) { create(:review_favorite, user: user, review: review) }

    before do
        sign_in user
    end

    describe 'GET #index' do
        it 'リクエストが成功すること' do
            get :index
            expect(response).to be_successful
        end
    end

    describe 'POST #create' do
        it 'レビューがお気に入りに追加されること' do
            expect do
                    post :create, params: { review_id: review.id, place_id: review.place.id }
            end.to change(ReviewFavorite, :count).by(0)
        end
    end

    describe 'DELETE #destroy' do
        it 'レビューがお気に入りから削除されること' do
            expect do
                    delete :destroy, params: { review_id: review.id, place_id: review.place.id }
            end.to change(ReviewFavorite, :count).by(-1)
        end
    end
end
