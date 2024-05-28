# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
    let(:user) { create(:user, email: 'user@example.com', password: 'password', name: 'Test User') }

    before do
        sign_in user
    end

    describe 'GET #show' do
        it 'リクエストが成功すること' do
        get :show
        expect(response).to be_successful
        end
    end

    describe 'GET #edit' do
        it 'リクエストが成功すること' do
        get :edit
        expect(response).to be_successful
        end

    end

    describe 'PATCH #update' do
        context '有効なパラメータの場合' do
            it 'ユーザーが更新されること' do
                patch :update, params: { user: { name: 'Updated Name' } }
                user.reload
                expect(user.name).to eq('Updated Name')
            end

            it 'リダイレクトされること' do
                patch :update, params: { user: { name: 'Updated Name' } }
                expect(response).to redirect_to(profiles_path)
            end

            it 'フラッシュメッセージが設定されること' do
                patch :update, params: { user: { name: 'Updated Name' } }
                expect(flash[:notice]).to eq('更新に成功しました')
            end
        end

        context '無効なパラメータの場合' do
            it 'ユーザーが更新されないこと' do
                patch :update, params: { user: { email: '' } }
                user.reload
                expect(user.email).to eq('user@example.com')
            end

            it 'フラッシュメッセージが設定されること' do
                patch :update, params: { user: { email: '' } }
                expect(flash.now[:alert]).to eq('更新に失敗しました')
            end
        end
    end
end
