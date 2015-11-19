module RoyalMailApi
  class Config
    attr_accessor :username,
      :password,
      :adapter,
      :wsdl,
      :ssl_ca_cert_file,
      :ssl_cert_file,
      :ssl_cert_key_file,
      :endpoint,
      :application_id,
      :logger

  end
end
