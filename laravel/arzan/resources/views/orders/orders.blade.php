@extends('layouts.admin')
@section('content')
    @if ($type == 'moto_orders')
        <h2>Motorcycle</h2>
        <div class="pull-right" style="margin-bottom: 40px">
            <a href="{{route('orders',[$type,1])}}" class="btn btn-primary">Active</a>
            <a href="{{route('orders',[$type,0])}}" class="btn btn-warning">Completed</a>
        </div>
        @foreach($orders as $order)
            <div class="col-lg-9 col-lg-offset-2">
                <div class="card">
                    <div class="header">
                        <h2>
                            {{$order->from}} -> {{$order->to}}
                            @if ($order->status == 1)
                                <small>active</small>
                            @else
                                <small>Not active</small>
                            @endif
                        </h2>
                        <div >
                            <a href="{{route('Passenger',$order->user_id)}}" class="btn btn-default">
                                User Profile
                            </a>
                            <a href="{{route('OrderDelete',$order->id)}}" class="btn btn-danger">
                                Delete
                            </a>
                        </div>
                    </div>
                    <div class="body">
                        <p><b>Price : </b>{{$order->price}}</p>
                        <p>{{$order->description}}</p>
                    </div>
                </div>
            </div>
        @endforeach
    @elseif($type == 'toy_orders')
        <h2>Vip Taxi</h2>
        <div class="pull-right" style="margin-bottom: 40px">
            <a href="{{route('orders',[$type,1])}}" class="btn btn-primary">Active</a>
            <a href="{{route('orders',[$type,0])}}" class="btn btn-warning">Completed</a>
        </div>
        @foreach($orders as $order)
            <div class="col-lg-9 col-lg-offset-2">
                <div class="card">

                    <div class="header">
                        <h2>
                            Дата: {{$order->out_date}}
                            @if ($order->status == 1)
                                <small>active</small>
                            @else
                                <small>Not active</small>
                            @endif
                        </h2>
                        <div >
                            <a href="{{route('Passenger',$order->user_id)}}" class="btn btn-default">
                                User Profile
                            </a>
                            <a href="{{route('OrderDelete',$order->id)}}" class="btn btn-danger">
                                Delete
                            </a>
                        </div>
                    </div>
                    <div class="body">
                        <p><b>Price : </b>{{$order->price}}</p>
                        <p>{{$order->description}}</p>
                    </div>
                </div>
            </div>
        @endforeach
    @elseif($type == 'intercity_orders')
        <h2>Intercity</h2>
        <div class="pull-right" style="margin-bottom: 40px">
            <a href="{{route('orders',[$type,1])}}" class="btn btn-primary">Active</a>
            <a href="{{route('orders',[$type,0])}}" class="btn btn-warning">Completed</a>
        </div>
        @foreach($orders as $order)
            <div class="col-lg-9 col-lg-offset-2">
                <div class="card">

                    <div class="header">
                        <h2>
                            {{$order->from}} -> {{$order->to}}
                            <small>
                                Date: {{$order->out_date}}
                            </small>
                            @if ($order->status == 1)
                                <small>active</small>
                            @else
                                <small>Not active</small>
                            @endif
                        </h2>
                        <div >
                            <a href="{{route('Passenger',$order->user_id)}}" class="btn btn-default">
                                User Profile
                            </a>
                            <a href="{{route('OrderDelete',$order->id)}}" class="btn btn-danger">
                                Delete
                            </a>
                        </div>
                    </div>
                    <div class="body">

                        <p><b>Price : </b>{{$order->price}}</p>
                        <p>{{$order->description}}</p>
                    </div>
                </div>
            </div>
        @endforeach
    @elseif($type == 'cargo_orders')
        <h2>Cargo</h2>
        <div class="pull-right" style="margin-bottom: 40px">
            <a href="{{route('orders',[$type,1])}}" class="btn btn-primary">Active</a>
            <a href="{{route('orders',[$type,0])}}" class="btn btn-warning">Completed</a>
        </div>
        @foreach($orders as $order)
            <div class="col-lg-9 col-lg-offset-2">
                <div class="card">
                    <div class="header">

                        <h2>
                            {{$order->from}} -> {{$order->to}}

                            @if ($order->status == 1)
                                <small>active</small>
                            @else
                                <small>Not active</small>
                            @endif
                        </h2>
                        <div >
                            <a href="{{route('Passenger',$order->user_id)}}" class="btn btn-default">
                               User Profile
                            </a>
                            <a href="{{route('OrderDelete',$order->id)}}" class="btn btn-danger">
                                Delete
                            </a>
                        </div>

                    </div>
                    <div class="body">

                        <p><b>Price : </b>{{$order->price}}</p>
                        <p>{{$order->description}}</p>
                    </div>
                </div>
            </div>
        @endforeach
    @elseif($type == 'special_orders')
        <h2>Special machinery</h2>
        <div class="pull-right" style="margin-bottom: 40px">
            <a href="{{route('orders',$type,1)}}" class="btn btn-primary">Active</a>
            <a href="{{route('orders',$type,0)}}" class="btn btn-warning">Completed</a>
        </div>
        @foreach($orders as $order)
            <div class="col-lg-9 col-lg-offset-2">
                <div class="card">
                    <div class="header">
                        <h2>
                            {{$order->to}}
                            @if ($order->status == 0)
                                <small>active</small>
                            @else
                                <small>Not active</small>
                            @endif
                        </h2>
                        <div >
                            <a href="{{route('Passenger',$order->user_id)}}" class="btn btn-default">
                                User Profile
                            </a>
                            <a href="{{route('OrderDelete',$order->id)}}" class="btn btn-danger">
                                Delete
                            </a>
                        </div>
                    </div>
                    <div class="body">

                        <p><b>Price : </b>{{$order->price}}</p>
                        <p>{{$order->description}}</p>
                    </div>
                </div>
            </div>
        @endforeach
    @endif
    <style>

        .container-fluid > h2{
            margin: auto;
            text-align: center;
            display: block;
            margin-bottom: 50px;
        }
        .header{
            display: flex;
            justify-content: space-between;
        }
        .header a{
            display: flex;
            align-items: center;
            justify-content: center;
            margin-left: 15px;
        }
        .header div{
            display: flex;
        }
    </style>
    {{$orders->links()}}
@endsection

