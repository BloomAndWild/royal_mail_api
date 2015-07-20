# require 'spec_helper'
# require 'vcr'
# require 'pry'

# VCR.configure do |config|
#   config.cassette_library_dir = "support/fixtures/vcr_cassettes"
#   config.hook_into :webmock
# end

# def fake_response
#   # binding.pry
#   return HTTPI::Response.new(200, {}, 'hi')
# end

# describe RoyalMailApi::RequestHandler do
#   describe '#create_shipment' do
#     before do
#       allow(Savon::Operation).to receive(:ensure_exists!)
#       allow(Savon::Operation).to receive(:build)
#       allow(Savon::Operation).to receive(:notify_observers)
#       allow(Savon::Operation).to receive(:call_with_logging).and_return(fake_response)
#     end

#     it 'returns ' do
#       VCR.use_cassette("create_shipment") do
#         response = RoyalMailApi::RequestHandler.create_shipment({})
#         expect response.body.to eq 'hi'
#       end
#     end
#   end
# end
