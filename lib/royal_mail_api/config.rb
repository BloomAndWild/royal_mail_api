module RoyalMailApi
  class Config
    attr_accessor :username,
      :password,
      :adapter,
      :shipping_wsdl,
      :tracking_wsdl,
      :shipping_endpoint,
      :tracking_endpoint,
      :application_id,
      :client_id,
      :client_secret,
      :logger,
      :service_occurrence
  end
end
