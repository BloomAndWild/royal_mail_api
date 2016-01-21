require 'spec_helper'

describe 'Warnings' do
  let(:attrs) {
    {
      transaction_id: 1,
      shipping_date: (Date.today + 7).to_s,
      user_name: 'Mr Tom Smith',
      email: 'tom.smith@royalmail.com',
      address_line1: '44-46 Morningside Road',
      post_town: 'Edinburgh',
      post_code: 'EH10 4BF',
      weight: 900
    }
  } 

  before { configure_client }

  describe 'warnings' do
    it 'returns an array containing the error' do
      VCR.use_cassette("warnings") do
        response = RoyalMailApi::RequestHandler.request(:create_shipment, attrs)
        parsed_response = RoyalMailApi::ResponseHandler.handle_response(response)
        expect(parsed_response.warnings.count).to eq 2
        expect(parsed_response.warnings.first.description).to_not be nil
        expect(parsed_response.warnings.first.description).to_not be_empty
      end
    end
  end
end
