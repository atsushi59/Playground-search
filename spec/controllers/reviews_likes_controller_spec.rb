# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewsLikesController, type: :controller do
  let(:user) { create(:user) }
  let(:place) { create(:place, user: user) }
  let(:review) { create(:review, user: user, place: place) }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'ユーザーがレビューに「いいね！」をしたとき' do
      it '「いいね！」が作成されること' do
        expect do
          post :create, params: { place_id: place.id, review_id: review.id }, format: :turbo_stream
        end.to change(ReviewsLike, :count).by(1)
      end

      it '通知が作成されること' do
        expect do
          post :create, params: { place_id: place.id, review_id: review.id }, format: :turbo_stream
        end.to change(Notification, :count).by(1)
      end
    end

    context 'ユーザーが既にレビューに「いいね！」している場合' do
      before do
        review.reviews_likes.create(user: user)
      end

      it '新しい「いいね！」が作成されないこと' do
        expect do
          post :create, params: { place_id: place.id, review_id: review.id }, format: :turbo_stream
        end.not_to change(ReviewsLike, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      review.reviews_likes.create(user: user)
    end

    it '「いいね！」が削除されること' do
      expect do
        delete :destroy, params: { place_id: place.id, review_id: review.id }, format: :turbo_stream
      end.to change(ReviewsLike, :count).by(-1)
    end

  end
end
