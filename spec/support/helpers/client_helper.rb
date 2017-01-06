def configure_client
  RoyalMailApi::Client.configure do |config|
    config.application_id = ENV['RM_APPLICATION_ID']
    config.username = ENV['RM_USERNAME']
    config.password = ENV['RM_PASSWORD']
    config.adapter = :httpclient
    config.shipping_wsdl = File.join(RoyalMailApi.root, 'lib', 'wsdl', 'ShippingAPI_V2_0_9.wsdl')
    config.tracking_wsdl = File.join(RoyalMailApi.root, 'lib', 'wsdl', 'Tracking_API_V1.2.wsdl')
    config.shipping_endpoint = 'https://api.royalmail.net/shipping/v2'
    config.tracking_endpoint = 'https://api.royalmail.com/tracking'
    config.logger = Logger.new(STDOUT)
    config.headers = {
      'client_id' => ENV['RM_CLIENT_ID'],
      'client_secret' => ENV['RM_CLIENT_SECRET']
    }
  end
end
