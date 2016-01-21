module RoyalMailApi
  class Config
    attr_accessor :username,
      :password,
      :adapter,
      :shipping_wsdl,
      :tracking_wsdl,
      :ssl_ca_cert_file,
      :ssl_cert_file,
      :ssl_cert_key_file,
      :shipping_endpoint,
      :tracking_endpoint,
      :application_id,
      :logger

  end
end
