<?php

use Illuminate\Http\Request;

//User
Route::post('city','ApiController@City');

Route::post('paystack/pay', 'PaystackController@Pay');
Route::any('paystack/callback', 'PaystackController@Callback');
Route::any('paystack/webhook', 'PaystackController@Webhook');




Route::post('register','ApiController@register');
Route::post('auth','ApiController@auth');
Route::post('sms/auth','ApiController@smsAuth');
Route::post('verify','ApiController@verify');
Route::post('transition','ApiController@transition');
Route::post('transition/driver','ApiController@transitionDriver');
Route::post('profile/edit','ApiController@profileEdit');
Route::post('profile/address_edit','ApiController@profileAddressEdit');
Route::post('balanse/translate/to/user','ApiController@BalanseTranslateToUser');
Route::post('balanse/translate/to/price','ApiController@BalanseTranslateToPrice');

Route::post('promo','ApiController@PromoCode');
Route::post('promo/deletes','ApiController@DeleteMyPromoCodes');

//Gets
Route::get('user/{id}','ApiController@GetUser');
Route::get('delete/{id}','ApiController@DeleteUser');
Route::get('taxi_car/{id}','ApiController@GetTaxiCar');
Route::get('toy_car/{id}','ApiController@GetToyCat');
Route::get('cargo_car/{id}','ApiController@GetCargoCar');
Route::get('special_car/{id}','ApiController@GetSpecialCar');
Route::get('taxi_order/{id}','ApiController@GetTaxiOrder');

//Lists
Route::get('special_cars/{token?}','ApiController@SpecialCars');
Route::get('toy_cars/{token?}','ApiController@ToyCars');
Route::get('notifications','ApiController@Notifications');
Route::get('notification/{id}','ApiController@Notification');


//Orders
Route::post('order/intercity/create','ApiController@CreateIntercityOrder');
Route::get('order/intercity/list','ApiController@ListIntercityOrder');
Route::get('order/intercity/get/{id}','ApiController@GetIntercityOrder');
Route::post('order/intercity/end/','ApiController@EndIntercityOrder');
Route::post('order/intercity/cancel/','ApiController@CancelIntercityOrder');
Route::post('order/intercity/history','ApiController@HistoryIntercityOrder');
Route::post('order/intercity/active','ApiController@ActiveIntercityOrder');

//Cargo Order
Route::post('order/cargo/create','ApiController@CreateCargoOrder');
Route::get('order/cargo/list','ApiController@ListCargoOrder');
Route::get('order/cargo/get/{id}','ApiController@GetCargoOrder');
Route::post('order/cargo/end','ApiController@EndCargoOrder');
Route::post('order/cargo/cancel','ApiController@CancelCargoOrder');
Route::post('order/cargo/history','ApiController@HistoryCargoOrder');
Route::post('order/cargo/active','ApiController@ActiveCargoOrder');

//Feedback
Route::post('feedback/create','ApiController@FeedbackCreate');

//Create Car
Route::post('create_cargo_car','ApiController@CreateCargoCar');
Route::post('create_toy_car','ApiController@CreateToyCar');
Route::post('create_special_car','ApiController@CreateSpecialCar');

//Offer
Route::post('offer/create','ApiController@OfferCreate');
Route::post('offer/accept','ApiController@OfferAccept');

//Generators,Lists
Route::get('cities','ApiController@cities');
Route::get('colors','ApiController@Colors');
Route::get('car_marks','ApiController@CarMarks');
Route::get('car_model/{id}','ApiController@CarModel');
Route::get('all_offline','ApiController@AllOffline');


Route::post('query_friend','ApiController@QueryFriend');
Route::post('accept_friend','ApiController@AcceptFriend');
Route::post('friends','ApiController@Friends');
Route::post('friends/delete','ApiController@DeleteFriend');
//SOCKET API


Route::post('geo','ApiController@Geo');
Route::post('geopositions','ApiController@Geopositions');
Route::post('online','ApiController@Online');
Route::post('offline','ApiController@Offline');
Route::post('order_create','ApiController@CreateTaxiOrder');
Route::post('order_cancel','ApiController@CancelTaxiOrder');
Route::post('order_remove','ApiController@RemoveTaxiOrder');
Route::post('order_accept','ApiController@AcceptTaxiOrder');
Route::post('order_trade_accept','ApiController@TradeAcceptTaxiOrder');
Route::post('order_arrived','ApiController@ArrivedTaxiOrder');
Route::post('order_out','ApiController@OutTaxiOrder');
Route::post('order_end','ApiController@EndTaxiOrder');
Route::post('order_list','ApiController@ListTaxiOrder');

Route::post('order_history','ApiController@HistoryTaxiOrder');
Route::post('order_address_history','ApiController@HistoryAddressTaxiOrder');

Route::post('tariffs', 'ApiController@tariffsCity');


Route::post('access','ApiController@Access');
Route::post('check','ApiController@Check');
Route::post('sendme','ApiController@SendMe');


Route::prefix('v2/order')->group(function () {
    Route::post('create','ApiController@OrderCreate');
    Route::post('edit','ApiController@OrderEdit');
    Route::post('remove','ApiController@OrderRemove');
    Route::get('list','ApiController@OrderList');
    Route::post('my','ApiController@OrderMy');
});
Route::prefix('v2/auto')->group(function () {
    Route::post('create','ApiController@AutoCreate');
    Route::post('edit','ApiController@AutoEdit');
    Route::post('remove','ApiController@AutoRemove');
    Route::get('list','ApiController@AutoList');
    Route::post('my','ApiController@AutoMy');
    Route::post('activate','ApiController@AutoActivate');
    Route::post('deactivate','ApiController@AutoDeactivate');
    Route::post('favorite','ApiController@favorite');

    Route::get('check','ApiController@AutoCheck');
});
