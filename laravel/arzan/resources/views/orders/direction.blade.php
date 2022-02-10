<!DOCTYPE html>
<html>
<head>
    <style>
        #map {
            height: 100%;
            width: 100%;
            position: absolute;

            top:0;
            left:0;
        }
    </style>
</head>
<body>
<div id="map"></div>
<script>
{{--    {{dd($order)}}--}}
    function initMap() {
        var uluru = {lat:  {{$order->from_lat}}, lng: {{$order->from_lon}}};
        var map = new google.maps.Map(document.getElementById('map'), {
            zoom:17,
            center: uluru
        });

        var marker = new google.maps.Marker({
            position: uluru,
            map: map
        });
        var marker = new google.maps.Marker({
            position: {lat:  {{$order->to_lat}}, lng: {{$order->to_lon}}},
            map: map,
            icon: {
                url: 'http://www.pngall.com/wp-content/uploads/2017/05/Map-Marker-PNG-Pic.png',
                scaledSize: new google.maps.Size(25, 35)
            },
        });

        var directionsService = new google.maps.DirectionsService;
        directionsDisplay = new google.maps.DirectionsRenderer({
            polylineOptions: {
                strokeColor: "red"
            }
        });
        directionsDisplay.setMap(map);
        calculateAndDisplayRoute(directionsService, directionsDisplay);

        function calculateAndDisplayRoute(directionsService, directionsDisplay) {
            // directionsDisplay.remove();
            directionsService.route({
                origin: new google.maps.LatLng({{$order->from_lat}},{{$order->from_lon}}),
                destination: new google.maps.LatLng({{$order->to_lat}},{{$order->to_lon}}),
                travelMode: 'DRIVING'
            }, function(response, status) {
                if (status === 'OK') {
                    directionsDisplay.setOptions( { suppressMarkers: true ,preserveViewport: true} );
                    directionsDisplay.setDirections(response);
                } else {
                    window.alert('Directions request failed due to ' + status);
                }
            });
        }



    }
</script>
<script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBLNpcoKKnkfYXQ0VUMJ1Xz69SfjpHICUU&callback=initMap">
</script>
</body>
</html>