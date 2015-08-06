module RoyalMailApi
  class Response
    include HashMethods

    attr_accessor :body,
      :http,
      :errors,
      :warnings,
      :shipments

    Shipment = Struct.new(
      :item_id,
      :shipment_number,
      :valid_from
    )

    def initialize(response)
      set_attrs(response)
    end

    def errors
      @errors ||= []
    end

    def warnings
      @warnings ||= []
    end

    private

    def set_attrs(response)
      @body = response.body
      @http = response.http

      set_errors
      set_warnings
      set_shipments
    end

    def set_errors
      errors = retrieve_value(body, :error)

      if errors.class.name == 'Array'
        @errors = errors.map do |error|
          RoyalMailApi::Error.new(error)
        end
      elsif errors.class.name == 'Hash'
        @errors = [RoyalMailApi::Error.new(errors)]
      end
    end

    def set_warnings
      warnings = retrieve_value(body, :warning)

      if warnings.class.name == 'Array'
        @warnings = warnings.map do |warning|
          RoyalMailApi::Warning.new(warning)
        end
      elsif warnings.class.name == 'Hash'
        @warnings = [RoyalMailApi::Warning.new(warning)]
      end
    end

    def set_shipments
      shipments = retrieve_value(body, :shipment)

      if shipments.class.name == 'Array'
        @shipments = shipments.map do |s|
          Shipment.new(
            retrieve_value(s, :item_id),
            retrieve_value(s, :shipment_number),
            retrieve_value(s, :valid_from)
          )
        end
      elsif shipments.class.name == 'Hash'
        @shipments = [
          Shipment.new(
            retrieve_value(shipments, :item_id),
            retrieve_value(shipments, :shipment_number),
            retrieve_value(shipments, :valid_from)
          )
        ]
      end

      return [] unless shipments.present? && shipments.class.name == 'Array'

      @shipments = shipments.map do |s|
        Shipment.new(
          retrieve_value(s, :item_id),
          retrieve_value(s, :shipment_number),
          retrieve_value(s, :valid_from)
        )
      end
    end
  end
end
