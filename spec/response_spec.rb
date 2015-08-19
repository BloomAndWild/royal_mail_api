require 'spec_helper'

describe RoyalMailApi::ResponseHandler do
  let(:attrs) {
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

  around do |spec|
    configure_client

    VCR.use_cassette("response") do
      @response = RoyalMailApi::RequestHandler.request(:create_shipment, attrs)
      @response = RoyalMailApi::ResponseHandler.handle_response(@response)

      spec.run
    end
  end

  it 'returns a response object' do
    expect(@response.body).to be_a String
    expect(@response.http).to be_a HTTPI::Response
    expect(@response.shipments).to be_a Array
    expect(@response.errors).to be_a Array
    expect(@response.warnings).to be_a Array
  end

  it 'creates value objects for shipments' do
    expect(@response.shipments.first).to be_a Struct
  end

  it 'sets the correct values for each shipment' do
    shipment = @response.shipments.first
    expect(shipment.item_id).to_not be_nil
    expect(shipment.shipment_number).to include 'GB'
    expect(shipment.valid_from).to_not be_nil
  end
end
