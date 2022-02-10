@extends('layout')
@section('content')
  <div class="container">
      <a href="{{route('CreateSpecialCar')}}">Добавить Спецтехники</a>
      <div class="row toy_cars">
          @if(count($cars) != 0)
              @foreach($cars as $car)
                  <div class="col-md-12">
                      <h3>№{{$car['id']}}</h3>
                      <p><b>Имя: </b> {{$car['name']}}</p>
                      <p><b>Телефон: </b> {{$car['phone']}}</p>
                      <p><b>Инфо(Модель техники): </b> {{$car['info']}}</p>
                      <p><b>Текст: </b> {{$car['text']}}</p>
                      <p><a href="{{route('DeleteSpecialCar',$car['id'])}}">Удалить</a></p>
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

