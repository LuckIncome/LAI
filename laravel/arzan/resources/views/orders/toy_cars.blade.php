@extends('layout')
@section('content')
  <div class="container">
      <a href="{{route('CreateToyCar')}}">Добавить Той такси</a>
      <div class="row toy_cars">
          @if(count($cars) != 0)
              @foreach($cars as $car)
                  <div class="col-md-12">
                      <h3>№{{$car['id']}}</h3>
                      <p><b>Имя: </b> {{$car['name']}}</p>
                      <p><b>Телефон: </b> {{$car['phone']}}</p>
                      <p><b>Цена: </b> {{$car['price']}}</p>
                      <p><b>Марка: </b> {{$car['car_mark']}}</p>
                      <p><b>Модель: </b> {{$car['car_model']}}</p>
                      <p><b>Год: </b> {{$car['year']}}</p>
                      <p><b>Цвет: </b> {{$car['color']['name_ru']}}</p>
                      <p><a href="{{route('DeleteToyCar',$car['id'])}}">Удалить</a></p>
                      <br>
                      <div>
                          @foreach($car['images'] as $img)
                              <img src="http://188.120.226.79/{{$img['path']}}" width="100">
                          @endforeach
                      </div>
                  </div>
              @endforeach
          @else
              Пусто
          @endif
      </div>
    {{$carsDB->links()}}
      <style>
          .toy_cars > div{
              border-bottom: 1px solid black;
              padding-bottom: 25px;
          }
      </style>
  </div>
@endsection

