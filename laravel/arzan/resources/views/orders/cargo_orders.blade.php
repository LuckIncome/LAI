@extends('layout')
@section('content')
  <div class="container">
      <div class="row toy_cars">
          @if(count($orders) != 0)
              @foreach($orders as $order)
                  <div class="col-md-12">
                      <h3>№{{$order['id']}}</h3>
                      <p><a target="_blank" href="{{route('Passenger',$order['passenger_id'])}}">Passenger</a></p>
                      @if($order['driver_id'] != null)
                          <p><a target="_blank" href="{{route('Driver',$order['driver_id']['id'])}}">Driver</a></p>
                      @endif
                      <p><b>From: </b> {{$order['from']}}</p>
                      <p><b>To: </b> {{$order['to']}}</p>
                      <p><b>Price: </b> {{$order['price']}}</p>
                      <p><b>Text: </b> {{$order['text']}}</p>
                      <p><b>Status: </b> {{($order['status'] == 0 )? 'Is completed':'Active'}}</p>
                      <p><a href="{{route('DeleteCargoOrder',$order['id'])}}">Delete</a></p>
                      <br>
                  </div>
                  <hr class="du">
              @endforeach
          @else
              Пусто
          @endif
      </div>
    {{$ordersDB->links()}}
      <style>
          .toy_cars > div{
              border-bottom: 1px solid black;
              padding-bottom: 25px;
          }
      </style>
  </div>
@endsection

