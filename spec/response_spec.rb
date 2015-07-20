require 'spec_helper'

class DummyClass
  extend RoyalMailApi::HashMethods
end

describe RoyalMailApi::Response do
  let(:hash) { Fixtures::ParsedResponses.create_shipment }
  let(:parsed_response) { DummyClass.symbolize_keys(hash) }

  it 'creates value objects for shipments' do
    expect(RoyalMailApi::Response.new(parsed_response: parsed_response).shipments.first).to be_a Struct
  end

  it 'sets the correct values for each value object' do
    shipment = RoyalMailApi::Response.new(parsed_response: parsed_response).shipments[0]

    expect(shipment.item_id).to eq "1000076"
    expect(shipment.shipment_number).to eq "HY188980152GB"
    expect(shipment.status_code).to eq "Allocated"
    expect(shipment.valid_from).to eq "2015-02-09T09:52:06.000+02:00"
  end
end
