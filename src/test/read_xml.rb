#encoding: UTF-8
require 'nori'
require 'json/ld'
require 'active_support/core_ext/hash'


def xml_to_hash(data, options = {})
    #gsub('&lt;\/', '&lt; /') outherwise wrong XML-parsing (see records lirias1729192 )
    data.force_encoding('UTF-8') #encode("UTF-8", invalid: :replace, replace: "")
    data = data.gsub /&lt;/, '&lt; /'
    
    xml_typecast = options.with_indifferent_access.key?('xml_typecast') ? options.with_indifferent_access['xml_typecast'] : true
    nori = Nori.new(parser: :nokogiri, advanced_typecasting: xml_typecast, strip_namespaces: true, convert_tags_to: lambda { |tag| tag.gsub(/^@/, '_') })
    nori.parse(data)
end

data = File.read("./in/test.xml")
raw = xml_to_hash(data)
pp raw