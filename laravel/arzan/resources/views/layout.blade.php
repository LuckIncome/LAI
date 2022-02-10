<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport"
        content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Админ</title>
  <link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
  <link rel="stylesheet" href="{{asset('css/style.css')}}">
    <script
            src="https://code.jquery.com/jquery-3.2.1.js"
            integrity="sha256-DZAnKJ/6XZ9si04Hgrsxu/8s717jcIzLy3oi35EouyE="
            crossorigin="anonymous"></script>
</head>
<body>
  <header>
  	  <div id="menu"><i class="fa fa-bars" aria-hidden="true"></i></div>
	     <a href="{{route('Out')}}"><i class="fa fa-sign-out" aria-hidden="true"></i> Выйти </a>
  </header>
 <div class="body">
     @yield('content')
 </div>


  <div id="bar">
      <a href="{{route('Main')}}"><i class="fa fa-user-circle-o" aria-hidden="true"></i> Главная </a>
      <a href="{{route('Passengers')}}"><i class="fa fa-user-circle-o" aria-hidden="true"></i> Пользователи </a>
      <a href="{{route('Drivers')}}#"><i class="fa fa-user-circle" aria-hidden="true"></i> Водители</a>
      <a href="{{route('Orders')}}"><i class="fa fa-id-card-o" aria-hidden="true"></i> Заявки</a>
      <a href="{{route('Feedback')}}"><i class="fa fa-id-card-o" aria-hidden="true"></i> Feedback</a>
      <a href="{{route('IntercityOrders')}}"><i class="fa fa-id-card-o" aria-hidden="true"></i>Межгород</a>
      {{--<a href="{{route('ToyCars')}}"><i class="fa fa-id-card-o" aria-hidden="true"></i>Той такси</a>--}}
      {{--<a href="{{route('SpecialCars')}}"><i class="fa fa-id-card-o" aria-hidden="true"></i>Спецтехники</a>--}}
      {{--<a href="{{route('CargoOrders')}}"><i class="fa fa-id-card-o" aria-hidden="true"></i>Грузовые</a>--}}
      <a href="{{route('Notifications')}}"><i class="fa fa-id-card-o" aria-hidden="true"></i>Уведомления</a>
      @if(session()->get('admin') == 1)
          <a href="{{route('Moderators')}}"><i class="fa fa-id-card-o" aria-hidden="true"></i>Модераторы</a>
      @endif
  </div>



  @if(session()->has('error'))
    <script>alert('{{session()->get('error')}}')</script>
  @endif

  <script>
    $('#menu').click(function () {
      $('#bar').toggleClass('bar')
    })
    $('.body').click(function () {
      $('#bar').removeClass('bar')
    })

  </script>

  {{--<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBbKksqLS09U8jetA8PgZOh4GVvmdISaZ0&callback=initMap"--}}
          {{--async defer></script>--}}

@yield('js')
</body>
</html>
