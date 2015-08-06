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
      return_array_of(:error) do |error|
        RoyalMailApi::Error.new(error)
      end
    end

    def set_warnings
      return_array_of(:warning) do |warning|
        RoyalMailApi::Warning.new(warning)
      end
    end

    def set_shipments
      return_array_of(:shipment) do |shipment|
        Shipment.new(
          retrieve_value(shipment, :item_id),
          retrieve_value(shipment, :shipment_number),
          retrieve_value(shipment, :valid_from)
        )
      end
    end

    def return_array_of(attr, &block)
      attrs = retrieve_value(body, attr)

      if attrs.class.name == 'Array'
        self.send(
          "#{attr}s=", attrs.map do |attr|
            yield(attr)
          end
        )
      elsif attrs.class.name == 'Hash'
        self.send("#{attr}s=", [yield(attrs)])
      end
    end
  end
end
