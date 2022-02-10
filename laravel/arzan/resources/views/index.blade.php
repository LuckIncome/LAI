@extends('layouts.layout')
@section('class','login-page')
@section('body')
  <div class="login-box">
    <div class="logo">
      <a href="javascript:void(0);">Админ</a>
    </div>
    <div class="card">
      <div class="body">
        <form id="sign_in" method="POST" action="{{route('SignInPost')}}">
          {{csrf_field()}}
          <div class="msg">Enter data to enter</div>
          <div class="input-group">
            <span class="input-group-addon">
                <i class="material-icons">person</i>
            </span>
            <div class="form-line">
              <input type="text" class="form-control" name="login" placeholder="Login" required autofocus>
            </div>
          </div>
          <div class="input-group">
            <span class="input-group-addon">
                <i class="material-icons">lock</i>
            </span>
            <div class="form-line">
              <input type="password" class="form-control" name="password" placeholder="Password" required>
            </div>
          </div>
          <div class="row">
            <div class="col-xs-12">
              <button class="btn btn-block bg-pink waves-effect" type="submit">Вход</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
@endsection

