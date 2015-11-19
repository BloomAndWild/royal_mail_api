def configure_client
  RoyalMailApi::Client.configure do |config|
    config.application_id = ENV['APPLICATION_ID']
    config.username = ENV['USERNAME']
    config.password = ENV['PASSWORD']
    config.adapter = :httpclient
    config.wsdl = File.join(RoyalMailApi.root, 'tmp', 'wsdl', 'ShippingAPI_V2_0_8.wsdl')
    config.ssl_ca_cert_file = File.join(RoyalMailApi.root, 'tmp', 'certs', 'cacert.pem')
    config.ssl_cert_file = File.join(RoyalMailApi.root, 'tmp', 'certs', 'mycert.pem')
    config.ssl_cert_key_file = File.join(RoyalMailApi.root, 'tmp', 'certs', 'mykey.pem')
    config.endpoint = "https://api.royalmail.com/shipping/onboarding"
    config.logger = Logger.new(STDOUT)
  end
end
