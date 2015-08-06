require 'erb'

class XmlBuilder
  attr_reader :request

  def initialize(request, attrs={})
    @request = request

    attrs.each do |k,v|
      self.class.send(:attr_accessor, k)
      instance_variable_set(:"@#{k}", v)
    end
  end

  def build
    return envelope
  end

  private

  def xml_path
    [RoyalMailApi.root, 'lib', 'xml']
  end

  def build_xml(file)
    path = File.join(xml_path << file)
    return ERB.new(File.read(path)).result(binding)
  end

  def header
    return build_xml('security_header.xml')
  end

  def body
    return self.send(request)
  end

  def envelope
    return build_xml('envelope.xml')
  end

  def create_shipment
    return build_xml('create_shipment.xml')
  end
end
