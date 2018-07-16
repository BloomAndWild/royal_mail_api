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
      service: 'tracked_high_volume',
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

      it "includes dateTime" do
        expect(@response.body).to have_hash_key :date_time
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

  describe "service code" do
    let(:xml) { described_class.new(:create_shipment).build_xml(base_attrs) }

    context "THV (Tracked High Volume) service" do
      it "uses the correct Royal Mail service code" do
        expect(xml).to include 'TPM'
      end
    end
  end

  context 'configuration' do
    before { configure_client }

    subject { described_class.new(:create_shipment) }

    describe '#config' do
      it 'creates a copy of the master config object' do
        expect(subject.config).not_to eql(described_class.config)
      end
    end

    describe '#configure' do
      it 'yields the config object' do
        expect { |b| subject.configure(&b) }.to yield_with_args(subject.config)
      end
    end
  end

  context 'get_single_item_history' do
    before { configure_client }

    let(:application_id) { 123 }
    let(:transaction_id) { 999 }
    let(:attrs) do
      {
        service: 'tracked_high_volume'
      }
    end

    subject { described_class.new(:get_single_item_history) }
    let(:xml) { subject.build_xml(attrs) }

    it 'generates the expected xml' do
      expect(xml).to include 'getSingleItemHistoryRequest'
    end
  end
end
