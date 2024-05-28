# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlacesController, type: :controller do
  render_views
  let(:user) { create(:user) }
  let!(:place1) { create(:place, user:, address: '東京', activity_type: '公園', name: '美しい公園') }
  let!(:place2) { create(:place, user:, address: '大阪', activity_type: '室内遊び場', name: '面白い室内遊び場') }
  let!(:place3) { create(:place, user:, address: '京都', activity_type: '公園', name: '静かな公園') }

  before do
    sign_in user
  end

  describe 'GET #index' do
    context 'ユーザーがログインしている場合' do
      it 'リクエストが成功すること' do
        get :index
        expect(response).to be_successful
      end

      it '現在のユーザーの検索した場所がレスポンスに含まれること' do
        get :index
        expect(response.body).to include('美しい公園')
        expect(response.body).to include('面白い室内遊び場')
        expect(response.body).to include('静かな公園')
      end
    end

    context 'ユーザーがログインしていない場合' do
      before do
        sign_out user
      end

      it 'リクエストが失敗し、ログインページにリダイレクトされること' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context '住所でフィルタリングする場合' do
      it '住所に一致する場所が返されること' do
        get :index, params: { address_cont: '東京' }
        expect(response.body).to include('美しい公園')
        expect(response.body).not_to include('面白い室内遊び場')
        expect(response.body).not_to include('静かな公園')
      end
    end

    context '活動タイプでフィルタリングする場合' do
      it '活動タイプに一致する場所が返されること' do
        get :index, params: { activity_type_eq: '公園' }
        expect(response.body).to include('美しい公園')
        expect(response.body).to include('静かな公園')
        expect(response.body).not_to include('面白い室内遊び場')
      end
    end

    context 'キーワードでフィルタリングする場合' do
      it 'キーワードに一致する場所が返されること' do
        get :index, params: { keyword: '美しい' }
        expect(response.body).to include('美しい公園')
        expect(response.body).not_to include('面白い室内遊び場')
        expect(response.body).not_to include('静かな公園')
      end
    end
  end
end
