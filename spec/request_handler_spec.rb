require 'spec_helper'

describe RoyalMailApi::RequestHandler do
  let(:base_attrs) {
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

  describe 'requests' do
    around do |spec|
      configure_client

      VCR.use_cassette(default_cassette) do
        @response = RoyalMailApi::RequestHandler.request(:create_shipment, attrs)
        spec.run
      end
    end

    describe '#create_shipment' do
      let(:attrs) { base_attrs }
      let(:default_cassette) { "create_shipment" }

      it "returns a parsed hash of the xml response" do
        expect(@response.body).to be_a Hash
      end

      it "returns a tracking code for tracked shipments" do
        expect(@response.body).to have_hash_key :shipment_number
      end
    end

    describe "with special characters" do
      let(:attrs) {base_attrs.merge({ user_name: 'Bloom & Wild Unit 2.22' }) }
      let(:default_cassette) { "special_characters" }

      it "are converted to xml entity references" do
        expect(@response.http.code).to eq 200
      end
    end
  end

  # seems to be fixed on RM's end, TODO: test.
  xdescribe "parsing Savon::SOAPFault errors" do
    let(:attrs) { base_attrs.merge({ user_name: 'Bloom & Wild Unit 2.22' }) }

    before do
      stub_const("XmlBuilder::SPECIAL_CHARACTER_MAP", {})
    end

    it "raises a RoyalMailApi::SoapError" do
      configure_client

      VCR.use_cassette("Savon::SOAPFault") do
        expect{ RoyalMailApi::RequestHandler.request(:create_shipment, attrs) }.to raise_error RoyalMailApi::SoapError
        expect(@response.description).to eq "env:Client error: The message was incorrectly formed or contained incorrect information."
        expect(@response.code).to eq 500
      end
    end
  end
end
