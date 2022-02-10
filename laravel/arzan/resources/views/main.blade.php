@extends('layouts.admin')

@section('content')
  <div class="wrapper">
    <h2>Search...</h2>
    <form action="{{route('search')}}" method="get">
      <div class="form-group">
        <div class="form-line">
          <input required class="form-control" type="search" name="text" placeholder="user phone number or name">
        </div>
      </div>
      <button type="submit" class="btn btn-primary m-t-15 waves-effect">Поиск</button>
    </form>
  </div>

  <style>
    .wrapper{
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      text-align: center;
      width: 100%;
      height: 100%;
    }
    .wrapper input{
      padding: 0 25px;
      margin-top: 50px;
      min-width: 450px;
    }
  </style>
@endsection

