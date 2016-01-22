module RoyalMailApi
  class Response
    attr_accessor :body,
      :http,
      :parser,
      :errors,
      :warnings,
      :shipments,
      :tracking_detail

    Shipment = Struct.new(
      :item_id,
      :shipment_number,
      :valid_from
    )

    TrackingDetail = Struct.new(
      :date,
      :time,
      :header,
      :code,
      :summary
    )

    def initialize(response)
      @parser = RoyalMailApi::XmlParser.new
      set_attrs(response)
    end

    private

    def parse(xml, attr)
      parser.parse(xml, attr)
    end

    def parse_all(xml, attr, force_remove_namespaces=false)
      parser.parse_all(xml, attr, force_remove_namespaces)
    end

    def parse_text(xml, attr, force_remove_namespaces=false)
      parser.parse_text(xml, attr, force_remove_namespaces)
    end

    def set_attrs(response)
      @body = response.xml
      @http = response.http

      set_errors
      set_warnings
      set_shipments
      set_tracking_detail
    end

    def set_errors
      @errors = parse_all(body, "error").map do |error|
        RoyalMailApi::RoyalMailError.new({
          error_code:         parse_text(error, "errorCode"),
          error_description:  parse_text(error, "errorDescription")
        })
      end
    end

    def set_warnings
      @warnings = parse_all(body, "warning").map do |warning|
        RoyalMailApi::Warning.new({
          warning_code:         parse_text(warning, "warningCode"),
          warning_description:  parse_text(warning, "warningDescription")
        })
      end
    end

    def set_shipments
      @shipments = parse_all(body, "shipment").map do |shipment|
        Shipment.new(
          parse_text(shipment, "itemId"),
          parse_text(shipment, "shipmentNumber"),
          parse_text(shipment, "validFrom")
        )
      end
    end

    def set_tracking_detail
      @tracking_detail = TrackingDetail.new(
        parse_text(body, "eventDate", true),
        parse_text(body, "eventTime", true),
        parse_text(body, "header", true),
        parse_text(body, "code", true),
        parse_text(body, "summaryLine", true)
      )
    end
  end
end
