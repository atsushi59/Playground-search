# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do

    describe 'Googleによる認証' do
        before do
            request.env['devise.mapping'] = Devise.mappings[:user]
            OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                provider: 'google_oauth2',
                uid: '123456',
                info: {
                email: 'test@example.com',
                name: 'test user'
                },
                credentials: {
                token: 'mock_token',
                refresh_token: 'mock_refresh_token'
                }
            })
            request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
        end
    
        context '認証が成功した場合' do
            it 'ユーザーをサインインさせ、リダイレクトする' do
                user = create(:user)
                allow(User).to receive(:from_omniauth).and_return(user)
                allow(user).to receive(:persisted?).and_return(true)
        
                get :google_oauth2
        
                expect(controller.current_user).to eq(user)
                expect(response).to redirect_to(root_path)
                expect(flash[:notice]).to eq('Google アカウントによる認証に成功しました。')
            end
        end
    
        context '認証が失敗した場合' do
            it '新規登録ページにリダイレクトする' do
                user = build(:user)
                allow(User).to receive(:from_omniauth).and_return(user)
                allow(user).to receive(:persisted?).and_return(false)
        
                get :google_oauth2
        
                expect(response).to redirect_to(new_user_registration_url)
                expect(session['devise.google_data']).to eq(request.env['omniauth.auth'].except('extra'))
            end
        end
    end
end