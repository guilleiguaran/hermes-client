class PagesController < ApplicationController
  
  def index
    
    places = ["Estadio Romelio Martinez, Barranquilla", "Estadio Metropolitano, Barranquilla"]
    results = []
    places.each do |place|
      result = Geocoding::get(place)
      if result.status == Geocoding::GEO_SUCCESS
        results << {:latlon => result[0].latlon, :address => result[0].address}
      end
    end
    
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init(results[0][:latlon],13)
    
    @start_marker = GMarker.new(results[0][:latlon], :title => "Inicio", :info_window =>"Arrastre al punto de inicio", :draggable => true)
    @end_marker   = GMarker.new(results[1][:latlon], :title => "Fin", :info_window =>"Arrastre al punto de final", :draggable => true)
    
    @map.declare_init(@start_marker,"start")
    @map.declare_init(@end_marker,"end")
    
    @map.overlay_init(@start_marker)
    @map.overlay_init(@end_marker)
    
    #@map.clear_overlays
    #results.each do |result|
    #  marker = GMarker.new(result[:latlon], :title => result[:address])
    #  @map.add_overlay(marker)
    #end
    
    @map.event_init(@start_marker, :dragend,
                    "function()
                    {
                      var latitud_origen = document.getElementById('latitud_origen');
                      var longitud_origen = document.getElementById('longitud_origen');
                      var latitud = this.getLatLng().lat()+'';
                      var longitud = this.getLatLng().lng()+'';
                      latitud_origen.value = latitud.substring(0,latitud.indexOf('.')+8);
                      longitud_origen.value = longitud.substring(0,longitud.indexOf('.')+8);
                    }
    ")
    @map.event_init(@end_marker, :dragend,
                    "function()
                    {
                      var latitud_destino = document.getElementById('latitud_destino');
                      var longitud_destino = document.getElementById('longitud_destino');
                      var latitud = this.getLatLng().lat()+'';
                      var longitud = this.getLatLng().lng()+'';
                      latitud_destino.value = latitud.substring(0,latitud.indexOf('.')+8);
                      longitud_destino.value = longitud.substring(0,longitud.indexOf('.')+8);
                    }
    ")
    @start_lat = results[0][:latlon][0]
    @start_lon = results[0][:latlon][1]
    @end_lat = results[1][:latlon][0]
    @end_lon = results[1][:latlon][1]    
  end
end
