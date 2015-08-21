require 'erb'
require 'ostruct'

class XmlBuilder < OpenStruct
  attr_reader :request

  SPECIAL_CHARACTER_MAP = {
    '"' => "&quot;",
    "&" => "&amp;",
    "'" => "&apos;",
    "<" => "&lt;",
    ">" => "&gt;"
  }

  def initialize(request, attrs={})
    @request = request
    super attrs
  end

  def build
    envelope
  end

  private

  def xml_path
    [RoyalMailApi.root, 'lib', 'xml']
  end

  def build_xml(file)
    path = File.join(xml_path << file)
    ERB.new(File.read(path)).result(binding)
  end

  def header
    build_xml('security_header.xml')
  end

  def body
    build_xml("#{request}.xml")
  end

  def envelope
    build_xml('envelope.xml')
  end

  def parse_special_characters(str)
    return str unless str.is_a? String
    str.gsub(/["&'<>]/, SPECIAL_CHARACTER_MAP)
  end
end
