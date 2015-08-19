module RoyalMailApi
  class XmlParser
    def parse(xml, attr)
      unless xml.is_a? Nokogiri::XML::Element
        xml = Nokogiri::XML(xml).remove_namespaces!
      end

      # xpath method doesn't work for finding SOAP Fault attributes for some reason
      xml.css(attr)
    end

    def parse_all(xml, attr)
      parse(xml, "//#{attr}")
    end

    def parse_text(xml, attr)
      parse(xml, attr).text
    end
  end
end
