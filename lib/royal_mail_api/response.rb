module RoyalMailApi
  class Response
    include HashMethods

    attr_accessor :shipments

    Shipment = Struct.new(
      :item_id,
      :shipment_number,
      :status_code,
      :valid_from
    )

    def initialize(attrs={})
      set_attrs(attrs)
    end

    def set_attrs(attrs={})
      set_shipments(attrs[:parsed_response])
    end

    private

    def set_shipments(parsed_response)
      shipments = retrieve_value(parsed_response, :shipment)
      @shipments = shipments.map do |s|
        Shipment.new(
          retrieve_value(s, :item_id),
          retrieve_value(s, :shipment_number),
          retrieve_value(s, :code),
          retrieve_value(s, :valid_from)
        )
      end
    end
  end
end
