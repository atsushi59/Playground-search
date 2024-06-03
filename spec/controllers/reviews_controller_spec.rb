# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  render_views
  let(:user) { create(:user) }
  let(:place) { create(:place, user:, address: '東京都千代田区丸の内一丁目９番１号', activity_type: '公園', name: '東京駅') }
  let!(:review) { create(:review, user:, place:, body: '素晴らしい場所です', rating: 5) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'リクエストが成功すること' do
      get :index
      expect(response).to be_successful
    end

    context 'フィルタ機能' do
      let!(:place1) { create(:place, user:, address: '東京', activity_type: '公園', name: '美しい公園') }
      let!(:place2) { create(:place, user:, address: '大阪', activity_type: '室内遊び場', name: '面白い室内遊び場') }
      let!(:place3) { create(:place, user:, address: '京都', activity_type: '公園', name: '静かな公園') }
      let!(:review1) { create(:review, user:, place: place1, body: '美しい公園のレビュー', rating: 4) }
      let!(:review2) { create(:review, user:, place: place2, body: '面白い室内遊び場のレビュー', rating: 3) }
      let!(:review3) { create(:review, user:, place: place3, body: '静かな公園のレビュー', rating: 5) }

      it '住所でフィルタリングできること' do
        get :index, params: { address_cont: '東京' }
        expect(response.body).to include(place1.name)
        expect(response.body).not_to include(place2.name)
        expect(response.body).not_to include(place3.name)
      end

      it 'アクティビティタイプでフィルタリングできること' do
        get :index, params: { activity_type_eq: '公園' }
        expect(response.body).to include(place1.name)
        expect(response.body).to include(place3.name)
        expect(response.body).not_to include(place2.name)
      end

      it 'キーワードでフィルタリングできること' do
        get :index, params: { keyword: '美しい' }
        expect(response.body).to include(place1.name)
        expect(response.body).not_to include(place2.name)
        expect(response.body).not_to include(place3.name)
      end
    end
  end

  describe 'POST #create' do
    it '有効なパラメータの場合 レビューが作成されること' do
      new_user = create(:user)
      new_place = create(:place, user: new_user)
      sign_in new_user

      expect do
        post :create, params: { place_id: new_place.id, review: { body: 'Great place!', rating: 5 } }
      end.to change(Review, :count).by(1)
    end

    context '無効なパラメータの場合' do
      it 'レビューが作成されないこと' do
        expect do
          post :create, params: { place_id: place.id, review: { body: '', rating: '' } }
        end.not_to change(Review, :count)
      end
    end
  end

  describe 'GET #show' do
    it 'リクエストが成功すること' do
      get :show, params: { place_id: place.id, id: review.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'リクエストが成功すること' do
      get :edit, params: { place_id: place.id, id: review.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    context '有効なパラメータの場合' do
      it 'レビューが更新されること' do
        patch :update, params: { place_id: place.id, id: review.id, review: { body: 'Updated review', rating: 4 } }
        review.reload
        expect(review.body).to eq('Updated review')
        expect(review.rating).to eq(4)
      end

      it 'リダイレクトされること' do
        patch :update, params: { place_id: place.id, id: review.id, review: { body: 'Updated review', rating: 4 } }
        expect(response).to redirect_to(place_review_path(place, review))
      end
    end

    context '無効なパラメータの場合' do
      it 'レビューが更新されないこと' do
        patch :update, params: { place_id: place.id, id: review.id, review: { body: '', rating: '' } }
        review.reload
        expect(review.body).not_to eq('')
        expect(review.rating).not_to eq(nil)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'レビューが削除されること' do
      expect do
        delete :destroy, params: { place_id: place.id, id: review.id }
      end.to change(Review, :count).by(-1)
    end

    it 'レビュー一覧画面にリダイレクトされること' do
      delete :destroy, params: { place_id: place.id, id: review.id }
      expect(response).to redirect_to(reviews_path)
    end
  end
end
