@extends('layouts.admin')
@section('content')
  <div class="container">
    <div class="row">
      <div class="user">
        <div class="col-md-3">
          @if($user['avatar'] == 'no image')
            <img src="http://placehold.it/760x450?text=Нет Фото" class="img-responsive">
          @else
            <img src="http://188.120.226.79/{{$user['avatar']}}" class="img-responsive">
          @endif
        </div>
        <div class="col-md-9">
          <h4>{{$user['surname']}} {{$user['name']}} {{$user['middle_name']}}</h4>
          <p>ID: {{$user['id']}}</p>
          <p>Номер {{$user['phone']}}</p>
          <p>Город: {{$user['city']}}</p>
          <p>Дата регистрации: {{$user['created_at']}}</p>
          <p> activity: {{$user['updated_at']}}</p>
          <p>Баланс: {{$user['balanse']}}</p>
          <p>Промокод: {{$user['promo_code']}}</p>
          @if ($user['access'] == 1)
            <a class="btn btn-default" href="{{route('BlackListAdd',$user['id'])}}">to BlackList(Ban)</a>

          @else
            <a class="btn btn-default" href="{{route('BlackListDelete',$user['id'])}}">Remove from Blacklist(Ban)</a>
          @endif
          @if (session()->get('login') == 'admin')
            <a class="btn-default btn" href="{{route('DeleteUser',$user['id'])}}">Delete<i class="fa fa-trash" aria-hidden="true"></i></a>
            <a class="btn btn-default" href="{{route('EditPassenger',$user['id'])}}">Edit</a>
          @endif
        </div>
    </div>
      <hr>
    </div>
    <h2>Заказы</h2>
    <div class="row taxi_orders">
      @if(count($taxi_orders) != 0)
        @foreach($taxi_orders as $order)
          <div class="col-md-4">
            <a href="{{route('DeleteOrder',$order['id'])}}"><i class="fa fa-trash" aria-hidden="true"></i></a>
            <p>А: {{$order['from']}}</p>
            <p>Б: {{$order['to']}}</p>
            <p>Цена: {{$order['price']}}</p>
            <p>Статус: {{($order['step'] == 5)?'Is completed':'Not finished'}}</p>
            <p>Дата: {{$order['created_at']}}</p>
            <p>Count Passengers : {{$order['count_passenger']}}</p>
            <a target="_blank" href="{{route('Direction',$order['id'])}}">Open Route</a>
            <br>
            <br>
          </div>
        @endforeach
      @else
        Is empty
      @endif
    </div>

  </div>
@endsection

