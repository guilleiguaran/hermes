class RoutesController < ApplicationController
  
  def index
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([10.982987,-74.799213],13)

    @start_marker = GMarker.new([11.008601, -74.833717], :title => "Start", :info_window =>"Move to start", :draggable => true)
    @end_marker   = GMarker.new([10.998996,-74.813118], :title => "End", :info_window =>"Move to end", :draggable => true)

    @map.declare_init(@start_marker,"start")
    @map.declare_init(@end_marker,"end")
    @map.overlay_init(@start_marker)
    @map.overlay_init(@end_marker)
    @map.event_init(@start_marker, :dragend,"function(){ start_marker_dragend(this); }")
    @map.event_init(@end_marker, :dragend,"function(){ end_marker_dragend(this); }")
    @start_lat = "11.008601" ; @start_lon = "-74.833717"
    @end_lat = "10.998996" ; @end_lon = "-74.813118"
  end
  
  def create
    
  end
  
  
  
end