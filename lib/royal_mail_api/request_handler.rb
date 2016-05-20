module RoyalMailApi
  class RequestHandler
    class << self
      def request(request_name, attrs={})
        begin
          handler = RoyalMailApi::RequestHandler.new(request_name)
          xml = handler.build_xml(attrs)
          handler.savon.call(request_name, xml: xml)
        rescue Savon::SOAPFault => e
          raise RoyalMailApi::SoapError.new(xml: e.xml, error_code: e.http.code)
        end
      end

      def config
        Client.config
      end
    end

    def initialize(request_name)
      @request_name = request_name
    end

    def build_xml(attrs={})
      XmlBuilder.new(request_name, attrs.merge(security_attrs), request_type).build
    end

    def savon
      Savon.client(
        adapter: config.adapter,
        wsdl: wsdl,
        endpoint: endpoint,
        namespace: endpoint,
        ssl_ca_cert_file: config.ssl_ca_cert_file,
        ssl_cert_file: config.ssl_cert_file,
        ssl_cert_key_file: config.ssl_cert_key_file,
        open_timeout: 600,
        read_timeout: 600,
        logger: config.logger,
        log_level: config.logger.level.zero? ? :debug : :info,
        log: config.logger.level.zero?,
        pretty_print_xml: true,
      )
    end

    private
    attr_accessor :request_name

    def request_type
      case request_name
      when :get_single_item_summary
        'tracking'
      when :create_shipment, :print_label
        'shipping'
      else
        error_message = "Request type #{request_name} is not supported"
        config.logger&.debug(error_message)
        raise ArgumentError error_message
      end
    end

    def wsdl
      case request_type
      when 'tracking'
        config.tracking_wsdl
      when 'shipping'
        config.shipping_wsdl
      end
    end

    def endpoint
      case request_type
        when 'tracking'
          config.tracking_endpoint
        when 'shipping'
          config.shipping_endpoint
      end
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

    def config
      self.class.config
    end
  end
end
