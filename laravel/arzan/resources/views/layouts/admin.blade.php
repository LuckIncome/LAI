@extends('layouts.layout')
@section('class','theme-light-blue')
@section('body')
    <!-- Page Loader -->
    <div class="page-loader-wrapper">
        <div class="loader">
            <div class="preloader">
                <div class="spinner-layer pl-red">
                    <div class="circle-clipper left">
                        <div class="circle"></div>
                    </div>
                    <div class="circle-clipper right">
                        <div class="circle"></div>
                    </div>
                </div>
            </div>
            <p>Wait...</p>
        </div>
    </div>
    <!-- #END# Page Loader -->
    <!-- Overlay For Sidebars -->
    <div class="overlay"></div>
    <!-- #END# Overlay For Sidebars -->

    <!-- Top Bar -->
    <nav class="navbar">
        <div class="container-fluid">
            <div class="navbar-header">
                <a href="javascript:void(0);" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse" aria-expanded="false"></a>
                <a href="javascript:void(0);" class="bars"></a>
                <a class="navbar-brand" href="../../index.html">Admin</a>
            </div>
        </div>
    </nav>
    <!-- #Top Bar -->
    <section>
        <!-- Left Sidebar -->
        <aside id="leftsidebar" class="sidebar">
            <!-- User Info -->
            <div class="user-info">
                <div class="image">
                    <img src="{{asset('/uploads/avatar.png')}}" width="48" height="48" alt="User" />
                </div>
                <div class="info-container">
                    <div class="name" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> {{session()->get('login')}}</div>

                    <div class="btn-group user-helper-dropdown">
                        <i class="material-icons" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">keyboard_arrow_down</i>
                        <ul class="dropdown-menu pull-right">

                            <li><a href="{{route('Out')}}"><i class="material-icons">input</i>Sign out</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <!-- #User Info -->
            <!-- Menu -->
            <div class="menu">
                <ul class="list">
                    <li class="header">Navigation</li>
                    <li class="active">
                        <a href="{{route('MainPage')}}">
                            <i class="material-icons">home</i>
                            <span>Главная</span>
                        </a>
                    </li>
                    <li>
                        <a href="{{url('/system/users?offset=0')}}">
                            <span>Пользователи</span>
                        </a>
                    </li>

                    <li>
                        <a href="{{route('Drivers')}}">
                            <span>Водители на карте</span>
                        </a>
                    </li>
                    <li>
                        <a href="{{route('Notifications')}}">
                            <span>Уведомления</span>
                        </a>
                    </li>
                    <li>
                        <a href="{{route('BlackLists')}}">
                            <span>Черный список(Запрет)</span>
                        </a>
                    </li>
                    <li>
                        <a href="{{route('Moderators')}}">
                            <span>Модераторы</span>
                        </a>
                    </li>
                    <li>
                        <a href="{{route('Feedback')}}">
                            <span>Отзыв</span>
                        </a>
                    </li>
                    {{--<li>--}}
                        {{--<a href="{{route('Translates')}}">--}}
                            {{--<span>Перевод</span>--}}
                        {{--</a>--}}
                    {{--</li>--}}

                    <li>
                        <a href="#" class="menu-toggle waves-effect waves-block">
                            <span>Заказы</span>
                        </a>
                        <ul class="ml-menu">
                            <li>
                                <a href="{{route('orders','special_orders')}}" class=" waves-effect waves-block">
                                    <span>Специальная техника</span>
                                </a>
                            </li>
                            <li>
                                <a href="{{route('orders','toy_orders')}}" class=" waves-effect waves-block">
                                    <span>Vip Такси</span>
                                </a>
                            </li>
                            <li>
                                <a href="{{route('orders','intercity_orders')}}" class=" waves-effect waves-block">
                                    <span>Межгород</span>
                                </a>
                            </li>
                            <li>
                                <a href="{{route('orders','cargo_orders')}}" class=" waves-effect waves-block">
                                    <span>Груз</span>
                                </a>
                            </li>
                            <li>
                                <a href="{{route('orders','moto_orders')}}" class=" waves-effect waves-block">
                                    <span>Мото</span>
                                </a>
                            </li>
                        </ul>
                    </li>

                    <li>
                        <a href="{{route('Payments')}}" class="waves-effect waves-block">
                            <span>Платежи</span>
                        </a>
                    </li>
                    <li>
                        <a href="{{route('Bonus')}}" class="waves-effect waves-block">
                            <span>Бонус</span>
                        </a>
                    </li>
                    <li>
                        <a href="{{route('RegionsPrice')}}" class="waves-effect waves-block">
                            <span>Регулировки цен по регионам</span>
                        </a>
                    </li>
                </ul>
            </div>
            <!-- #Menu -->
        </aside>
        <!-- #END# Left Sidebar -->

    </section>

    <section class="content">
        <div class="container-fluid">
            @yield('content')
        </div>
    </section>
@endsection