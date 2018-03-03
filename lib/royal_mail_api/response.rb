module RoyalMailApi
  class Response
    attr_accessor :body,
      :http,
      :parser,
      :errors,
      :warnings,
      :shipments,
      :label_image,
      :tracking_detail,
      :tracking_details,
      :tracking_history

    Shipment = Struct.new(
      :item_id,
      :shipment_number,
      :valid_from
    )

    LabelImage = Struct.new(
      :barcode1D,
      :barcode2D
    )

    TrackingDetail = Struct.new(
      :date,
      :time,
      :header,
      :code,
      :summary
    )

    TrackingHistory = Struct.new(
      :date,
      :point,
      :time,
      :header
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
      set_label
      set_tracking_detail
      set_tracking_details
      set_tracking_history
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

    def set_tracking_history
      @tracking_history = parse_all(body, "trackDetail").each_with_object([]) do |track_detail, arr|
        arr << TrackingHistory.new(
          parse_text(track_detail, "trackDate", true),
          parse_text(track_detail, "trackPoint", true),
          parse_text(track_detail, "trackTime", true),
          parse_text(track_detail, "header", true),
        )
      end
    end

    def set_tracking_details
      @tracking_details = parse_all(body, "itemSummary").each_with_object({}) do |summary, h|
        tracking_number = parse_text(summary, "trackingNumber", true)
        h[tracking_number] = TrackingDetail.new(
          parse_text(summary, "eventDate", true),
          parse_text(summary, "eventTime", true),
          parse_text(summary, "header", true),
          parse_text(summary, "code", true),
          parse_text(summary, "summaryLine", true),
        )
      end
    end

    def set_label
      @label_image = LabelImage.new(
        parse_text(body, "image1DBarcode", true),
        parse_text(body, "image2DMatrix", true)
      )
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
