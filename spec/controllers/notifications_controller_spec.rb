# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
    render_views

    let(:user) { create(:user, email: "user@example.com", password: "password") }
    let(:visitor) { create(:user, email: "visitor@example.com", password: "password") }
    let(:place) { create(:place, user: visitor) }
    let(:review) { create(:review, user: visitor, place: place) }
    let!(:comment) { create(:comment, user: visitor, review: review, body: "コメントが投稿されました") }
    let!(:notification1) { create(:notification, visited: user, visitor: visitor, review: review, comment: comment, notification_type: "comment", read: false, created_at: 1.day.ago) }
    let!(:notification2) { create(:notification, visited: user, visitor: visitor, review: review, notification_type: "like", read: false, created_at: 2.days.ago) }

    before do
        sign_in user
    end

    describe 'GET #index' do
        it 'リクエストが成功すること' do
            get :index
            expect(response).to be_successful
        end

        it 'ユーザーの通知がレスポンスに含まれていること' do
            get :index
            expect(response.body).to include("あなたの投稿")
            expect(response.body).to include("にいいねしました")
            expect(response.body).to include("コメントが投稿されました")
        end

        it '未読の通知が既読になること' do
            get :index
            expect(notification1.reload.read).to be true
            expect(notification2.reload.read).to be true
        end
    end
end
