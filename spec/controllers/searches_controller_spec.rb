require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
    let(:chatgpt_service) { instance_double(ChatgptService) }
    let(:successful_response) do
        double("response", success?: true,
                    parsed_response: { "choices" => [{ "message" => { "content" => "1. 場所名\n2. 別の場所" } }] })
        end

    before do
        allow(ChatgptService).to receive(:new).and_return(chatgpt_service)
        allow(chatgpt_service).to receive(:create_chat_completion).and_return(successful_response)
        allow(controller).to receive(:set_google_places_service)
        allow(controller).to receive(:set_directions_service)
        allow(controller).to receive(:set_navitime_route_service)
    end

    describe "GET #search" do
        it "セッションが正しく設定されること" do
            expect(controller).to receive(:setup_session)
            get :search
        end

        it "ユーザー入力が正しく生成されること" do
            expect(controller).to receive(:generate_user_input).and_call_original
            get :search
        end

        it "ChatgptServiceにメッセージが正しく送信されること" do
            expect(chatgpt_service).to receive(:create_chat_completion).with(an_instance_of(Array))
            get :search
        end

        it "ChatgptServiceからの応答が適切に処理されること" do
            expect(controller).to receive(:handle_response).with(successful_response)
            get :search
        end

        it "処理成功後に適切なパスにリダイレクトされること" do
            get :search
            expect(response).to redirect_to(index_path)
        end
    end

    describe "GET #index" do
        let(:queries) { "1. First Query\n2. Second Query" }

        before do
            allow(controller).to receive(:process_queries) # process_queriesをモック
        end

        it "セッションからクエリを抽出して処理すること" do
            session[:query] = queries
            get :index
            expect(controller).to have_received(:process_queries).with(["First Query", "Second Query"])
        end
    end

    let(:origin) { "新宿駅" }
    let(:destination) { "渋谷駅" }
    let(:place_detail) { { "formatted_address" => destination } }

    describe "calculate_travel_time" do
        before do
            allow(controller).to receive(:session).and_return({
                                                                address: origin,
                                                                selected_transport: transport_mode
                                                            })
        end

        context "車を選択した場合" do
            let(:transport_mode) { "車" }

            it "車での旅行時間が正しく計算されること" do
                expect(controller).to receive(:calculate_travel_time_by_car).with(origin, destination).and_return(45)
                controller.calculate_travel_time(place_detail)
                expect(place_detail["travel_time_text"]).to eq(45)
            end
        end

        context "公共交通機関を選択した場合" do
            let(:transport_mode) { "公共交通機関" }

            it "公共交通機関での旅行時間が正しく計算されること" do
                expect(controller).to receive(:calculate_travel_time_by_public_transport).with(origin,destination).and_return(60)
                controller.calculate_travel_time(place_detail)
                expect(place_detail["travel_time_text"]).to eq(60)
            end
        end

        context "無効な交通手段を選択した場合" do
            let(:transport_mode) { "未知の手段" }

            it "旅行時間情報が利用できないことを通知する" do
                expect(controller.calculate_time_based_on_mode(origin, destination, transport_mode)).to eq("所要時間の情報は利用できません。")
            end
        end
    end  
end
