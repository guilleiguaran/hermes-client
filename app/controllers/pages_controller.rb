class PagesController < ApplicationController
  
  def index
    
    places = session[:places].nil? ? ["Barranquilla"] : session[:places]
    results = []
    places.each do |place|
      result = Geocoding::get(place)
      if result.status == Geocoding::GEO_SUCCESS
        results << {:latlon => result[0].latlon, :address => result[0].address}
      end
    end
    
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init(results[0][:latlon],4)
    @map.clear_overlays
    results.each do |result|
      marker = GMarker.new(result[:latlon], :title => result[:address])
      @map.add_overlay(marker)
    end
    
  end
end
