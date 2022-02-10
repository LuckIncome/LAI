@extends('layout')
@section('content')
  <div class="container">
    <div class="row">
        <form action="{{route('AddToyCar')}}" method="post" enctype="multipart/form-data">
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
                <label>Price</label>
                <input class="form-control" required name="price" type="text">
            </div>
            <div class="form-group">
                <label>Year</label>
                <input class="form-control" required name="year" type="text">
            </div>
            <div class="form-group">
                <label>Mark</label>
                <select onchange="GetModel(this.value)" required class="form-control" name="car_mark_id">
                    @foreach($marks as $mark)
                        <option value="{{$mark->id}}">{{$mark->name}}</option>
                    @endforeach
                </select>
            </div>
            <div class="form-group">
                <label>Model</label>
                <select required class="form-control" name="car_model_id" id="car_model_id">

                </select>
            </div>
            <div class="form-group">
                <label>Color</label>
                <select required class="form-control" name="color_id">
                    @foreach($colors as $color)
                        <option value="{{$color->id}}">{{$color->name_en}}</option>
                    @endforeach
                </select>
            </div>
            <div class="form-group">
                <label>Photo</label>
                <input type="file" name="images[]" multiple class="btn btn-success" >
            </div>
            <div class="form-group">
                <input type="submit" class="btn btn-primary" value="Create">
            </div>
        </form>
    </div>
  </div>
  <script>
      function GetModel(id) {
          $.ajax({
              url: "http://188.120.226.79/api/car_model/"+id,
              type: "GET",
              success: function(response) {
                  if (response.statusCode == 200){
                      $('#car_model_id').html(``);
                      for(let item of response.result){
                          $('#car_model_id').append(`
                             <option value="${item.id}">${item.name}</option>
                          `)
                      }
                  }
              }
          });
      }
  </script>
@endsection

