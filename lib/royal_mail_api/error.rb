module RoyalMailApi
  class Error < StandardError
    attr_accessor :code, :description

    def initialize(args)
      raise ArgumentError 'royal mail error must be initialized with a hash' unless args.is_a? Hash
      raise ArgumentError 'error must contain some information' unless args.present?
    end
  end

  class RoyalMailError < Error
    def initialize(args)
      super

      @code = args[:error_code]
      @description = args[:error_description]
    end
  end

  class SoapError < Error
    attr_accessor :parser,
      :xml,
      :faultcode,
      :faultstring

    SOAP_FAULT_DESCRIPTIONS = {
      "env:VersionMismatch" => "Found an invalid namespace for the SOAP Envelope element.",
      "env:MustUnderstand"  => "An immediate child element of the Header element, with the mustUnderstand attribute set to '1', was not understood.",
      "env:Client"          => "The message was incorrectly formed or contained incorrect information.",
      "env:Server"          => "There was a problem with the server, so the message could not proceed."
    }

    def initialize(args)
      super

      @xml = args[:xml]
      @code = args[:error_code]
      @parser = RoyalMailApi::XmlParser.new

      set_faultcode
      set_faultstring
      set_description
    end

    private

    def set_faultcode
      @faultcode = parser.parse_text(xml, "faultcode")
    end

    def set_faultstring
      @faultstring = parser.parse_text(xml, "faultstring")
    end

    def set_description
      desc = SOAP_FAULT_DESCRIPTIONS.fetch(faultcode) { "Sorry, no further information available" }

      @description = "#{faultcode} error: #{desc}"
    end
  end
end
