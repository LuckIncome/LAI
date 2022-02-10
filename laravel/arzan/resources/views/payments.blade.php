@extends('layouts.admin')
@section('content')

    @foreach($payments as $pay)
      <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
        <div class="card">
          <div class="body">
            <p>#{{$pay->id}}</p>
            <p>Фамилия : {{$pay->surname}}</p>
            <p>Имя : {{$pay->name}}</p>
            <p>Отчество : {{$pay->middle_name}}</p>
            <p>Номер : {{$pay->phone}}</p>
            <p>бонусы: {{$pay->amount}}</p>
          </div>
        </div>
      </div>
    @endforeach
@endsection
