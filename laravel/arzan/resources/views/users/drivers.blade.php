@extends('layouts.admin')

@section('content')
    <style>
        *{
            transition: none;
        }
        #map {
            height: 100%;
            width: 100%;
            position: absolute;

            top:0;
            left:0;
        }
        #info{
            position: fixed;
            z-index:999;
            background-color: #fff;
            width:100%;
            height: 250px;
            left:0;
            bottom:0;
            opacity:0;
            transition: all .5s ease;
            overflow: hidden;
        }
        #info > div{
            height:100%;
        }
        #info > div > div{
            height:100%;
            display: flex;
            align-items:center;
            flex-wrap: wrap;

        }
    </style>

    <div id="map"></div>
    <div id="info">

    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.0.4/socket.io.js"></script>
    <script
            src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
            integrity="sha256-k2WSCIexGzOj3Euiig+TlR8gA0EmPjuc79OEeY5L45g="
            crossorigin="anonymous"></script>
    <script>
        var map;
        var MAP= {};
        var markers = [];
        const IP = 'http://188.120.226.79/';
        const socket = io.connect('http://188.120.226.79:3000');

        function initMap() {
            MAP = google.maps;
            map = new google.maps.Map(document.getElementById('map'), {
                zoom:15,
                center: {lat: 43.2441631, lng:76.919435},
            });

            google.maps.event.addListener(map, "click", function(event) {
                $('#info').css('opacity',0).css('bottom','-100%')
            });

        }
        socket.emit('geopositions',1);
        function addMarker(lat,lng,option) {
            var marker = new google.maps.Marker({
                position:  {lat: parseFloat(lat), lng: parseFloat(lng)},
                map: map,
                option: option,
            });

            google.maps.event.addListener(marker, 'click', function () {
                if  (option.avatar == 'no image'){
                    $('#info').html(`
                <div class="container">
                    <div class="row">
                        <div class="col-md-3">
                            <img src="http://placehold.it/760x450?text=нет фото" class="img-responsive">
                        </div>
                        <div class="col-md-8">
                            <p>${option.surname} ${option.name} ${option.middle_name}</p>
                            <a target="_blank" href="${IP + 'system/driver/' + option.id}">Подробнее</a>
                        </div>
                    </div>
                </div>
            `);
                }
                else{
                    console.log(option)
                    $('#info').html(`
                <div class="container">
                    <div class="row">
                        <div class="col-md-3">
                            <img src="${IP + option.avatar}" class="img-responsive">
                        </div>
                        <div class="col-md-8">
                            <p>${option.surname} ${option.name} ${option.middle_name}</p>
                            <a target="_blank" href="${IP + 'system/driver/' + option.id}">Подробнее</a>
                        </div>
                    </div>
                </div>
            `);
                }

                $('#info').css('opacity',1).css('bottom','0')
            });
            markers.push(marker);
        }
        function deleteMarkers() {
            for (var i = 0; i < markers.length; i++) {
                markers[i].setMap(null);
            }
        }

        //    function deleteMarkers() {
        //        for (var i = 0; i < markers.length; i++) {
        //            markers[i].setMap(null);
        //        }
        //    }


        socket.on('geopositions',function (server) {
            let data = JSON.parse(server);
            if  (data['statusCode '] == 200){
                deleteMarkers()
                for(let item of data['result']){
                    addMarker(item.lat,item.lon,item)
                }
            }
        });

    </script>
    <script async defer
            {{--src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBLNpcoKKnkfYXQ0VUMJ1Xz69SfjpHICUU&callback=initMap">--}}
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBxsonU1udXLJqY0uzhDuPN_opy-WfLl-g&callback=initMap">
    </script>
@endsection
