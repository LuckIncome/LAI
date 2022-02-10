@extends('layout')
@section('content')
  <div class="container">
      <div class="row intercity_orders">
          @if(count($orders) != 0)
              @foreach($orders as $order)
                  @if(count($order['passenger']) != 0)
                      <div class="col-md-12">
                          <a href="{{route('DeleteIntercityOrder',$order['id'])}}"><i class="fa fa-trash" aria-hidden="true"></i></a>
                          <a target="_blank" href="{{route('Passenger',$order['passenger']['id'])}}">Пасажир</a>
                          @if($order['driver_id'] != null)
                              <a target="_blank" href="{{route('Driver',$order['driver_id']['id'])}}">Водитель</a>
                          @endif
                          <p>Откуда: {{$order['from']}}</p>
                          <p>Куда: {{$order['to']}}</p>
                          <p>Цена: {{$order['price']}}</p>
                          <p>Статус: {!! ($order['status'] == 0)?'<i>Завершен</i>':'<b>Не завершен</b>' !!}</p>
                          <p>Дата : {{$order['date']}}</p>
                          <br>
                          <br>
                      </div>
                      <hr class="du">
                  @endif
              @endforeach
          @else
              Пусто
          @endif
      </div>
    {{$ordersDB->links()}}
  </div>
@endsection

