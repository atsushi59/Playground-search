# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchHandling, type: :module do
  let(:dummy_class) do
    Class.new do
      include SearchHandling
      attr_accessor :params, :session, :flash

      def initialize
        @session = {}
        @flash = {}
      end

      def redirect_to(path)
        @redirect_path = path
      end

      def root_path
        '/' # 仮のroot_path
      end
    end
  end

  let(:dummy_instance) { dummy_class.new }

  before do
    dummy_instance.params = ActionController::Parameters.new({
                                                               selected_transport: '車',
                                                               address: '東京駅',
                                                               selected_time: '30分',
                                                               selected_activity: '公園',
                                                               selected_age: '3歳以下'
                                                             })
  end

  describe '#setup_session' do
    it '有効なパラメータをセッションに保存する' do
      dummy_instance.setup_session
      expect(dummy_instance.session['selected_transport']).to eq('車')
    end
  end

  describe '#generate_user_input' do
    it 'ユーザー入力から適切なリクエスト文字列を生成する' do
      expected_string = '東京駅から車で正確に30分で到着する3歳以下の子供が遊べる公園を場所の正式名称のみ8件回答してください。なるべく過去に回答していない場所を提示してください。'
      expect(dummy_instance.generate_user_input).to eq(expected_string)
    end
  end
end
