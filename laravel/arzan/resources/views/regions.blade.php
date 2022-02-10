@extends('layouts.admin')
@section('content')

    @foreach($cities as $city)
        <form method="post" action="{{route('saveRegions')}}">
            {{csrf_field()}}
            <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                <div class="card">
                    <div class="body">
{{--                        <p id="city">Город: {{$city->name}}</p>--}}
                        <p>City: <input type="text" name="city" placeholder="{{$city->name}}" required value="{{$city->name}}"> </p>
                        <p>Price: <input type="text" name="price" placeholder="{{$city->price}}" required value="{{$city->price}}"> </p>
                        <div class="form-group">
                            <input type="submit" class="btn btn-primary" value="Save">
                        </div>
                    </div>
                </div>
            </div>
        </form>
    @endforeach

@endsection