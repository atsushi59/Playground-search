# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
    let(:user) { create(:user) }
    let(:place) { create(:place, user: user) }
    let(:review) { create(:review, user: user, place: place) }
    let(:comment) { create(:comment, user: user, review: review) }

    before do
        sign_in user
    end

    describe 'POST #create' do
        context '有効なパラメータの場合' do
            it 'コメントが作成されること' do
                expect do
                post :create, params: { review_id: review.id, place_id: place.id, comment: { body: '素晴らしいレビューです' } }
                end.to change(Comment, :count).by(1)
            end

            it 'リダイレクトされること' do
                post :create, params: { review_id: review.id, place_id: place.id, comment: { body: '素晴らしいレビューです' } }
                expect(response).to redirect_to(place_review_path(place, review))
                expect(flash[:notice]).to eq('コメントが投稿されました')
            end
        end

        context '無効なパラメータの場合' do
            it 'コメントが作成されないこと' do
                expect do
                post :create, params: { review_id: review.id, place_id: place.id, comment: { body: '' } }
                end.not_to change(Comment, :count)
            end

            it 'リダイレクトされること' do
                post :create, params: { review_id: review.id, place_id: place.id, comment: { body: '' } }
                expect(response).to redirect_to(place_review_path(place, review))
                expect(flash[:alert]).to eq('コメントの投稿に失敗しました')
            end
        end
    end

    describe 'DELETE #destroy' do
        context 'コメントが存在する場合' do
            before { comment }

            it 'コメントが削除されること' do
                expect do
                delete :destroy, params: { review_id: review.id, place_id: place.id, id: comment.id }
                end.to change(Comment, :count).by(-1)
            end

            it 'リダイレクトされること' do
                delete :destroy, params: { review_id: review.id, place_id: place.id, id: comment.id }
                expect(response).to redirect_to(place_review_path(place, review))
                expect(flash[:notice]).to eq('コメントが削除されました')
            end
        end
    end
end
