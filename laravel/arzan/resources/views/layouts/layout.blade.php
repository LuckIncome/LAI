<!doctype html>
<html>

<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <title>Admin</title>
    <!-- Favicon-->

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&subset=latin,cyrillic-ext" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" type="text/css">

    <!-- Bootstrap Core Css -->
    <link href="{{asset('/admin/plugins/bootstrap/css/bootstrap.css')}}" rel="stylesheet">

    <!-- Waves Effect Css -->
    <link href="{{asset('/admin/plugins/node-waves/waves.css')}}" rel="stylesheet" />

    <!-- Animation Css -->
    <link href="{{asset('/admin/plugins/animate-css/animate.css')}}" rel="stylesheet" />

    <!-- Custom Css -->
    <link href="{{asset('/admin/css/style.css')}}" rel="stylesheet">

    <!-- AdminBSB Themes. You can choose a theme from css/themes instead of get all themes -->
    <link href="{{asset('/admin/css/themes/all-themes.css')}}" rel="stylesheet" />
</head>

<body class="@yield('class')">
@yield('body')
<!-- Jquery Core Js -->
<script src="{{asset("/admin/plugins/jquery/jquery.min.js")}}"></script>

<!-- Bootstrap Core Js -->
<script src="{{asset('/admin/plugins/bootstrap/js/bootstrap.js')}}"></script>

<!-- Select Plugin Js -->

<!-- Slimscroll Plugin Js -->
<script src="{{asset('/admin/plugins/jquery-slimscroll/jquery.slimscroll.js')}}"></script>

<!-- Waves Effect Plugin Js -->
<script src="{{asset('/admin/plugins/node-waves/waves.js')}}"></script>

<!-- Custom Js -->
<script src="{{asset('/admin/js/admin.js')}}"></script>

<!-- Demo Js -->
<script src="{{asset('/admin/js/demo.js')}}"></script>
<script>
    @if(session()->has('message'))
        alert('{{session()->get('message')}}');
    @endif
</script>
<style>
    select{
        width: 100%;
        padding: 5px;
    }
</style>
</body>

</html>

