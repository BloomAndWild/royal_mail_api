module RoyalMailApi
  class RequestHandler
    class << self
      def request(request_name, attrs={}, &block)
        begin
          handler = RoyalMailApi::RequestHandler.new(request_name)
          handler.configure(&block) if block_given?
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

    attr_accessor :config

    def initialize(request_name)
      @request_name = request_name

      self.config = self.class.config.dup
    end

    def configure
      yield config if block_given?
    end

    def build_xml(attrs={})
      attrs[:service_code] = service_code(attrs[:service])
      XmlBuilder.new(request_name, attrs.merge(security_attrs), request_type).build
    end

    def savon
      Savon.client(
        adapter: config.adapter,
        wsdl: wsdl,
        endpoint: endpoint,
        namespace: endpoint,
        open_timeout: 600,
        read_timeout: 600,
        logger: config.logger,
        log_level: config.logger.level.zero? ? :debug : :info,
        log: config.logger.level.zero?,
        pretty_print_xml: true,
        headers: {
          'accept' => 'application/xml',
          "X-IBM-Client-Id" => config.client_id,
          "X-IBM-Client-Secret" => config.client_secret,
          'context-type'  => 'text/xml'
        },
      )
    end

    private
    attr_accessor :request_name

    def request_type
      case request_name
      when :get_single_item_summary, :get_multi_item_summary, :get_single_item_history
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

    def service_code service
      case service
      when 'tracked'
        'TPN'
      when 'tracked_high_volume'
        'TPM'
      end
    end

    def security_attrs
      # TODO move into own value object

      password = config.password
      date_time_now =  Time.now.strftime('%Y-%m-%dT%H:%M:%SZ')
      nonce =  rand(999999).to_s

      hashedpassword = Digest::SHA1.digest(password)

      {
        username: config.username,
        application_id: config.application_id,
        date_time_now: date_time_now,
        encoded_nonce: Base64.encode64(nonce),
        password_digest: Digest::SHA1.base64digest(
          nonce + date_time_now + hashedpassword
        ),
        service_occurrence: config.service_occurrence
      }
    end
  end
end
