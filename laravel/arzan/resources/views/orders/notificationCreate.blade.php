@extends('layouts.admin')
@section('content')
  <div class="container">
      <div class="row notification">
          <form action="{{route('NotificationAdd')}}" method="post" enctype="multipart/form-data">
              {{csrf_field()}}
              <div class="form-group">
                  <label>title</label>
                  <input class="form-control" name="title" required type="text" value="">
              </div>
              <div class="form-group">
                  <label>text</label>
                  <textarea name="text" required class="form-control"></textarea>
              </div>
              <div class="form-group">
                  <label>Image</label>
                  <input class=" btn btn-success" name="image" type="file">
              </div>
              <div class="form-group">
                  <input class="btn btn-primary" type="submit">
              </div>
          </form>
      </div>
  </div>
@endsection

