@extends('layouts.admin')
@section('content')
  <div class="container">
      <div class="row" style="margin-bottom: 25px">
          <form action="{{route('Passengers')}}">
              <div class="row">
                 <div class="col-12">
                     <input name="role" type="radio" id="all" class="radio-col-red" {{(!isset($request['role']))?'checked':''}}>
                     <label for="all">Все</label>

                     <input name="role" type="radio" id="drivers" class="radio-col-purple" value="2" {{($request['role'] == 2)?'checked':''}}>
                     <label for="drivers">Водитель</label>

                     <input name="role" type="radio" id="passengers" class="radio-col-lime" value="1" {{($request['role'] == 1)?'checked':''}}>
                     <label for="passengers">Клиенты</label>
                 </div>

                  <input type="hidden" name="offset" value="{{$request['offset']}}">
                  <select name="city_id" class="btn btn-default" style="margin:15px 0;">
                      <option value="on" selected >All cities</option>
                      @foreach(\App\Models\City::all() as $city )
                          <option {{($request['city_id'] == $city->id)?'selected':''}} value="{{$city->id}}">{{$city->name}}</option>
                      @endforeach
                  </select>
                  <button class="btn btn-default">Показать</button>
              </div>
          </form>
      </div>
    <div class="users ">
      @foreach($users as $user)
        <div class="user row">
          <div class="col-md-3 img">
            @if($user['avatar'] == 'no image')
              <img src="http://placehold.it/760x450?text=Нет Фото">
            @else
                <img src="{{asset($user['avatar'])}}">
            @endif
          </div>
          <div class="col-md-9">

            <h4>{{$user['surname']}} {{$user['name']}} {{$user['middle_name']}}</h4>
            <p>№ {{$user['id']}}</p>
            <p>Номер {{$user['phone']}}</p>
            <p>Город: {{$user['city']}}</p>
            <p>Баланс: <b>{{$user['balanse']}}</b></p>
            @if ($user['role'] == 1)
                  <p>Тип: клиент</p>
                  <a class="btn btn-default" href="{{route('Passenger',$user['id'])}}">Open Profile</a>
            @else
                  <p>Тип: Водитель</p>
                  <a class="btn btn-default" href="{{route('Driver',$user['id'])}}">Open Profile</a>
            @endif
          </div>
        </div>
      @endforeach
    </div>

     {!! $prevlink !!}

    {!! $links !!}


     {!! $nextlink !!}
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

