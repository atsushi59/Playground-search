
require "rails_helper"

RSpec.describe GoogleDirectionsService, type: :service do
    let(:api_key) { "test_api_key" } 
    let(:service) { described_class.new(api_key) }
    let(:origin) { "Tokyo Station" }
    let(:destination) { "Yokohama Station" } 
    let(:departure_time) { "now" }

    describe "#get_directions" do
        it "適切なエンドポイントに適切なクエリパラメータでリクエストを送信していることを確認する" do
            stub_request(:get, "https://maps.googleapis.com/maps/api/directions/json")
                .with(query: {
                    origin: origin,
                    destination: destination,
                    mode: "driving",
                    departure_time: departure_time,
                    key: api_key
                })
                .to_return(status: 200, body: { routes: [] }.to_json)

                response = service.get_directions(origin, destination, departure_time)

                expect(WebMock).to have_requested(:get, "https://maps.googleapis.com/maps/api/directions/json")
                .with(query: {
                    origin: origin,
                    destination: destination,
                    mode: "driving",
                    departure_time: departure_time,
                    key: api_key
                })
                expect(response).to be_a(HTTParty::Response)
                expect(response.parsed_response).to include("routes")
        end
    end
end
