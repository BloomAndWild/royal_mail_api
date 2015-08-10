module RoyalMailApi
  class RequestHandler
    class << self
      def request(request, attrs={})
        savon.call(request, xml: build_xml(attrs))
      end

      private

      def build_xml(attrs={})
        XmlBuilder.new(:create_shipment, attrs.merge(security_attrs)).build
      end

      def security_attrs
        # TODO move into own value object

        password = config.password
        creation_date =  Time.now.utc.strftime('%Y-%m-%dT%H:%M:%S')
        nonce =  rand(999999).to_s

        hashedpassword = Digest::SHA1.base64digest(password)

        {
          username: config.username,
          application_id: config.application_id,
          creation_date: creation_date,
          encoded_nonce: Base64.encode64(nonce),
          password_digest: Digest::SHA1.base64digest(
            nonce + creation_date + hashedpassword
          )
        }
      end

      def savon
        Savon.client(
          adapter: config.adapter,
          wsdl: config.wsdl,
          endpoint: config.endpoint,
          namespace: config.endpoint,
          ssl_ca_cert_file: config.ssl_ca_cert_file,
          ssl_cert_file: config.ssl_cert_file,
          ssl_cert_key_file: config.ssl_cert_key_file,
          open_timeout: 600,
          read_timeout: 600
        )
      end

      def config
        Client.config
      end
    end
  end
end
