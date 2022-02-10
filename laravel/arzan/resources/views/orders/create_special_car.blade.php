@extends('layout')
@section('content')
  <div class="container">
    <div class="row">
        <form action="{{route('AddSpecialCar')}}" method="post" enctype="multipart/form-data">
            {{csrf_field()}}
            <div class="form-group">
                <label>Name</label>
                <input class="form-control" required name="name" type="text">
            </div>
            <div class="form-group">
                <label>Phone</label>
                <input class="form-control" required name="phone" type="text">
            </div>
            <div class="form-group">
                <label>info  </label>
                <input class="form-control" required name="info" type="text">
            </div>
            <div class="form-group">
                <label>text</label>
                <textarea name="text" class="form-control"></textarea>
            </div>
            <div class="form-group">
                <label>photo</label>
                <input type="file" name="images[]" multiple class="btn btn-success" >
            </div>
            <div class="form-group">
                <input type="submit" class="btn btn-primary" value="Create">
            </div>
        </form>
    </div>
  </div>

@endsection

