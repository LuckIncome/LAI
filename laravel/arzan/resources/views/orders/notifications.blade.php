@extends('layouts.admin')
@section('content')
  <div class="container">
     <div class="row">
         <a  class="btn btn-default" href="{{route('NotificationCreate')}}" style="margin-bottom: 50px;">Add</a>
     </div>
      <div class="row taxi_orders">

          @if(count($orders) != 0)
              @foreach($orders as $order)

                  <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                      <div class="card">
                          <div class="header">
                              <h2>
                                  {{$order->title}} <small>№{{$order->id}}</small>
                              </h2>
                              <ul class="header-dropdown m-r--5">
                                  <li class="dropdown">
                                      <a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                          <i class="material-icons">more_vert</i>
                                      </a>
                                      <ul class="dropdown-menu pull-right">
                                          <li><a href="{{route('Notification',$order->id)}}" class=" waves-effect waves-block">Open</a></li>
                                          <li><a href="{{route('NotificationDelete',$order->id)}}" class=" waves-effect waves-block">
                                                  Delete</a></li>
                                      </ul>
                                  </li>
                              </ul>
                          </div>
                          <div class="body">{{$order->created_at}}</div>
                      </div>
                  </div>

              @endforeach
          @else
              <p class="btn btn-link"></p>
          @endif
      </div>
    {{$orders->links()}}
  </div>
@endsection

