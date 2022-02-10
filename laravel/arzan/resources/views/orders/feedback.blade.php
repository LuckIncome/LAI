@extends('layouts.admin')
@section('content')
  <div class="container">

      <div class="row taxi_orders">
          @if(count($items) != 0)
              @foreach($items as $item)

                      <div class="card">
                          <div class="header">
                              <h2>
                                  {{$item->surname }}  {{$item->name }}  {{$item->middle_name }}   <small>{{$item->phone}}</small>
                              </h2>
                              <a class="btn btn-danger" href="{{route('FeedbackDelete',$item->id)}}">
                                  Delete
                              </a>
                          </div>
                          <div class="body">{{$item->text}}
                              @foreach(\App\Models\Image::where('parent_type','admin_feedback')->where('parent_id',$item->id)->get() as $img)
                                  <div>
                                      <img src="{{asset($img->path)}}" width="300">
                                  </div>
                              @endforeach    
                          </div>
                          
                      </div>

              @endforeach
          @else
              <p class="btn btn-link">is empty</p>
          @endif
      </div>
  </div>

  <style>
      .header{
          display: flex;
          justify-content: space-between;
      }
  </style>
@endsection

