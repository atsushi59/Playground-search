# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Devise::SessionsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    let(:user) { FactoryBot.create(:user, email: 'test@example.com', password: 'password123', password_confirmation: 'password123') }

    context 'with valid attributes' do
      it 'ログインに成功する' do
        post :create, params: { user: { email: user.email, password: user.password } }
        expect(controller.current_user).to eq(user)
      end

      it 'ルートパスにリダイレクトする' do
        post :create, params: { user: { email: user.email, password: user.password } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid attributes' do
      it 'ログインに失敗する' do
        post :create, params: { user: { email: user.email, password: 'wrongpassword' } }
        expect(controller.current_user).to be_nil
      end

      it '再度ログインページを表示する' do
        post :create, params: { user: { email: user.email, password: 'wrongpassword' } }
        expect(response).to render_template('devise/sessions/new')
      end
    end
  end
end
