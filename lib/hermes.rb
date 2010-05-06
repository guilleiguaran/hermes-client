require 'open-uri'
require 'json'

class Hermes
  
  def self.get_route(start_lat, start_lon, end_lat, end_lon)
    url = "http://localhost:9095/ruta/#{start_lat}_#{start_lon}/#{end_lat}_#{end_lon}"
    buffer = open(url).read
    result = JSON.parse(buffer)
    result
  end
  
end