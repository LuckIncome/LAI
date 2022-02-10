@extends('layouts.admin')
@section('content')

  @foreach($users as $user)
    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
      <div class="card">
        <div class="body">
          <p>#{{$user->id}}</p>
          <p>Фамилия : {{$user->surname}}</p>
          <p>Имя : {{$user->name}}</p>
          <p>Отчество : {{$user->middle_name}}</p>
          <p>Номер телефона : {{$user->phone}}</p>
          <p>бонус: {{$user->bonus}}</p>
          <p>Реферал : {{\App\Models\PromoCode::where('paid',0)->where('friend_user_id',$user->id)->count()}}</p>
          <a href="{{route('BonusPaid',$user->id)}}" class="btn btn-primary">Оплачено</a>

        </div>
      </div>
    </div>
  @endforeach
@endsection
