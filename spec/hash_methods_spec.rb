require 'spec_helper'

class DummyClass
  extend RoyalMailApi::HashMethods
end

describe 'HashMethods' do
  let(:hash) { Fixtures::ParsedResponses.create_shipment }

  it 'recursively searches hashes for keys' do
    expect(DummyClass.retrieve_value(DummyClass.symbolize_keys(hash), :name)).to eq "Mr Tom Smith"
  end

  it 'includes values which are arrays of hashes in its search' do
    expect(DummyClass.retrieve_value(DummyClass.symbolize_keys(hash), :shipment_number)).to eq ["ZTL", "HY188980166GB"]
  end
end
