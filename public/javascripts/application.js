// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function start_marker_dragend(marker){
	var latitud_origen = document.getElementById('latitud_origen');
	var longitud_origen = document.getElementById('longitud_origen');
	var latitud = marker.getLatLng().lat()+'';
	var longitud = marker.getLatLng().lng()+'';
	latitud_origen.value = latitud.substring(0,latitud.indexOf('.')+8);
	longitud_origen.value = longitud.substring(0,longitud.indexOf('.')+8);
}

function end_marker_dragend(marker){
	var latitud_destino = document.getElementById('latitud_destino');
	var longitud_destino = document.getElementById('longitud_destino');
	var latitud = marker.getLatLng().lat()+'';
	var longitud = marker.getLatLng().lng()+'';
	latitud_destino.value = latitud.substring(0,latitud.indexOf('.')+8);
	longitud_destino.value = longitud.substring(0,longitud.indexOf('.')+8);
}