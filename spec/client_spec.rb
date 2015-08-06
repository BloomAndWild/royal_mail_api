require 'spec_helper'

describe RoyalMailApi::Client do
  describe 'configuration' do
    let(:client) { RoyalMailApi::Client }
    let(:config) { client.config }

    before do
      client.configure do |config|
        config.username = 'srik'
        config.password = 'foobar'
      end
    end

    it 'should set the username' do
      expect(config.username).to eq 'srik'
    end

    it 'should set the password' do
      expect(config.password).to eq 'foobar'
    end
  end
end
