def configure_client
  RoyalMailApi::Client.configure do |config|
    config.application_id = ENV['RM_APPLICATION_ID']
    config.username = ENV['RM_USERNAME']
    config.password = ENV['RM_PASSWORD']
    config.adapter = :httpclient
    config.shipping_wsdl = File.join(RoyalMailApi.root, 'tmp', 'wsdl', 'ShippingAPI_V2_0_9.wsdl')
    config.tracking_wsdl = File.join(RoyalMailApi.root, 'tmp', 'wsdl', 'Tracking_API_V1.2.wsdl')
    config.logger = Logger.new(STDOUT)
    config.logger.level = 0
  end
end
