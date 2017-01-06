module RoyalMailApi
  class Config # :nodoc:
    attr_accessor :username,
                  :password,
                  :adapter,
                  :shipping_wsdl,
                  :tracking_wsdl,
                  :shipping_endpoint,
                  :tracking_endpoint,
                  :application_id,
                  :logger,
                  :headers
  end
end
