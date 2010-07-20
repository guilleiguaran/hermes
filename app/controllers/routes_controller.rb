class RoutesController < ApplicationController
  
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
    #@map.event_init(@start_marker, :dragend,"function(){ start_marker_dragend(this); }")
    #@map.event_init(@end_marker, :dragend,"function(){ end_marker_dragend(this); }")

    @start_lat = results[0][:latlon][0]
    @start_lon = results[0][:latlon][1]
    @end_lat = results[1][:latlon][0]
    @end_lon = results[1][:latlon][1]
  end
  
  
  
end