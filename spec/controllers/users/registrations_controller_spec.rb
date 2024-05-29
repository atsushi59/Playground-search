# spec/controllers/devise/registrations_controller_spec.rb
require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :controller do
    before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    describe 'POST #create' do
        context 'with valid attributes' do
            it '新しいユーザーを作成する' do
                expect {
                post :create, params: { user: { name: 'sample', email: 'test@example.com', password: 'password123', password_confirmation: 'password123' } }
                }.to change(User, :count).by(1)
            end

            it 'ルートパスにリダイレクトする' do
                post :create, params: { user: { name: 'sample', email: 'test@example.com', password: 'password123', password_confirmation: 'password123' } }
                expect(response).to redirect_to(root_path)
            end
        end

        context 'with invalid attributes' do
            it '新しいユーザーを作成しない' do
                expect {
                post :create, params: { user: { name: '', email: 'invalid', password: 'short', password_confirmation: 'short' } }
                }.to_not change(User, :count)
            end

            it '新規登録テンプレートを再レンダリングする' do
                post :create, params: { user: { name: '', email: 'invalid', password: 'short', password_confirmation: 'short' } }
                expect(response).to render_template('devise/registrations/new')
            end
        end
    end
end
