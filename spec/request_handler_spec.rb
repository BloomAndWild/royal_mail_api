require 'spec_helper'

describe RoyalMailApi::RequestHandler do
  let(:attrs) {
    {
      transaction_id: 1,
      shipping_date: (Time.now+(24*60*60*7)).strftime('%Y-%m-%d'),
      user_name: 'Mr Tom Smith',
      country_code: '0044',
      telephone_number: '07804949595',
      email: 'tom.smith@royalmail.com',
      address_line1: '44-46 Morningside Road',
      post_town: 'Edinburgh',
      post_code: 'EH10 4BF',
      weight: 900
    }
  }

  around do |spec|
    configure_client

    VCR.use_cassette("create_shipment") do
      @response = RoyalMailApi::RequestHandler.request(:create_shipment, attrs)
      spec.run
    end
  end

  describe '#create_shipment' do
    it 'returns a parsed hash of the xml response' do
      expect(@response.body).to be_a Hash
    end

    it 'returns a tracking code for tracked shipments' do
      expect(@response.body).to have_hash_key :shipment_number
    end
  end
end
