@extends('layouts.admin')
@section('content')
  <div class="container">
    <div class="row">
      <form action="{{route('SavePassenger')}}" method="post" class="user_edit" enctype="multipart/form-data">
        {{csrf_field()}}
        <input type="hidden" name="id" value="{{$user->id}}">
        <div class="form-group">
          <label>surname</label>
          <input class="form-control" type="text" name="surname" required value="{{$user->surname}}">
        </div>
        <div class="form-group">
          <label>name</label>
          <input class="form-control" type="text" name="name" required value="{{$user->name}}">
        </div>
        <div class="form-group">
          <label>middle name</label>
          <input class="form-control" type="text" name="middle_name" required value="{{$user->middle_name}}">
        </div>
        <div class="form-group">
          <label>phone</label>
          <input class="form-control" type="text" name="phone" required value="{{$user->phone}}">
        </div>
        <div class="form-group">
          <label>city</label>
          <select class="form-control" name="city_id">
            @foreach($cities as $city)
              <option {{($city->id == $user->city_id)?'selected':''}} value="{{$city->id}}">{{$city->name}}</option>
            @endforeach
          </select>
        </div>
        <div class="form-group">
          <label>promocode</label>
          <input class="form-control" type="number" name="promo_code" required value="{{$user->promo_code}}">
        </div>
        @if (session()->get('login') == 'admin')
          <div class="form-group">
            <label>blance</label>
            <input min="0" class="form-control" type="number" name="balanse" required value="{{$user->balanse}}">
          </div>
        @endif
        <div class="form-group">
          <label>Rating</label>
          <input class="form-control" min="0" max="5" type="number" name="rating" required value="{{$user->rating}}">
        </div>
        <div class="form-group">
          <label>Avatar</label>
          <input class="form-control" type="file" name="avatar">
        </div>
        <div class="form-group">
          <input type="submit" class="btn btn-primary" value="Save">
        </div>
      </form>
    </div>
  </div>
@endsection
