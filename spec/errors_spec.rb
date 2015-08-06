require 'spec_helper'

describe 'Errors' do
  let(:valid_attrs) {
    {
      transaction_id: 1,
      shipping_date: (Time.now+(24*60*60*7)).strftime('%Y-%m-%d'),
      user_name: 'Mr Tom Smith',
      email: 'tom.smith@royalmail.com',
      address_line1: '44-46 Morningside Road',
      post_town: 'Edinburgh',
      post_code: 'EH10 4BF',
      weight: 900
    }
  }

  before { configure_client }

  describe 'errors' do
    context 'single error' do
      it 'returns an array containing the error' do
        attrs = valid_attrs.merge({
          shipping_date: (Time.now+(24*60*60*70)).strftime('%Y-%m-%d')
        })

        VCR.use_cassette("single_error") do
          response = RoyalMailApi::RequestHandler.request(:create_shipment, attrs)
          parsed_response = RoyalMailApi::ResponseHandler.handle_response(response)
          expect(parsed_response.errors.count).to eq 1
          expect(parsed_response.errors.first.description).to_not be_nil
        end
      end
    end

    context 'multiple errors' do
      it 'returns an array containing all errors' do
        attrs = valid_attrs.merge({
          shipping_date: (Time.now+(24*60*60*70)).strftime('%Y-%m-%d'),
          post_code: 'SDGSDGSDGDS'
        })

        VCR.use_cassette("multiple_errors") do
          response = RoyalMailApi::RequestHandler.request(:create_shipment, attrs)
          parsed_response = RoyalMailApi::ResponseHandler.handle_response(response)
          expect(parsed_response.errors.count).to eq 2
        end
      end
    end

    context 'no errors' do
      it 'returns an empty array' do
        VCR.use_cassette("no_errors") do
          response = RoyalMailApi::RequestHandler.request(:create_shipment, valid_attrs)
          parsed_response = RoyalMailApi::ResponseHandler.handle_response(response)
          expect(parsed_response.errors.count).to eq 0
        end
      end
    end
  end
end
