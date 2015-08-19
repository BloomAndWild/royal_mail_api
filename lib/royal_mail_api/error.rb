module RoyalMailApi
  class Error < StandardError
    attr_accessor :code
  end

  class RoyalMailError < Error
    attr_accessor :description

    def initialize(error=nil)
      raise ArgumentError 'royal mail error must be initialized with a hash' unless error.is_a? Hash
      raise ArgumentError 'error must contain' unless error.present?

      @code = error[:error_code]
      @description = error[:error_description]
    end
  end

  # class SoapError < Error
  #   attr_accessor :parsed_xml

  #   def initialize(error=nil)
  #     error[:error_description] = parse_xml_for_soap_fault_errors(error[:xml])
  #   end

  #   private

  #   def parse_xml_for_soap_fault_errors(xml="")
  #     @parsed_xml = Nokogiri::XML(xml)
  #   end
  # end
end
