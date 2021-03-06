<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css" integrity="sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS" crossorigin="anonymous">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
    <link rel="stylesheet" type="text/css" href="{{asset('public/bidkap/style.css')}}">
    <style>
        /* Make the image fully responsive */
        .carousel-inner img {
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>
    <header style="position:relative">
        <img class='headerIMG'  src="{{asset('public/bidkap/img/Group 2334.')}}png" alt="">
        <div class="container headerregis">
            <div class="row">
                <div class="col-lg-5 col-md-5 offset-md-1">
                    <div class="logo ">
                        <div class="logoImg">
                            <img src="{{asset('public/bidkap/img/Nigeria 512.')}}512 .png" alt="">
                        </div>
                        <div class="text">
                            <h3>QazTaxi</h3>
                            <h4>Price is your QazTaxi</h4>
                            <h6>BIDKab taxi - comfotable work with high profit</h6>
                            <h4>+234 22 23 3778</h4>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-4 offset-md-2  ">
                    <div class="form card ">
                        <form class="card-body" method="post" action="{{route('SendEmail')}}">
                            {{csrf_field()}}
                            <input type="text" name="type" hidden value="2">
                            @if(session()->has('phone2'))
                                <div class="alert alert-danger">
                                    {{session()->get('phone2')}}
                                </div>
                            @endif
                            @if(session()->has('success2'))
                                <div class="alert alert-success">
                                    {{session()->get('success2')}}
                                </div>
                            @endif
                            <div class="card-title">
                                <h4>
                                    Connect to BIDKab for free and start earning tomorrow!
                                </h4>
                            </div>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <span class="input-group-text formImgspan"
                                          id="inputGroup-sizing-default">
                                            <img class="formImg" src="{{asset('public/bidkap/img/user-silhouette')}}.svg" />
                                        </span>
                                </div>
                                <input type="text" class="form-control"
                                       name="name"
                                       aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-default"
                                       placeholder="Name">
                            </div>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <span class="input-group-text formImgspan"
                                          id="inputGroup-sizing-default">
                                                    <img class="formImg" src="{{asset('public/bidkap/img/phone-receiver')}}.svg" />
                                                </span>
                                </div>
                                <input type="text" class="form-control"
                                       name="phone"
                                       aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-default"
                                       placeholder="Phone number">
                            </div>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend ">
                                    <span class="input-group-text formImgspan"
                                          id="inputGroup-sizing-default">
                                            <img class="formImg" src="{{asset('public/bidkap/img/envelope.svg')}}" />
                                        </span>
                                </div>
                                <input type="email" class="form-control"
                                       name="email"
                                       aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-default"
                                       placeholder="Email" style="outline:none">
                            </div>
                            <div class="checkPolicy">
                                <input type="checkbox" name="" value="">
                                <a href="#">Privacy Policy and Terms</a>
                            </div>
                            <div class="">
                                <button type="submit" class="btn sendApplication">
                                    Send application
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </header>
    <section class="goup" id="whypeoplechooseus">
        <div class="container">
            <h2 id="titleofwhy">Why people choose us</h2>
            <div class="row">
                <div class="col-md-6 col-12">
                    <div class="card mb-3 cardfour ">
                        <div class="card-body card-body-text">
                            <p class="card-text">Choose your own work schedule.You can travel with BIDkab  anytime and any day of the year.You decide when to drive, so driving with BIDKab will not interfere with important matters for you.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card mb-3 cardfour">

                        <div class="card-body card-body-text">
                            <p class="card-text">
                                All you need in one app.Just press the button and hit the road.You will receive step-by-step instructions,various tools(Services in the app) for increasing earnings, also 24 hours support - and all this through the app.
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card mb-3 cardfour">
                        <button id="becomedrive" type="button" name="button">
                            Become a driver
                        </button>
                        <div class="card-body card-body-text">
                            <p class="card-text">
                                The first passenger is free.No fees.(No any hidden fees, you only need to pay a subscription fee once a day)
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card mb-3 cardfour">
                        <div class="card-body card-body-text">
                            <p class="card-text">
                                Convenience of work with BIDKab.(This is work at any time.You decide when to get on the line.Taxi work can be both a main source of income an part-time work.You do not need to change your car make any changes to the appearance of the car. )
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <button id="goup" type="button" name="button">
            Go up
        </button>



    </section>
    <section id="description" >
        <div class="container">
            <h1 id="titleofwhydess">
                Conditions of connection to <br />
                BIDKab taxi in lagos city.
            </h1>
            <div class="row">
                <div class="description col-md-5">
                    <div class="buttonwithunderline">
                        <button class="buttonwithunderlines" type="button" name="button">Driver Requirements</button><br>
                        <span class="lineofbutton"></span>
                        <span>.</span>
                        <span class="lineofbutton"></span>
                    </div>
                    <img src="{{asset('public/bidkap/img/Intersection 1.png')}}" alt="">
                    <ul>
                        <li>Requirement to driver.</li>
                        <li>-You are citizen of Nigeria.</li>
                        <li>-You have a driving experience of more than 3 years.</li>
                        <li>-You have a neat appearance</li>
                        <li>-The ability to use a smartphone(tablet)</li>
                    </ul>
                </div>
                <div class="description col-md-5 offset-md-2">
                    <div class="buttonwithunderline">
                        <button class="buttonwithunderlines" type="button" name="button">Driver Requirements</button>
                    </div>
                    <img src="{{asset('public/bidkap/img/orig.png')}}" alt="">
                    <ul>
                        <li>Requirement to the car.</li>
                        <li>-Car released no earlier than 2000.</li>
                        <li>-Availability of insurance.</li>
                        <li>-Not a broken car</li>
                        <li>-Not a sport cars.</li>
                        <li>-Clean, not smoky salon.</li>
                    </ul>
                </div>
            </div>
            <div class="buttoncenter">
                <button class="" type="button" name="button">Send application</button>
            </div>
        </div>
    </section>
    <section class="anyquestion" id="howtostartworkingwith">
        <div class="container">
            <div class="row">
                <div class="col-md-7 offset-md-2">
                    <h2 id="titleofdescrip">
                        How to start working with BIDKab taxi in Logos city.
                    </h2>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3 offset-md-1">
                    <div class="anyquestionnumber">
                        <img src="{{asset('public/bidkap/img/1.png')}}" alt="">
                        <h6>Leave a request on the site </h6>
                    </div>
                </div>
                <div class="col-md-3 offset-md-1">
                    <div class="anyquestionnumber">
                        <img src="{{asset('public/bidkap/img/2.png')}}" alt="">
                        <h6>A specialist will contact you to register with the system. </h6>
                    </div>
                </div>
                <div class="col-md-3 offset-md-1">
                    <div class="anyquestionnumber">
                        <img src="{{asset('public/bidkap/img/3.png')}}" alt="">
                        <h6>Registration in the system and receiving the first orders</h6>
                    </div>
                </div>
            </div>
            <div class="anyquestions">
                <div class="col-md-6">
                    <h1>Any questions?</h1>
                    <h3>We are ready to answer them by <br>phone.</h3>
                </div>
            </div>
            <div class="offset-md-6 number">
                <h1>+234 22 23 3778</h1>
            </div>

        </div>
    </section>
    <section style="height:auto;padding: 20px 0;">
        <div id="demo" class="carousel slide" data-ride="carousel">
            <div class="row " style="width: 100%;margin-left:0;margin-right:0;">
                <div class="col-md-6 offset-md-3 col-12">
                    <div class="carousel-inner">
                        <div class="carousel-item active">
                            <iframe width="100%" height="315"
                                    src="https://www.youtube.com/embed/tgbNymZ7vqY">
                            </iframe>
                        </div>
                        <div class="carousel-item">
                            <iframe width="100%" height="315"
                                    src="https://www.youtube.com/watch?v=YvH_rtQ8wkA">
                            </iframe>
                        </div>
                        <div class="carousel-item">
                            <iframe width="100%" height="315"
                                    src="https://www.youtube.com/embed/tgbNymZ7vqY">
                            </iframe>
                        </div>
                    </div>
                </div>
            </div>


            <a class="carousel-control-prev" href="#demo" data-slide="prev" >
                <img src="{{asset('public/bidkap/img/left.png')}}" alt="">
            </a>
            <a class="carousel-control-next" href="#demo" data-slide="next" style="">
                <img src="{{asset('public/bidkap/img/right.png')}}" alt="">
            </a>
        </div>
    </section>
    <section class="becomeadrive" id="becomeadrive">
        <h1>BECOME A DRIVER</h1>
        <div class="container">
            <div class="row">
                <div class="col-md-6" style="position:static">
                    <h4>Our regular partners earn from 350,000 <br />
                        Nair to 450,000 Nair per month.</h4>
                    <h6>Have a car? Turn it into a money <br>
                        machine with 	</h6>
                    <div class="d-flex row phones" >
                        <div class="col-md-4">
                            <img class="imgfooter" src="{{asset('public/bidkap/img/Group 2318.png')}}" alt="">
                        </div>
                        <div class="col-md-4 ">
                            <div class="d-flex">
                                <a href=""><img class="socifoterimg" src="{{asset('public/bidkap/img/google-play-badge12.png')}}" alt=""></a>
                                <a href=""><img class="socifoterimg" src="{{asset('public/bidkap/img/Group 91.png')}}" alt=""></a>
                            </div>
                            <img class="imgfooter" src="{{asset('public/bidkap/img/Group 2317.png')}}" alt="">
                        </div>
                    </div>
                </div>
                <div class="col-lg-5 col-md-5 offset-md-1 phonesform  ">
                    <div class="form card ">
                        <form class="card-body" method="post" action="{{route('SendEmail')}}">
                            {{csrf_field()}}
                            <input type="text" name="type" hidden value="1">
                            @if(session()->has('phone1'))
                                <div class="alert alert-danger">
                                    {{session()->get('phone1')}}
                                </div>
                            @endif
                            @if(session()->has('success1'))
                                <div class="alert alert-success">
                                    {{session()->get('success1')}}
                                </div>
                            @endif
                            <div class="card-title">
                                <h4>
                                    Connect to BIDKab for free and start earning tomorrow!
                                </h4>
                            </div>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <span class="input-group-text formImgspan"
                                          id="inputGroup-sizing-default">
                                            <img class="formImg" src="{{asset('public/bidkap/img/user-silhouette')}}.svg" />
                                        </span>
                                </div>
                                <input type="text" class="form-control"
                                       name="name"
                                       aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-default"
                                       placeholder="Name">
                            </div>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <span class="input-group-text formImgspan"
                                          id="inputGroup-sizing-default">
                                                    <img class="formImg" src="{{asset('public/bidkap/img/phone-receiver')}}.svg" />
                                                </span>
                                </div>
                                <input type="text" class="form-control"
                                       name="phone"
                                       aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-default"
                                       placeholder="Phone number">
                            </div>
                            <div class="input-group mb-3">
                                <div class="input-group-prepend ">
                                    <span class="input-group-text formImgspan"
                                          id="inputGroup-sizing-default">
                                            <img class="formImg" src="{{asset('public/bidkap/img/envelope.svg')}}" />
                                        </span>
                                </div>
                                <input type="email" class="form-control"
                                       name="email"
                                       aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-default"
                                       placeholder="Email" style="outline:none">
                            </div>
                            <div class="checkPolicy">
                                <input type="checkbox" name="" value="">
                                <a href="#">Privacy Policy and Terms</a>
                            </div>
                            <div class="">
                                <button type="submit" class="btn sendApplication">
                                    Send application
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <footer >
        <div class="container">
            <div class="row">
                <div class="col-md-4 col-6 footelefttext">
                    <h6 style="font-weight: bold">Site map</h6>
                    <h6 id='Whypeoplechooseusclick'>Why people choose us </h6>
                    <h6 id="conditionsofconnectionclick">Conditions of connection</h6>
                    <h6 id="howtostartworkingwithclick">How to start working with BIDKab</h6>
                    <h6 id="becomeadriveclick">Become a drive</h6>
                </div>
                <div class="col-md-4 col-6 d-flex flex-column align-items-center
                                            justify-content-end" style="z-index: 1000;color:#5e5e5e;">
                    <div class="footerCenterSocImg">
                        <a href=""><img src="{{asset('public/bidkap/img/instagram.png')}}" alt=""></a>
                        <a href=""><img src="{{asset('public/bidkap/img/facebook.png')}}" alt=""></a>
                    </div>
                    <div class="footerPolicy" style="fo ">
                        <a href=""><ins>Privacy and Policy and Terms</ins></a>
                    </div>
                    <div class="">
                        <h6 style="text-align: center">
                            Lekki ikate bus stop, plot 14, block  <br/> 139b, Jose Maria, Escriva.
                        </h6>
                        <h6>
                            2010-2018 BidKab Company. All rights reserved
                        </h6>
                    </div>

                </div>
                <div class="col-md-4">
                    <div class=" d-flex flex-column align-items-end" style="margin-top: 45px">
                        <img class="footerlogo"src="{{asset('public/bidkap/img/Nigeria 512.512 .png')}}" alt="">
                        <h6 class="footerrighttext ">
                            Have a car?Turn it into a money <br> macine with our app.
                        </h6>
                        <div class="">
                            <a href="https://play.google.com/store/apps/details?id=app.nmn.com.bidkab&hl=ru"><img class="footersoc" src="{{asset('public/bidkap/img/Group 91.png')}}" alt=""></a>
                            <a href="https://itunes.apple.com/kz/app/bidkab/id1446217763?mt=8"><img class="footersoc" src="{{asset('public/bidkap/img/google-play-badge12.png')}}" alt=""></a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <div class="triangle triangle-3"></div>
        <div class="triangle triangle-2"></div>
        <div class="triangle triangle-4"></div>
    </footer>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js" integrity="sha384-wHAiFfRlMFy6i5SRaxvfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js" integrity="sha384-B0UglyR+jN6CkvvICOB2joaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript">
    $('#Whypeoplechooseusclick').click(function (){
        $('html, body').animate({
            scrollTop: $("#whypeoplechooseus").offset().top
        }, 1000)
    });
    $('#conditionsofconnectionclick').click(function (){
        $('html, body').animate({
            scrollTop: $("#description").offset().top
        }, 1000)
    });
    $('#howtostartworkingwithclick').click(function (){
        $('html, body').animate({
            scrollTop: $("#howtostartworkingwith").offset().top
        }, 1000)
    });
    $('#becomeadriveclick').click(function (){
        $('html, body').animate({
            scrollTop: $("#becomeadrive").offset().top
        }, 1000)
    });
</script>
</body>
</html>
