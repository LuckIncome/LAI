@extends('layouts.admin')

@section('content')
    <div class="container">
        <form action="{{route('CreateModerator')}}" method="post" class="col-md-4">
            {{csrf_field()}}
            <input required class="form-control form-group" type="text" name="login" placeholder="Login">
            <input required class="form-control form-group" type="text" name="password" placeholder="Password">
            <input class="form-control form-group btn-primary" type="submit" value="Create">
        </form>
    </div>
    <div class="container" style="margin-top: 100px;">
        <h2>Модераторы</h2>
        @foreach($items as $item)
            @if($item->login != 'admin')
                <div style="border-bottom: 1px solid;margin-bottom: 30px;">
                    <p><b>Login :</b>{{$item->login}}</p>
                    <p><b>Password :</b>{{$item->password}}</p>
                    <a href="{{route('DeleteModerator',$item->id)}}">Удалить</a>
                </div>
            @endif
        @endforeach
    </div>


@endsection

@section('js')

@endsection

