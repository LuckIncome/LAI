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
                    <p>Посл активность: {{$user['updated_at']}}</p>
                    <p>Баланс: {{$user['balanse']}}</p>
                    <p>Промокол: {{$user['promo_code']}}</p>


                    @if ($user['access'] == 1)
                        <a class="btn btn-default" href="{{route('BlackListAdd',$user['id'])}}">BlackList(ban)</a>

                    @else
                        <a class="btn btn-default" href="{{route('BlackListDelete',$user['id'])}}">Remove from blackList(ban)</a>
                    @endif

                    <a class="btn-default btn" href="{{route('DeleteUser',$user['id'])}}">Delete<i class="fa fa-trash" aria-hidden="true"></i></a>
                    <a class="btn-default btn" href="{{route('EditDriver',$user['id'])}}">Edit<i class="fa fa-pencil-square" aria-hidden="true"></i></a>
                </div>

            </div>
            {{--<div class="col-md-8">--}}
                {{--<div class="col-md-6">--}}
                    {{--<p>Фото Удс</p>--}}
                    {{--<img src="http://188.120.226.79/{{$user['card_photo']}}" class="img-responsive">--}}
                {{--</div>--}}
                {{--<div class="col-md-6">--}}
                    {{--<p>Фото Тех паспорта</p>--}}
                    {{--<img src="http://188.120.226.79/{{$user['tech_photo']}}" class="img-responsive">--}}
                {{--</div>--}}
            {{--</div>--}}
            <hr class="col-md-12">
        </div>
        <h2>Orders</h2>
        <div class="row taxi_orders">
            @if(count($taxi_orders) != 0)
                @foreach($taxi_orders as $order)
                    <div class="col-md-4">
                        <a href="{{route('DeleteOrder',$order['id'])}}"><i class="fa fa-trash" aria-hidden="true"></i></a>
                        <p>From: {{$order['from']}}</p>
                        <p>To: {{$order['to']}}</p>
                        <p>Price: {{$order['price']}}</p>
                        <p>Status: {{($order['step'] == 5)?'Is completed':'Not finished'}}</p>
                        <p>Creation dates: {{$order['created_at']}}</p>
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

