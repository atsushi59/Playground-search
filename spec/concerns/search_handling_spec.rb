
require "rails_helper"

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
                '/'  # 仮のroot_path
            end
        end
    end

    let(:dummy_instance) { dummy_class.new }

    before do
        dummy_instance.params = ActionController::Parameters.new({
            selected_transport: "車",
            address: "東京駅",
            selected_time: "30分",
            selected_activity: "公園",
            selected_age: "幼児"
        })
    end

    describe "#setup_session" do
        it "有効なパラメータをセッションに保存する" do
            dummy_instance.setup_session
            expect(dummy_instance.session['selected_transport']).to eq("車") 
        end
    end

    describe "#generate_user_input" do
        it "ユーザー入力から適切なリクエスト文字列を生成する" do
            expected_string = "東京駅から車で30分以内で幼児の子供が対象の公園できる場所を正式名称で2件提示してください"
            expect(dummy_instance.generate_user_input).to eq(expected_string)
        end
    end

    describe "#handle_response" do
        context "エラー応答の場合" do
            let(:error_response) do
                instance_double(HTTParty::Response, success?: false, parsed_response: { "error" => { "message" => "アクセス拒否" } })
            end

            it "適切にリダイレクトし、フラッシュメッセージを設定する" do
                dummy_instance.handle_response(error_response)
                expect(dummy_instance.flash[:danger]).to eq('検索に失敗しました')
                expect(dummy_instance.instance_variable_get(:@redirect_path)).to eq(dummy_instance.root_path)
            end
        end
    end
end
