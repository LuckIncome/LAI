@extends('layouts.admin')
@section('content')
  <div class="container">

    <div class="users ">
      @foreach($users as $user)
        <div class="user row">
          <div class="col-md-3 img">
            @if($user['avatar'] == 'no image')
              <img src="http://placehold.it/760x450?text=Нет Фото">
            @else
              <img src="http://188.120.226.79/{{$user['avatar']}}" >
            @endif
          </div>
          <div class="col-md-9">

            <h4>{{$user['surname']}} {{$user['name']}} {{$user['middle_name']}}</h4>
            <p>№ {{$user['id']}}</p>
            <p>Номер {{$user['phone']}}</p>
            <p>Город: {{$user['city']}}</p>
            <p>Баланс: <b>{{$user['balanse']}}</b></p>
            @if ($user['role'] == 1)
                  <p>Type: Passenger</p>
                  <a class="btn btn-default" href="{{route('Passenger',$user['id'])}}">Open</a>
            @else
                  <p>Type: Driver</p>
                  <a class="btn btn-default" href="{{route('Driver',$user['id'])}}">Open</a>
            @endif
              <a href="{{route('BlackListDelete',$user['id'])}}" class="btn btn-primary">Remove from BlackList(ban)</a>
          </div>
        </div>
      @endforeach
    </div>
  </div>

  <style>
      img{
          max-width: 100%;
          display: block;
      }
      .img{
          overflow: hidden;
          max-height: 200px;
      }
      .user{
          margin-bottom: 25px;
      }
  </style>
@endsection

