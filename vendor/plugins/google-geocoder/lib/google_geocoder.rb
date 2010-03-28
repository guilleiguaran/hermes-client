require "open-uri"
require "rexml/document"
require "rexml/xpath"

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module GoogleGeocoder
  class NoGeocodingKeySupplied < StandardError; end
  # the only thing we should check is the status code from google
  # could throw OpenURI::HTTPError and SocketError
  def self.geocode(query, options = Hash.new)
    key = options[:key]
    key ||= KEY if defined?(KEY)
    raise NoGeocodingKeySupplied.new if key.to_s.length == 0
    output = options[:output] || "xml"
    query = api_url_for_query_and_key_and_output(query, key, output)
    data = do_query(query)
    extract_geocoding_results(data)
  end
  
  def self.do_query(query)
    open(query).read
  end

private
  def self.extract_geocoding_results(data)
    doc = REXML::Document.new(data)
    code = extract_status_code_from_document(doc)
    return Array.new if code == "602"
    raise code.to_s unless code == "200"
    ret = Array.new
    for pm in REXML::XPath.match(doc, "/kml/Response/Placemark")
      act = Hash.new
      act[:address] = pm.elements["address"].get_text.to_s
      address_details = pm.elements["AddressDetails"]
      act[:accuracy] = address_details.attributes["Accuracy"].to_i rescue nil
      for key in [ "CountryNameCode", "AdministrativeAreaName", "SubAdministrativeAreaName", 
        "LocalityName", "DependentLocalityName", "ThoroughfareName", "PostalCodeNumber"]
        lower = underscore(key)
        act[underscore(key).to_sym] = address_details.elements["Country//#{key}"].get_text.to_s rescue nil
      end
      lng, lat, height = pm.elements["Point/coordinates"].get_text.to_s.split(",").map { |coord| coord.to_f }
      ret << act.merge(:lat => lat, :lng => lng, :height => height)
    end
    ret
  end
  
  def self.extract_status_code_from_document(doc)
    REXML::XPath.first(doc, "/kml/Response/Status/code").get_text
  end
  
  def self.api_url_for_query_and_key_and_output(query, key, output = "xml")
    "http://maps.google.com/maps/geo?q=#{URI.encode(query.to_s)}&output=#{output}&key=#{key}&oe=utf-8"
  end
  
  def self.underscore(string)
    string.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
  end
end