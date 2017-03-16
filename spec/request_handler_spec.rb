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
      weight: 900,
      service: 'tracked',
    }
  }

  describe '#create_shipment request' do
    around do |spec|
      configure_client

      VCR.use_cassette(default_cassette) do
        @response = RoyalMailApi::RequestHandler.request(:create_shipment, attrs)
        spec.run
      end
    end

    let(:attrs) { base_attrs }
    let(:default_cassette) { "create_shipment" }

    it "returns a parsed hash of the xml response" do
      expect(@response.body).to be_a Hash
    end

    it "returns a tracking code for tracked shipments" do
      expect(@response.body).to have_hash_key :shipment_number
    end

    describe "with special characters" do
      let(:attrs) {base_attrs.merge({ user_name: 'Bloom & Wild Unit 2.22' }) }
      let(:default_cassette) { "special_characters" }

      it "are converted to xml entity references" do
        expect(@response.http.code).to eq 200
      end
    end
  end

  describe "#cancel_shipment_request" do
    let(:book_shipment) do
      RoyalMailApi::RequestHandler.request(:create_shipment, base_attrs)
    end

    let(:booked_shipment_number) do
      RoyalMailApi::ResponseHandler
        .handle_response(book_shipment)
        .shipments[0]
        .shipment_number
    end

    let(:cancel_shipment_response) do
      RoyalMailApi::ResponseHandler.handle_response(
        RoyalMailApi::RequestHandler.request(
          :cancel_shipment,
          tracked_number: booked_shipment_number,
          transaction_id: 1,
        )
      )
    end

    let(:cancellation) { cancel_shipment_response.cancellations[0] }

    around do |spec|
      configure_client

      VCR.use_cassette("cancel_shipment") do
        spec.run
      end
    end

    it "cancels the shipment" do
      expect(cancellation.code).to eq 'Cancelled'
      expect(cancellation.shipment_number).to eq booked_shipment_number
    end
  end

  describe "service code" do
    let(:xml) { described_class.new(:create_shipment).build_xml(base_attrs) }

    context "tracked service" do
      it "uses the correct Royal Mail service code" do
        expect(xml).to include 'TPN'
      end
    end

    context "THV (Tracked High Volume) service" do
      it "uses the correct Royal Mail service code" do
        base_attrs[:service] = 'tracked_high_volume'
        expect(xml).to include 'TPM'
      end
    end
  end

  describe "parsing Savon::SOAPFault errors" do
    let(:attrs) { base_attrs.merge({ user_name: 'Bloom & Wild Unit 2.22' }) }

    before do
      stub_const("XmlBuilder::SPECIAL_CHARACTER_MAP", {'&' => '&'})
    end

    it "raises a RoyalMailApi::SoapError" do
      configure_client

      VCR.use_cassette("Savon::SOAPFault") do
        expect{ RoyalMailApi::RequestHandler.request(:create_shipment, attrs) }.to raise_error RoyalMailApi::SoapError
        # expect(@response.description).to eq "env:Client error: The message was incorrectly formed or contained incorrect information."
        # expect(@response.code).to eq 500
      end
    end
  end
end
