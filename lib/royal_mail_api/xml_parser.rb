module RoyalMailApi
  class XmlParser
    def parse(xml, attr, force_remove_namespaces=false)
      unless xml.is_a? Nokogiri::XML::Element || force_remove_namespaces
        xml = Nokogiri::XML(xml).remove_namespaces!
      end

      # xpath method doesn't work for finding SOAP Fault attributes for some reason
      xml.css(attr)
    end

    def parse_all(xml, attr, force_remove_namespaces=false)
      parse(xml, "//#{attr}", force_remove_namespaces)
    end

    def parse_text(xml, attr, force_remove_namespaces=false)
      parse(xml, attr, force_remove_namespaces).text
    end
  end
end
