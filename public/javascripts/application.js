function initialize() {
    var center = new google.maps.LatLng(10.9720, -74.7992);
    var options = {
		zoom: 13,
    	center: center,
    	mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    window.map = new google.maps.Map(document.getElementById("map_canvas"), options);

	var startCoord = new google.maps.LatLng(11.01804, -74.85037);
	var endCoord = new google.maps.LatLng(10.92690, -74.80078);
	
	var startMarker = new google.maps.Marker({
	    position: startCoord, 
	    map: window.map, 
	    title: "Start Position",
	    draggable: true
	});
	
	var endMarker = new google.maps.Marker({
    	position: endCoord, 
	    map: window.map, 
	    title: "End Position",
	    draggable: true
	});
	
	google.maps.event.addListener(startMarker, 'dragend', function(event) {
	    calculateRoute(startMarker.getPosition(), endMarker.getPosition());
	});
	google.maps.event.addListener(endMarker, 'dragend', function(event) {
	    calculateRoute(startMarker.getPosition(), endMarker.getPosition());
	});

}

function calculateRoute(startCoord, endCoord) {
	var startLat = startCoord.lat();
	var startLon = startCoord.lng();
	var endLat = endCoord.lat();
	var endLon = endCoord.lng();
	
	var route = new Array();
	
	$.getJSON("/route?start_lat="+startLat+"&start_lon="+startLon+"&end_lat="+endLat+"&end_lon="+endLon, function(data) {
	  	$.each(data, function(i, coord){
			
			var latlng = new google.maps.LatLng(coord[0], coord[1]);
			route.push(latlng);
		});

		

		if(window.routePath != null)
		{
			window.routePath.setMap(null);
		}
		
		window.routePath = new google.maps.Polyline({
		    path: route,
		    strokeColor: "#0000FF",
		    strokeOpacity: 1.0,
		    strokeWeight: 2
		});

		window.routePath.setMap(window.map);
	});
}
