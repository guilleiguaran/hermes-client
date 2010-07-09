class PagesController < ApplicationController
  
  def index
    
    places = ["Universidad del Norte, Barranquilla", "Estadio Metropolitano, Barranquilla"]
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
    @map.event_init(@start_marker, :dragend,"function(){ start_marker_dragend(this); }")
    @map.event_init(@end_marker, :dragend,"function(){ end_marker_dragend(this); }")
    
    @start_lat = results[0][:latlon][0]
    @start_lon = results[0][:latlon][1]
    @end_lat = results[1][:latlon][0]
    @end_lon = results[1][:latlon][1]
  end
  
  def update_route
    lat_origen  = params[:latitud_origen]
    lon_origen  = params[:longitud_origen]
    lat_destino = params[:latitud_destino]
    lon_destino = params[:longitud_destino]
    algorithm = params[:algorithm]
    route = Hermes.get_route(lat_origen,lon_origen,lat_destino,lon_destino, algorithm)
    points = []
    coordinates = route['coordinates']
    time = route['time']
    distance = route['distance']
    print "time: #{time}\n"
    print "distance: #{distance}"
    
    coordinates.each do |coordinate|
      points << [ Float(coordinate['lat']), Float(coordinate['lon']) ]
    end
    
    @map = Variable.new("map")
    @polyline = GPolyline.new(points,"#0000ff",3,1.0)
    #@polyline.declare("polyline")

    respond_to do |format|
      format.js { 
        render :update do |page|
          page << "if(polyline != undefined) { map.removeOverlay(polyline); }"
          page << "polyline = #{@polyline.to_javascript};"
          page << "map.addOverlay(polyline);"
          page << "$('commit').disabled=false;"
          page << "$('commit').value=\"Consultar\";"
          page << "$('distancia').value=\"#{distance}\";"
          page << "$('tiempo').value=\"#{time}\";"
        end
      }
    end
    
  end
  
  def all_routes
    
    places = ["Universidad del Norte, Barranquilla", "Estadio Metropolitano, Barranquilla"]
    results = []
    places.each do |place|
      result = Geocoding::get(place)
      if result.status == Geocoding::GEO_SUCCESS
        results << {:latlon => result[0].latlon, :address => result[0].address}
      end
    end
    
    route = Hermes.get_all
    points = []
    coordinates = route['coordinates']
    
    @map = GMap.new("map_div")
    @map.center_zoom_init(results[0][:latlon],13)
    @map.control_init(:large_map => true, :map_type => true)
    
    coordinates.each do |coordinate|
      point = [ Float(coordinate['lat']), Float(coordinate['lon']) ]
      marker = GMarker.new(point, :draggable => true)
      @map.overlay_init(marker)
    end    
    
    
  end
  
end
