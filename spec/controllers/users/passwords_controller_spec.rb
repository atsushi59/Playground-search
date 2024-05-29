# spec/requests/password_resets_spec.rb
require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
    let(:user) { FactoryBot.create(:user, email: 'test@example.com', password: 'oldpassword', password_confirmation: 'oldpassword') }

    describe "POST /password" do
        it "パスワードリセットメールを送信する" do
            post user_password_path, params: { user: { email: user.email } }
            expect(response).to redirect_to(new_user_session_path)
            expect(ActionMailer::Base.deliveries.size).to eq(1)
            mail = ActionMailer::Base.deliveries.last
            expect(mail.to).to include(user.email)
            expect(mail.subject).to eq("パスワードの再設定について")
        end
    end

    describe 'PUT /password' do
        context 'with valid password' do
            it 'パスワードを変更する' do
                put user_password_path, params: { user: { reset_password_token: user.send(:set_reset_password_token), password: 'newpassword', password_confirmation: 'newpassword' } }
                user.reload
                expect(user.valid_password?('newpassword')).to be_truthy
            end

            it 'ルートパスにリダイレクトする' do
                put user_password_path, params: { user: { reset_password_token: user.send(:set_reset_password_token), password: 'newpassword', password_confirmation: 'newpassword' } }
                expect(response).to redirect_to(root_path)
            end
        end
    end    
end
