var map;
var routePath = null;
var loading;

function initialize() {
  loading = document.getElementById("loading");
  var center = new google.maps.LatLng(10.9720, -74.7992);
  var options = {
    zoom: 13,
    center: center,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), options);

  var startCoord = new google.maps.LatLng(11.01804, -74.85037);
  var endCoord = new google.maps.LatLng(10.92690, -74.80078);

  var startImage = '/images/dd-start.png';
  var endImage = '/images/dd-end.png';

  var startMarker = new google.maps.Marker({
    position: startCoord, 
    map: map, 
    title: "Start Position",
    draggable: true,
    icon: startImage
  });

  var endMarker = new google.maps.Marker({
    position: endCoord, 
    map: map, 
    title: "End Position",
    draggable: true,
    icon: endImage
  });

  google.maps.event.addListener(startMarker, 'dragend', function(event) {
    calculateRoute(startMarker.getPosition(), endMarker.getPosition());
  });

  google.maps.event.addListener(endMarker, 'dragend', function(event) {
    calculateRoute(startMarker.getPosition(), endMarker.getPosition());
  });

  var userAgent = navigator.userAgent.toLowerCase();

  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var lat = position.coords.latitude;
      var lng = position.coords.longitude;
      var myLatlng = new google.maps.LatLng(lat, lng);
      startMarker.setPosition(myLatlng)
      map.setCenter(myLatlng);
      calculateRoute(startMarker.getPosition(), endMarker.getPosition());
    });
  }
  
  calculateRoute(startMarker.getPosition(), endMarker.getPosition());

}

function calculateRoute(startCoord, endCoord) {
  var coords, data_length, p, j, i, n, k, datai;
  var startLat = startCoord.lat();
  var startLon = startCoord.lng();
  var endLat = endCoord.lat();
  var endLon = endCoord.lng();

  loading.className = "loading-visible";
  var route = new Array();
  jx.load("/route?start_lat="+startLat+"&start_lon="+startLon+"&end_lat="+endLat+"&end_lon="+endLon, function(data) {
    i = data.length;
    while(i--){
      coords = new google.maps.MVCArray();
      datai = data[i];
      n = datai.length - 1;
      j = n;
      while(j--){
        k = n - j;
        coords.insertAt(k, new google.maps.LatLng(datai[k][0], datai[k][1]));
      }
      p = new google.maps.Polyline({
        path: coords,
        strokeColor: "#6633FF",
        strokeOpacity: 0.6,
        strokeWeight: 3
      });
      p.setMap(map);
      route.push(p);
    }
    if(routePath != null)
    {
      i = routePath.length;
      while(i--)
      {
        routePath[i].setMap(null);
      }
    }
    routePath = route;

    loading.className = "loading-invisible";
  },'json');
  
}
