<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/


Route::get('/',function (){
   return File::get(public_path() . '/bidkap/index.html');
});


Route::prefix('system')->group(function () {

    Route::get('', 'AdminController@SignIn')->name('SignIn');
    Route::post('', 'AdminController@SignInPost')->name('SignInPost');


    Route::group(['middleware' => ['auth']], function () {
        Route::get('/out','AdminController@Out')->name('Out');
        Route::get('/main','AdminController@MainPage')->name('MainPage');

        Route::get('/users','AdminController@Passengers')->name('Passengers');
        Route::get('/passenger/{id}','AdminController@Passenger')->name('Passenger');
        Route::get('/direction/{id}','AdminController@Direction')->name('Direction');
        Route::get('/drivers','AdminController@Drivers')->name('Drivers');
        Route::get('/driver/{id}','AdminController@Driver')->name('Driver');
        Route::get('/delete/order/{id}','AdminController@DeleteOrder')->name('DeleteOrder');
        Route::get('/edit/passenger/{id}','AdminController@EditPassenger')->name('EditPassenger');
        Route::get('/edit/driver/{id}','AdminController@EditDriver')->name('EditDriver');
        Route::post('/save/passenger','AdminController@SavePassenger')->name('SavePassenger');
        Route::post('/save/driver','AdminController@SaveDriver')->name('SaveDriver');
        Route::get('/delete/user/{id}','AdminController@DeleteUser')->name('DeleteUser');

        Route::get('orders/{type}/{status?}','AdminController@Orders')->name('orders');
        Route::get('OrderDelete/{id}','AdminController@OrderDelete')->name('OrderDelete');
        Route::get('black_lists','AdminController@BlackLists')->name('BlackLists');
        Route::get('black_list/delete/{id}','AdminController@BlackListDelete')->name('BlackListDelete');
        Route::get('black_list/add/{id}','AdminController@BlackListAdd')->name('BlackListAdd');

        Route::get('translates','AdminController@Translates')->name('Translates');
        Route::get('translates/{user}/{price}','AdminController@TranslateToPrice')->name('TranslateToPrice');
        Route::get('payments','AdminController@Payments')->name('Payments');
        Route::get('bonus','AdminController@Bonus')->name('Bonus');
        Route::get('bonus/paid/{id}','AdminController@BonusPaid')->name('BonusPaid');
        Route::get('regions', 'AdminController@editRegionsPrice')->name('RegionsPrice');
        Route::post('/regions','AdminController@saveRegions')->name('saveRegions');

        /*
        Route::get('/orders/{bool?}','AdminController@Orders')->name('Orders');
        Route::get('/IntercityOrders','AdminController@IntercityOrders')->name('IntercityOrders');
        Route::get('/DeleteIntercityOrder/{id}','AdminController@DeleteIntercityOrder')->name('DeleteIntercityOrder');
        Route::get('/ToyCars','AdminController@ToyCars')->name('ToyCars');
        Route::get('/CreateToyCar','AdminController@CreateToyCar')->name('CreateToyCar');
        Route::post('/AddToyCar','AdminController@AddToyCar')->name('AddToyCar');
        Route::get('/DeleteToyCar/{id}','AdminController@DeleteToyCar')->name('DeleteToyCar');
        Route::get('/SpecialCars','AdminController@SpecialCars')->name('SpecialCars');
        Route::get('/CreateSpecialCar','AdminController@CreateSpecialCar')->name('CreateSpecialCar');
        Route::post('/AddSpecialCar','AdminController@AddSpecialCar')->name('AddSpecialCar');
        Route::get('/DeleteSpecialCar/{id}','AdminController@DeleteSpecialCar')->name('DeleteSpecialCar');
        Route::get('/CargoOrders','AdminController@CargoOrders')->name('CargoOrders');
        Route::get('/DeleteCargoOrder/{id}','AdminController@DeleteCargoOrder')->name('DeleteCargoOrder');
        */

        Route::get('/Notifications/','AdminController@Notifications')->name('Notifications');
        Route::get('/Notification/{id}','AdminController@Notification')->name('Notification');
        Route::post('/NotificationSave','AdminController@NotificationSave')->name('NotificationSave');
        Route::get('/NotificationCreate','AdminController@NotificationCreate')->name('NotificationCreate');
        Route::post('/NotificationAdd','AdminController@NotificationAdd')->name('NotificationAdd');
        Route::get('/NotificationDelete/{id}','AdminController@NotificationDelete')->name('NotificationDelete');

        Route::get('Feedback','AdminController@Feedback')->name('Feedback');
        Route::get('FeedbackDelete/{id}','AdminController@FeedbackDelete')->name('FeedbackDelete');


        Route::get('/Moderators','AdminController@Moderators')->name('Moderators');
        Route::get('/DeleteModerator/{id}','AdminController@DeleteModerator')->name('DeleteModerator');
        Route::post('/CreateModerator','AdminController@CreateModerator')->name('CreateModerator');

        Route::get('search','AdminController@search')->name('search');
    });
});