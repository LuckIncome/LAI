<?php

namespace App\Http\Controllers;

use App\Models\AdminFeedback;
use App\Models\Auto;
use App\Models\BalanseTranslate;
use App\Models\CargoCar;
use App\Models\CargoOrder;
use App\Models\CarMark;
use App\Models\CarModel;
use App\Models\City;
use App\Models\Color;
use App\Models\Feedback;
use App\Models\SmsCode;
use App\Models\Image;
use App\Models\IntercityOrder;
use App\Models\Notification;
use App\Models\Offer;
use App\Models\Order;
use App\Models\AutoFavorite;
use App\Models\OrderHistory;
use App\Models\PositionFriend;
use App\Models\PromoCode;
use App\Models\SpecialCar;
use App\Models\TaxiCar;
use App\Models\TaxiOrder;
use App\Models\ToyCar;
use App\Models\User;
use App\Models\Payment;
use App\Models\Woppay;
use App\PG_Signature;
use Couchbase\Exception;
use Illuminate\Filesystem\Cache;
use Illuminate\Http\Request;
use SebastianBergmann\CodeCoverage\Driver\Driver;
use Validator;
use File;
use DB;
use Carbon\Carbon;
use Illuminate\Support\Facades\Storage;
use Mail;
use GuzzleHttp\Client;
use GuzzleHttp\Cookie\CookieJar;
use GuzzleHttp\Cookie\FileCookieJar;
include 'smsc_api.php';
class ApiController extends Controller
{
//    ==================================Users========================================================

    public function register(Request $request){
        $rules = [
            'surname' => 'required',
            'name' => 'required',
            'middle_name' => 'required',
            'city_id' => 'required',
            'phone' => 'required',
            'avatar' => 'mimes:jpg,jpeg,png,gif',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else{
            $phone = User::where('phone',$request['phone'])->first();
            if ($phone != null){
                $result['statusCode ']= 401;
                $result['message']= 'Phone exist';
                $result['result']= $this->GetUser($phone->id)['result'];
            }
            else{
                $user = new User();
                $user->surname = $request['surname'];
                $user->name = $request['name'];
                $user->middle_name = $request['middle_name'];
                $user->phone = $request['phone'];
                $user->city_id = $request['city_id'];
                $user->token = str_random(60);
                $user->promo_code = mt_rand (1000000,9999999);
                $user->phone_verification_at = Carbon::now();
                if (isset($request['avatar'])){
                    $user->avatar = $this->uploadFile($request['avatar']);
                }
                $user->save();

                $result['statusCode ']= 200;
                $result['message']= 'Success!';
                $result['result']= $this->GetUser($user->id)['result'];;
            }
        }
        return $result;
    }
    public function auth(Request $request){
        $rules = [
            'phone' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else{
            $phone = User::where('phone',$request['phone'])->first();
            $sms = SmsCode::where('phone', $request['phone'])->first();

            if ($phone == null ){
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
            }
            else{
                if($phone->access == 1){
                    $result['statusCode ']= 200;
                    $result['message']= 'Success!';
                    $result['result']= $this->GetUser($phone->id)['result'];;
                }
                else{
                    $result['statusCode ']= 401;
                    $result['message']= 'no access!';
                    $result['result']= [];
                }
            }
        }
        return $result;
    }

    public function smsAuth(Request $request)
    {
        $rules = [
            'phone' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else{
            $phone = User::where('phone',$request['phone'])->first();
            $sms = SmsCode::where('phone', $request['phone'])->first();
//            if ($sms) {
//                $code = mt_rand (1000,9999);
//                $message = 'Arzan : ' . $code;
//                $smsResult = send_sms($request['phone'], $message, 1);
//                $sms->verification_code = $code;
//                $sms->save();
//                $result['statusCode ']= 404;
//                $result['message']= 'User not found';
//            }
            if ($phone == null){
                $code = mt_rand (1000,9999);
                $message = 'Arzan : ' . $code;
                $smsResult = send_sms($request['phone'], $message, 1);

                $smsCode = new SmsCode();
                $smsCode->phone = $request['phone'];
                $smsCode->verification_code = $code;
                $smsCode->save();

                $result['statusCode ']= 404;
                $result['message']= 'User not found';
            }
            else{
                if($phone){
                    if ($phone->access == 1) {
                        $result['statusCode ']= 200;
                        $result['message']= 'Success!';
                        $result['result']= $this->GetUser($phone->id)['result'];;
                    }
                }
//               else{
//                   $result['statusCode ']= 401;
//                   $result['message']= 'no access!';
//                   $result['result']= [];
//               }
            }
        }
        return $result;
    }

    public function verify(Request $request)
    {
        $rules = [
            'phone' =>  'required',
            'verification_code'  =>  'required',
        ];

        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else{
            $verCode = (int)$request['verification_code'];
            $code = SmsCode::where('phone', $request['phone'])->where('verification_code', $verCode)->first();
            if ($code == null){
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
            else{
                $result['statusCode'] = 200;
                $result['message'] = 'Success!';
                $result['result'] = $code;
            }
        }
        return $result;
    }



    public function transition(Request $request){
        $rules = [
            'token' => 'required',
            'role' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else{
            $user = User::where('token',$request['token'])->first();
            if ($user){
                $user->role = $request['role'];
                $user->save();
                $result['statusCode '] = 200;
                $result['message']= 'Success!';
                $result['result']= $this->GetUser($user->id)['result'];
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }

        return $result;
    }

    public function transitionDriver(Request $request){
        $rules = [
            'token' => 'required',
            'surname' => 'required',
            'name' => 'required',
            'middle_name' => 'required',
            'city_id' => 'required',
            'car_mark_id' => 'required',
            'car_model_id' => 'required',
            'number' => 'required',
            'year' => 'required',
            'color_id' => 'required',
            'avatar'    =>  'required|mimes:jpg,jpeg,png,gif',
//            'iin' => 'required',
//            'id_card' => 'required',

            'card_photo' => 'mimes:jpg,jpeg,png,gif',
            'card_photo_2' => 'mimes:jpg,jpeg,png,gif',

//            'expired_date' => 'required',
//            'tech_passport' => 'required',

            'tech_photo' => 'mimes:jpg,jpeg,png,gif',
            'tech_photo_2' => 'mimes:jpg,jpeg,png,gif',
            'prava_photo' => 'mimes:jpg,jpeg,png,gif',
            'prava_photo_2' => 'mimes:jpg,jpeg,png,gif',
            'car_photo' => 'mimes:jpg,jpeg,png,gif',
            'car_photo_2' => 'mimes:jpg,jpeg,png,gif',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else{
            $user = User::where('token',$request['token'])->first();
            if ($user){
                if ($user->driver_was == 1){
                    $result['statusCode ']= 401;
                    $result['message']= 'Driver Was Isset!';
                    $result['result']= $this->GetUser($user->id)['result'];
                }
                else{
                    $car = new TaxiCar();
                    $car->user_id = $user->id;
                    $car->car_mark_id = $request['car_mark_id'];
                    $car->car_model_id = $request['car_model_id'];
                    $car->number = $request['number'];
                    $car->year = $request['year'];
                    $car->color_id = $request['color_id'];
                    $car->save();

                    $user->surname = $request['surname'];
                    $user->name = $request['name'];
                    $user->middle_name = $request['middle_name'];
                    $user->city_id = $request['city_id'];
                    $user->driver_was = 1;
                    $user->role =2;


                    $user->card_photo = $this->uploadFile($request['card_photo']);
                    $user->card_photo_2 = $this->uploadFile($request['card_photo_2']);
                    $user->tech_photo = $this->uploadFile($request['tech_photo']);
                    $user->tech_photo_2 = $this->uploadFile($request['tech_photo_2']);
                    $user->prava_photo = $this->uploadFile($request['prava_photo']);
                    $user->prava_photo_2 = $this->uploadFile($request['prava_photo_2']);
                    $user->car_photo = $this->uploadFile($request['car_photo']);
                    $user->car_photo_2 = $this->uploadFile($request['car_photo_2']);

                    if (isset($request['avatar'])){
                        $this->deleteFile($user->avatar);
                        $user->avatar = $this->uploadFile($request['avatar']);
                    }
                    $user->balanse += 200;
                    $user->save();



                    $result['statusCode ']= 200;
                    $result['message']= 'Success!';
                    $result['result']= $this->GetUser($user->id)['result'];
                }
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }

        return $result;
    }
    public function profileEdit(Request $request){
        $rules = [
            'token' => 'required',
            'surname' => 'required',
            'name' => 'required',
            'middle_name' => 'required',
            'city_id' => 'required',
            'avatar' => 'mimes:jpg,jpeg,png,gif'
            /*
            'car_mark_id' => 'required',
            'car_model_id' => 'required',
            'year' => 'required',
            'color_id' => 'required',

            'iin' => 'required',
            'id_card' => 'required',
            'card_photo' => 'required|mimes:jpg,jpeg,png,gif',
            'expired_date' => 'required',
            'tech_passport' => 'required',
            'tech_photo' => 'required|mimes:jpg,jpeg,png,gif',

            'info' => 'required',
            'text' => 'required',
            */
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else{
            $user = User::where('token',$request['token'])->first();
            if ($user){
                if ($user->driver_was == 1){
                    if (isset($request['iin'])){
                        $user->iin = $request['iin'];
                    }
                    if (isset($request['id_card'])){
                        $user->id_card = $request['id_card'];
                    }
                    if (isset($request['expired_date'])){
                        $user->expired_date = $request['expired_date'];
                    }
                    if (isset($request['tech_passport'])){
                        $user->tech_passport = $request['tech_passport'];
                    }
                    if (isset($request['card_photo'])){
                        $user->card_photo = $user->avatar = $this->uploadFile($request['card_photo']);
                    }
                    if (isset($request['tech_photo'])){
                        $user->tech_photo = $user->avatar = $this->uploadFile($request['tech_photo']);
                    }

                    $car = TaxiCar::where('user_id',$user->id)->first();
                    if ($car){
                        if (isset($request['car_mark_id'])){
                            $car->car_mark_id = $request['car_mark_id'];
                        }
                        if (isset($request['car_model_id'])){
                            $car->car_model_id = $request['car_model_id'];
                        }
                        if (isset($request['number'])){
                            $car->number = $request['number'];
                        }
                        if (isset($request['year'])){
                            $car->year = $request['year'];
                        }
                        if (isset($request['color_id'])){
                            $car->color_id = $request['color_id'];
                        }
                        $car->save();
                    }
                    $cargo_car = CargoCar::where('user_id',$user->id)->first();
                    if ($cargo_car){
                        if (isset($request['info'])){
                            $cargo_car->info = $request['info'];
                        }
                        if (isset($request['text'])){
                            $cargo_car->text = $request['text'];
                        }
                        $cargo_car->save();
                    }

                }

                $user->surname = $request['surname'];
                $user->name = $request['name'];
                $user->middle_name = $request['middle_name'];
                $user->city_id = $request['city_id'];

                if (isset($request['avatar'])){
                    $this->deleteFile($user->avatar);
                    $user->avatar = $this->uploadFile($request['avatar']);
                }
                $user->save();

                $result['statusCode ']= 200;
                $result['message']= 'Success!';
                $result['result']= $this->GetUser($user->id)['result'];
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }

        return $result;
    }
    public function profileAddressEdit(Request $request){
        $rules = [
            'token' => 'required',
            'home_lng' => 'numeric',
            'home_lat' => 'numeric',
            'work_lng' => 'numeric',
            'work_lat' => 'numeric',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else{
            $user = User::where('token',$request['token'])->first();
            if ($user){

                $user->home_address = $request['home_address'] ??  $user->home_address;
                $user->home_lng = $request['home_lng'] ??  $user->home_lng;
                $user->home_lat = $request['home_lat'] ??  $user->home_lat;
                $user->work_lng = $request['work_lng'] ?? $user->work_lng;
                $user->work_address = $request['work_address'] ?? $user->work_address;
                $user->work_lat = $request['work_lat'] ?? $user->work_lat ;
                $user->save();

                $result['statusCode ']= 200;
                $result['message']= 'Success!';
                $result['result']= null;
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }

        return $result;
    }

    public function PromoCode(Request $request){
        $rules = [
            'token' => 'required',
            'promo_code' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user != null) {
                $friend = User::where('promo_code',$request['promo_code'])->first();
                if($friend != null){
                    if  ($user->id != $friend->id){
                        if ($friend != null){
                            if ($user->promo_code_access == 1){


                                $new_promo = new PromoCode();
                                $new_promo->user_id = $user->id;
                                $new_promo->friend_user_id = $friend->id;
                                $new_promo->save();

                                $user->promo_code_access = 0;
                                $user->save();

                                $result['statusCode ']= 200;
                                $result['message']= 'Success';
                                $result['result']['user']= $this->GetUser($user->id)['result'];
                                $result['result']['friend']= $this->GetUser($friend->id)['result'];
                            }
                            else{
                                $result['statusCode ']= 403;
                                $result['message']= 'Promo Code Уже исполь.';
                                $result['result']= [];
                            }
                        }
                        else{
                            $result['statusCode ']= 404;
                            $result['message']= 'friend not found';
                            $result['result']= [];
                        }
                    }
                    else{
                        $result['statusCode ']= 404;
                        $result['message']= 'friend not found';
                        $result['result']= [];
                    }
                }
                else{
                    $result['statusCode ']= 404;
                    $result['message']= 'friend not found';
                    $result['result']= [];
                }
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function DeleteMyPromoCodes(Request $request){
        $rules = [
            'token' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user != null) {
                $promo_codes = PromoCode::where('user_id',$user->id)->get();
                if (count($promo_codes) != 0){
                    foreach ($promo_codes as $promo_code) {
                        $promo_code->delete();
                    }
                }
                $result['statusCode ']= 200;
                $result['message']= 'PromoCodes deletes !';
                $result['result']= $this->GetUser($user->id);
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }

    public function BalanseTranslateToUser(Request $request){
        $rules = [
            'token' => 'required',
            'phone' => 'required',
            'balanse' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user = User::where('token', $request['token'])->first();
            if ($user != null) {
                $b = User::where('phone',$request['phone'])->first();
                if   ($b){
                    if  ($b->id != $user->id){
                        if  ($user->balanse >= $request['balanse']){
                            $balanse = $user->balanse -= $request['balanse'];
                            if  ($balanse < 100){
                                $result['statusCode ']= 402;
                                $result['message']= '< 100';
                                $result['result']= [];
                            }
                            else{
                                $user->save();
                                $b->balanse += $request['balanse'];
                                $b->save();

                                $result['statusCode '] = 200;
                                $result['message'] = 'success';
                                $result['result'] = [];
                            }
                        }
                        else{
                            $result['statusCode ']= 401;
                            $result['message']= 'Balanse';
                            $result['result']= [];
                        }

                    }
                    else{
                        $result['statusCode ']= 404;
                        $result['message']= 'User not found';
                        $result['result']= [];
                    }
                }
                else{
                    $result['statusCode ']= 404;
                    $result['message']= 'User not found';
                    $result['result']= [];
                }
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function BalanseTranslateToPrice(Request $request){
        $rules = [
            'token' => 'required',
            'balanse' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user = User::where('token', $request['token'])->first();
            if ($user != null) {
                if  ($user->balanse >= $request['balanse']){

                    $b = new BalanseTranslate();
                    $b->user_id = $user->id;
                    $b->balanse = $request['balanse'];
                    $b->save();


                    $result['statusCode ']= 200;
                    $result['message']= 'Success';
                    $result['result']= [];
                }
                else{
                    $result['statusCode ']= 401;
                    $result['message']= 'Balanse';
                    $result['result']= [];
                }
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }

    public function AllOffline(){
        foreach (User::all() as $user) {
            $user->online = 0;
            $user->save();
        }
    }
    public function GetUser($id){
        $user = User::find($id);
        if ($user){
            try{
                $item['id'] = $user->id;
                $item['surname'] = $user->surname;
                $item['name'] = $user->name;
                $item['middle_name'] = $user->middle_name;
                $item['phone'] = $user->phone;
                $item['role'] = $user->role;
                $item['city_id'] = $user->city_id;
                $item['city'] = City::find($user->city_id)->name;
                $item['lat'] = $user->lat;
                $item['lon'] = $user->lon;
                $item['avatar'] = $user->avatar;
                $item['token'] = $user->token;
                $item['promo_code'] = $user->promo_code;
                $item['promo_code_access'] = $user->promo_code_access;
                $item['balanse'] = $user->balanse;
                $item['online'] = $user->online;
                $item['year'] = $user->year;
                $item['driver_was'] = $user->driver_was;
                $item['card_photo'] = $user->card_photo;
                $item['card_photo_2'] = $user->card_photo_2;
                $item['tech_photo'] = $user->tech_photo;
                $item['tech_photo_2'] = $user->tech_photo_2;
                $item['prava_photo'] = $user->prava_photo;
                $item['prava_photo_2'] = $user->prava_photo_2;
                $item['car_photo'] = $user->car_photo;
                $item['car_photo_2'] = $user->car_photo_2;
                $item['rating'] = $user->rating;
                $item['socket_id'] = $user->socket_id;
                $item['access'] = $user->access;
                $item['home_address'] = $user->home_address;
                $item['home_lng'] = $user->home_lng;
                $item['home_lat'] = $user->home_lat;
                $item['work_address'] = $user->work_address;
                $item['work_lng'] = $user->work_lng;
                $item['work_lat'] = $user->work_lat;
                $taxi_car = TaxiCar::where('user_id',$id)->first();
                if ($taxi_car){
                    $item['taxi_cars'] = $this->GetTaxiCar($taxi_car->id)['result'];
                }
                else{
                    $item['taxi_cars']  = null;
                }

                $toy_cars = ToyCar::where('user_id',$id)->get();
                if (count($toy_cars) != 0 ){
                    foreach ($toy_cars as $car) {
                        $item['toy_cars'][] = $this->GetToyCat($car->id)['result'];
                    }
                }
                else{
                    $item['toy_cars']  = [];
                }
                $special_cars = SpecialCar::where('user_id',$id)->get();
                if (count($special_cars) != 0 ){
                    foreach ($special_cars as $special_car) {
                        $item['special_cars'][] = $this->GetSpecialCar($special_car->id)['result'];
                    }
                }
                else{
                    $item['special_cars']  = [];
                }


                $cargo_cars = CargoCar::where('user_id',$id)->get();
                if (count($cargo_cars) != 0 ){
                    foreach ($cargo_cars as $car) {
                        $item['cargo_cars'][] = $this->GetCargoCar($car->id)['result'];
                    }
                }
                else{
                    $item['cargo_cars']  = [];
                }




                $result['statusCode'] = 200;
                $result['message'] = 'Success!';
                $result['result'] = $item;

            }catch (Exception $e){
                $result['statusCode'] = 404;
                $result['message'] = 'User Not Found';
                $result['result'] = [];
            }
        }
        else{
            $result['statusCode'] = 404;
            $result['message'] = 'User Not Found';
            $result['result'] = [];
        }

        return $result;
    }
    public function DeleteUser($id){
        $user = User::find($id);
        $user->delete();
        return 'ok';
    }
    public function GetTaxiCar($id){
        $car = TaxiCar::find($id);
        if ($car){
            $item['id'] = $car->id;
            $item['type'] = $car->type;
            $item['car_mark_id'] = $car->car_mark_id;
            $item['car_mark'] = CarMark::find($car->car_mark_id)->name;
            $item['car_model_id'] =$car->car_model_id;
            $item['car_model'] = CarModel::find($car->car_model_id)->name;
            $item['number'] = $car->number;
            $item['year'] = $car->year;
            $item['color'] = Color::find($car->color_id);
            $item['vip'] = $car->vip;
            $item['images'] = $this->Images($car->type,$car->id);

            $result['statusCode'] = 200;
            $result['message'] = 'Sucesss!';
            $result['result'] = $item;
        }
        else{
            $result['statusCode'] = 404;
            $result['message'] = 'User Not Found';
            $result['result'] = null;
        }
        return $result;
    }
    public function GetTaxiOrder($id){
        $order = TaxiOrder::find($id);
        //EQ("="), GTE(">="), GT(">"), LT("<"), LTE("<=");

        if ($order){
            if ($order->step == 1){
                if  (Carbon::parse($order->updated_at)->addMinutes(3)->lte(Carbon::now())){
                    $order->delete();
                    $result['statusCode'] = 404;
                    $result['message'] = 'Deleted';
                    $result['result'] = [];

                    return $result;
                }
            }
            $item['id'] = $order->id;
            $item['type'] = $order->type;
            $item['passenger_id'] = $order->passenger_id;
            $item['passenger'] = $this->GetUser($order->passenger_id)['result'];
            $item['driver_id'] = $order->driver_id;
            $item['driver'] = $this->GetUser($order->driver_id)['result'];
            $item['from'] = $order->from;
            $item['from_lat'] = $order->from_lat;
            $item['from_lon'] = $order->from_lon;
            $item['to'] = $order->to;
            $item['to_lat'] = $order->to_lat;
            $item['to_lon'] = $order->to_lon;
            $item['price'] = $order->price;
            $item['city_id'] = $order->city_id;
            $item['count_passenger'] = $order->count_passenger;
            $item['get_passenger'] = $order->get_passenger;
            $item['bonus'] = $order->bonus;
            $item['invalid'] = $order->invalid;
            $item['woman_driver'] = $order->woman_driver;
            $item['status'] = $order->status;
            $item['description'] = $order->description;
            $item['step'] = $order->step;
            $item['created_at'] = Carbon::parse($order->created_at)->format('d.m.Y H:i:s');

            $result['statusCode'] = 200;
            $result['message'] = 'Sucesss!';
            $result['result'] = $item;

        }
        else{
            $result['statusCode'] = 404;
            $result['message'] = 'Orderorder_remove Not Found';
            $result['result'] = [];
        }
        return $result;
    }
    public function GetCargoCar($id){
        $car = CargoCar::find($id);
        if ($car){
            $item['id'] = $car->id;
            $item['type'] = $car->type;
            $item['user_id'] = $car->user_id;
            $item['info'] = $car->info;
            $item['images'] = $this->Images($car->type,$car->id);

            $result['statusCode'] = 200;
            $result['message'] = 'Sucesss!';
            $result['result'] = $item;
        }
        else{
            $result['statusCode'] = 404;
            $result['message'] = 'Cargo Car Not Found';
            $result['result'] = [];
        }
        return $result;
    }
    public function GetToyCat($id){
        try{
            $car = ToyCar::find($id);
            $user = User::find($car->user_id);
            if ($car){
                if  ($user){
                    $item['id'] = $car->id;
                    $item['type'] = $car->type;
                    $item['user_id'] = $car->user_id;
                    $item['name'] = $user->name;
                    $item['phone'] = $user->phone;
                    $item['price'] = $car->price;
                    $item['car_mark_id'] = $car->car_mark_id;
                    $item['car_mark'] = CarMark::find($car->car_mark_id)->name;
                    $item['car_model_id'] = $car->car_model_id;
                    $item['car_model'] = CarModel::find($car->car_model_id)->name;
                    $item['year'] = $car->year;
                    $item['color'] = Color::find($car->color_id);
                    $item['images'] = $this->Images($car->type,$car->id);

                    $result['statusCode'] = 200;
                    $result['message'] = 'Sucesss!';
                    $result['result'] = $item;
                }
                else{
                    $result['statusCode'] = 404;
                    $result['message'] = 'User Not Found';
                    $result['result'] = [];
                }

            }
            else{
                $result['statusCode'] = 404;
                $result['message'] = 'User Not Found';
                $result['result'] = [];
            }
        }catch (\Exception $e){
            $result['statusCode'] = 404;
            $result['message'] = 'Not Found';
            $result['result'] = [];
        }
        return $result;
    }
    public function GetSpecialCar($id){
        $car = SpecialCar::find($id);

        if ($car){
            $user = User::find($car->user_id);
            if  ($user){
                $item['id'] = $car->id;
                $item['type'] = $car->type;
                $item['user_id'] = $car->user_id;
                $item['name'] = $user->name;
                $item['phone'] = $user->phone;
                $item['info'] = $car->info;
                $item['text'] = $car->text;
                $item['images'] = $this->Images($car->type,$car->id);

                $result['statusCode'] = 200;
                $result['message'] = 'Sucesss!';
                $result['result'] = $item;
            }
            else{
                $result['statusCode'] = 404;
                $result['message'] = 'User Not Found';
                $result['result'] = [];
            }
        }
        else{
            $result['statusCode'] = 404;
            $result['message'] = 'User Not Found';
            $result['result'] = [];
        }
        return $result;
    }
    public function GetIntercityOrder($id){
        $order = IntercityOrder::find($id);
        if ($order){
            $item['id'] =$order->id;
            $item['type'] =$order->type;
            $item['passenger'] =$this->GetUser($order->passenger_id)['result'];
            $item['driver_id'] =($order->driver_id != null) ?$this->GetUser($order->driver_id)['result']:null;
            $item['from'] =$order->from;
            $item['to'] =$order->to;
            $item['price'] =$order->price;
            $item['text'] =$order->text;
            $item['date'] =$order->date;
            $item['status'] =$order->status;
            $item['step'] =$order->step;
            $offers = Offer::where('parent_type',$order->type)->where('parent_id',$order->id)->get();
            if (count($offers) != 0) {
                foreach ($offers as $offer) {
                    $temp = $this->GetUser($offer->driver_id);
                    if ($temp['statusCode'] != 404){
                        $item['offers'][] = $temp['result'];
                    }
                }
            }
            else{
                $item['offers'] = [];
            }

            $result['statusCode'] = 200;
            $result['result'] = $item;
        }
        else{
            $result['statusCode'] = 404;
        }

        return $result;
    }

    public function GetCargoOrder($id){
        $order = CargoOrder::find($id);
        if ($order){
            $item['id'] =$order->id;
            $item['type'] =$order->type;
            $item['passenger'] =$this->GetUser($order->passenger_id)['result'];
            $item['driver_id'] =($order->driver_id != null) ?$this->GetUser($order->driver_id)['result']:null;
            $item['from'] =$order->from;
            $item['to'] =$order->to;
            $item['price'] =$order->price;
            $item['text'] =$order->text;
            $item['document'] =$order->document;
            $item['bargain'] =$order->bargain;
            $item['status'] =$order->status;
            $item['step'] =$order->step;
            $offers = Offer::where('parent_type',$order->type)->where('parent_id',$order->id)->get();
            if (count($offers) != 0) {
                foreach ($offers as $offer) {
                    $temp = $this->GetUser($offer->driver_id);
                    if ($temp['statusCode'] != 404){
                        $item['offers'][] = $temp['result'];
                    }
                }
            }
            else{
                $item['offers'] = [];
            }

            $result['statusCode'] = 200;
            $result['result'] = $item;
        }
        else{
            $result['statusCode'] = 404;
        }

        return $result;
    }
    public function SpecialCars($token = null){
        if($token == null){
            $cars = SpecialCar::all();
        }
        else{
            $user = User::where('token',$token)->first();
            $cars = SpecialCar::where('city_id',$user->city_id)->get();
        }
        if (count($cars) != 0){
            foreach ($cars as $car) {
                $temp = $this->GetSpecialCar($car->id);
                if ($temp['statusCode'] != 404){
                    $item[] = $temp['result'];
                }
            }
        }
        else{
            $item = [];
        }
        $result['statusCode'] = 200;
        $result['message'] = 'Success!';
        $result['result'] = $item;
        return $result;
    }
    public function ToyCars($token=null){
        if($token == null){
            $cars = ToyCar::all();
        }
        else{
            $user = User::where('token',$token)->first();
            $cars = ToyCar::where('city_id',$user->city_id)->get();
        }




        $result['statusCode'] = 200;
        $result['message'] = 'Success!';
        foreach ($cars as $item){
            $temp = $this->GetToyCat($item->id);
            if  ($temp['statusCode'] == 200){
                $result['result'][] = $temp['result'];
            }
        }
        return $result;
    }
    public function Notifications(){
        $result['statusCode'] = 200;
        $result['message'] = 'success!';
        $result['result'] = Notification::orderBy("id","desc")->get();

        return $result;
    }

    public function Notification($id){
        $result['statusCode'] = 200;
        $result['message'] = 'success!';
        $result['result'] = Notification::Find($id);

        return $result;
    }

    public function CreateCargoCar(Request $request){
        $rules = [
            'info' => 'required',
            'text' => 'required',
            'token' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $car = new CargoCar();
                $car->info = $request['info'];
                $car->text = $request['text'];
                $car->user_id = $user->id;
                $car->save();
                if (isset($request['images'])){
                    foreach ($request->file() as $file) {
                        foreach ($file as $img) {
                            $car_img  = new Image();
                            $car_img->path = $this->uploadFile($img);
                            $car_img->parent_id = $car->id;
                            $car_img->parent_type = 'cargo_cars';
                            $car_img->save();
                            $result['statusCodeImage'] = 200;
                            $result['messageImage'] = 'Uploaded  image success!';
                        }
                    }
                }
                $result['statusCode ']= 200;
                $result['message']= 'Success!';
                $result['result']= $this->GetUser($user->id);
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function CreateToyCar(Request $request){
        $rules = [
            'car_mark_id' => 'required',
            'car_model_id' => 'required',
            'year' => 'required',
            'color_id' => 'required',
            'price' => 'required',
            'token' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $car = new ToyCar();
                $car->user_id = $user->id;
                $car->car_mark_id = $request['car_mark_id'];
                $car->car_model_id = $request['car_model_id'];
                $car->year = $request['year'];
                $car->color_id = $request['color_id'];
                $car->price = $request['price'];
                $car->save();
                if (isset($request['images'])){
                    foreach ($request->file() as $file) {
                        foreach ($file as $img) {
                            $car_img  = new Image();
                            $car_img->path = $this->uploadFile($img);
                            $car_img->parent_id = $car->id;
                            $car_img->parent_type = 'toy_cars';
                            $car_img->save();
                            $result['statusCodeImage'] = 200;
                            $result['messageImage'] = 'Uploaded  image success!';
                        }
                    }
                }
                $result['statusCode ']= 200;
                $result['message']= 'Success!';
                $result['result']= $this->GetUser($user->id);
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function CreateSpecialCar(Request $request){
        $rules = [
            'info' => 'required',
            'text' => 'required',
            'token' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $car = new SpecialCar();
                $car->user_id = $user->id;
                $car->info = $request['info'];
                $car->text = $request['text'];
                $car->save();
                if (isset($request['images'])){
                    foreach ($request->file() as $file) {
                        foreach ($file as $img) {
                            $car_img  = new Image();
                            $car_img->path = $this->uploadFile($img);
                            $car_img->parent_id = $car->id;
                            $car_img->parent_type = 'special_cars';
                            $car_img->save();
                            $result['statusCodeImage'] = 200;
                            $result['messageImage'] = 'Uploaded  image success!';
                        }
                    }
                }
                $result['statusCode ']= 200;
                $result['message']= 'Success!';
                $result['result']= $this->GetUser($user->id);
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }

    //=================================Orders================================================
    //Intercity
    public function CreateIntercityOrder(Request $request){
        $rules = [
            'token' => 'required',
            'from' => 'required',
            'to' => 'required',
            'price' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $order = new IntercityOrder();
                $order->passenger_id = $user->id;
                $order->from = $request['from'];
                $order->to = $request['to'];
                $order->price = $request['price'];
                $order->date = $request['date'];
                $order->text = $request['text'];
                $order->save();
                //Push
                $result['statusCode ']= 200;
                $result['message']= 'Success!';
                $result['result']= $order;
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function ListIntercityOrder(){
        $orders = IntercityOrder::where('step',1)->where('status',1)->orderBy('id','DESC')->get();
        if (count($orders) != 0){
            $items = [];
            foreach ($orders as  $order) {
                $item = $this->GetIntercityOrder($order->id);
                if ($item['statusCode'] != 0){
                    $items[] = $item['result'];
                }
            }
            $result['statusCode'] = 200;
            $result['result'] = $items;
        }
        else{
            $result['statusCode'] = 404;
            $result['result'] = [];
        }

        return $result;
    }
    public function EndIntercityOrder(Request $request){
        $rules = [
            'token' => 'required',
            'order_id' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $order = IntercityOrder::find($request['order_id']);
                if ($order != null){
                    //Push
                    $order->step = 3;
                    $order->save();

                    $history = new OrderHistory();
                    $history->parent_type = 'intercity_orders';
                    $history->parent_id = $order->id;
                    $history->user_id = $order->passenger_id;
                    $history->role = 1;
                    $history->save();

                    $history = new OrderHistory();
                    $history->parent_type = 'intercity_orders';
                    $history->parent_id = $order->id;
                    $history->user_id = $order->driver_id;
                    $history->role = 2;
                    $history->save();


                    $result['statusCode ']= 200;
                    $result['message']= 'Success!';
                    $result['result']= $order;
                }
                else{
                    $result['statusCode ']= 404;
                    $result['message']= 'Order not found';
                    $result['result']= [];
                }

            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function CancelIntercityOrder(Request $request){
        $rules = [
            'token' => 'required',
            'order_id' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $order = IntercityOrder::find($request['order_id']);
                if ($order != null){
                    //Push
                    $order->delete();
                    $result['statusCode ']= 200;
                    $result['message']= 'Success!';
                    $result['result']= [];
                }
                else{
                    $result['statusCode ']= 404;
                    $result['message']= 'Order not found';
                    $result['result']= [];
                }

            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function HistoryIntercityOrder(Request $request){
        $rules = [
            'token' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $histories = OrderHistory::where('parent_type','intercity_orders')
                    ->where('role',$user->role)
                    ->where('user_id',$user->id)
                    ->get();
                $orders = [];
                if (count($histories) != 0){
                    foreach ($histories as $history) {
                        $order = $this->GetIntercityOrder($history->parent_id);
                        if ($order['statusCode'] == 200){
                            $orders[] = $order['result'];
                        }
                    }
                }
                $result['statusCode ']= (count($orders) != 0) ? 200:404;
                $result['message']= 'Success or Order not found';
                $result['result']= $orders;
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function ActiveIntercityOrder(Request $request){
        $rules = [
            'token' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $orders = [];

                $db = IntercityOrder::where('driver_id',$user->id)->get();
                foreach ($db as $item) {
                    $orders[] = $this->GetIntercityOrder($item->id)['result'];
                }
                $result['statusCode '] = (count($orders) != 0) ? 200:404;
                $result['message']= 'Success!';
                $result['result']= $orders;
            }
            else{
                $result['statusCode '] = 404;
                $result['message'] = 'User not found';
                $result['result'] = [];
            }
        }
        return $result;
    }
    //Cargo
    public function CreateCargoOrder(Request $request){
        $rules = [
            'token' => 'required',
            'from' => 'required',
            'to' => 'required',
            'price' => 'required',
            'document' => 'required',
            'bargain' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $order = new CargoOrder();
                $order->passenger_id = $user->id;
                $order->from = $request['from'];
                $order->to = $request['to'];
                $order->price = $request['price'];
                $order->document = $request['document'];
                $order->bargain = $request['bargain'];
                $order->text = $request['text'];
                $order->save();
                //Push
                $result['statusCode ']= 200;
                $result['message']= 'Success!';
                $result['result']= $order;
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function ListCargoOrder(){
        $orders = CargoOrder::where('step',1)->where('status',1)->orderBy('id','DESC')->get();
        if (count($orders) != 0){
            $items = [];
            foreach ($orders as  $order) {
                $item = $this->GetCargoOrder($order->id);
                if ($item['statusCode'] != 0){
                    $items[] = $item['result'];
                }
            }
            $result['statusCode'] = 200;
            $result['result'] = $items;
        }
        else{
            $result['statusCode'] = 404;
            $result['result'] = [];
        }

        return $result;
    }
    public function EndCargoOrder(Request $request){
        $rules = [
            'token' => 'required',
            'order_id' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $order = CargoOrder::find($request['order_id']);
                if ($order != null){
                    //Push
                    $order->step = 3;
                    $order->save();
                    $history = new OrderHistory();
                    $history->parent_type = 'cargo_orders';
                    $history->parent_id = $order->id;
                    $history->user_id = $order->passenger_id;
                    $history->role = 1;
                    $history->save();

                    $history = new OrderHistory();
                    $history->parent_type = 'cargo_orders';
                    $history->parent_id = $order->id;
                    $history->user_id = $order->driver_id;
                    $history->role = 2;
                    $history->save();


                    $result['statusCode ']= 200;
                    $result['message']= 'Success!';
                    $result['result']= $order;
                }
                else{
                    $result['statusCode ']= 404;
                    $result['message']= 'Order not found';
                    $result['result']= [];
                }

            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function CancelCargoOrder(Request $request){
        $rules = [
            'token' => 'required',
            'order_id' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $order = CargoOrder::find($request['order_id']);
                if ($order != null){
                    //Push
                    $order->delete();
                    $result['statusCode ']= 200;
                    $result['message']= 'Success!';
                    $result['result']= [];
                }
                else{
                    $result['statusCode ']= 404;
                    $result['message']= 'Order not found';
                    $result['result']= [];
                }

            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function HistoryCargoOrder(Request $request){
        $rules = [
            'token' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $histories = OrderHistory::where('parent_type','cargo_orders')
                    ->where('role',$user->role)
                    ->where('user_id',$user->id)
                    ->get();
                $orders = [];
                if (count($histories) != 0){
                    foreach ($histories as $history) {
                        $order = $this->GetCargoOrder($history->parent_id);
                        if ($order['statusCode'] == 200){
                            $orders[] = $order['result'];
                        }
                    }
                }
                $result['statusCode ']= (count($orders) != 0) ? 200:404;
                $result['message']= 'Success!';
                $result['result']= $orders;
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function ActiveCargoOrder(Request $request){
        $rules = [
            'token' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $orders = [];

                $db = CargoOrder::where('driver_id',$user->id)->get();
                foreach ($db as $item) {
                    $temp = $this->GetCargoOrder($item->id);
                    if ($temp['statusCode'] == 200){
                        $orders[] = $temp['result'];
                    }
                }
                $result['statusCode '] = (count($orders) != 0) ? 200:404;
                $result['message'] = 'Success!';
                $result['result'] = $orders;
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }


    //Offer
    public function OfferCreate(Request $request){
        $rules = [
            'token' => 'required',
            'parent_id' => 'required',
            'parent_type' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $isset = Offer::where('parent_type',$request['parent_type'])
                    ->where('parent_id',$request['parent_id'])
                    ->where('driver_id',$user->id)
                    ->first();
                if ($isset == null){
                    if ($request['parent_type'] == 'intercity_orders'){
                        $offer = new Offer();
                        $offer->parent_type = $request['parent_type'];
                        $offer->parent_id = $request['parent_id'];
                        $offer->driver_id = $user->id;
                        $offer->save();
                        //Push
                        $result['statusCode ']= 200;
                        $result['message']= 'Success!';
                        $result['result']= $offer;
                    }
                    else if ($request['parent_type'] == 'cargo_orders'){

                        $offer = new Offer();
                        $offer->parent_type = $request['parent_type'];
                        $offer->parent_id = $request['parent_id'];
                        $offer->driver_id = $user->id;
                        $offer->save();
                        //Push
                        $result['statusCode ']= 200;
                        $result['message']= 'Success!';
                        $result['result']= $offer;
                    }
                    else{
                        $result['statusCode ']= 404;
                        $result['message']= 'type not found';
                        $result['result']= [];
                    }
                }
                else{
                    $result['statusCode ']= 401;
                    $result['message']= 'offer isset!';
                    $result['result']= [];
                }
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function OfferAccept(Request $request){
        $rules = [
            'token' => 'required',
            'driver_id' => 'required',
            'parent_id' => 'required',
            'parent_type' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                if ($request['parent_type'] == 'intercity_orders'){
                    $order = IntercityOrder::where('id',$request['parent_id'])->first();
                    $order->driver_id = $request['driver_id'];
                    $order->step = 2;
                    $order->status = 0;
                    $order->save();
                    //Push
                    $result['statusCode ']= 200;
                    $result['message']= 'Success!';
                    $result['result']= $order;
                }
                else if ($request['parent_type'] == 'cargo_orders'){
                    $order = CargoOrder::where('id',$request['parent_id'])->first();
                    $order->driver_id = $request['driver_id'];
                    $order->step = 2;
                    $order->status = 0;
                    $order->save();
                    //Push
                    $result['statusCode ']= 200;
                    $result['message']= 'Success!';
                    $result['result']= $order;
                }
                else{
                    $result['statusCode ']= 401;
                    $result['message']= 'No type';
                    $result['result']= [];
                }
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }


    //Feedback
    public function FeedbackCreate(Request $request){
        $rules = [
            'token' => 'required',
            'parent_id' => 'required',
            'parent_type' => 'required',
            'driver_id' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $feedback = new Feedback();
                $feedback->passenger_id  = $user->id;
                $feedback->driver_id = $request['driver_id'];
                $feedback->parent_type = $request['parent_type'];
                $feedback->parent_id = $request['parent_id'];
                $feedback->ball = $request['rating'];
                $feedback->text = $request['text'];
                $feedback->save();

                $user = User::find($request['driver_id']);
                $user->rating = $request['rating'];

                $user->save();

                //Push
                $result['statusCode ']= 200;
                $result['message']= 'Success!';
                $result['result']= $feedback;
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    //Generators
    public function cities(){
        $result['statusCode'] = 200;
        $result['message'] = 'success';
        $result['result'] = City::orderBy('name')->get();
        return $result;
    }
    public function Colors(){
        $result['statusCode'] = 200;
        $result['message'] = 'success';
        $result['result'] = Color::all();
        return $result;
    }
    public function CarMarks(){
        $result['statusCode'] = 200;
        $result['message'] = 'success';
        $result['result'] = CarMark::orderBy('name')->get();
        return $result;
    }
    public function CarModel($id){
        $models = CarModel::where('car_mark_id',$id)->orderBy('name')->get();
        if  (count($models) != 0){
            $result['statusCode'] = 200;
            $result['message'] = 'success';
            $result['result'] =$models;
        }
        else{
            $result['statusCode'] = 404;
            $result['message'] = 'success';
            $result['result'] = [];
        }

        return $result;
    }

    //Position friend
    public function QueryFriend(Request $request){
        $rules = [
            'token' => 'required',
            'friend_phone' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $friend = User::where('phone',$request['friend_phone'])->first();
                if ($friend != null){
                    $friends = PositionFriend::where('user_id',$user->id)
                        ->where('friend_user_id',$friend->id)
                        ->first();
                    if ($friends == null){
                        $push = self::Push_QueryFriend($user->id,$friend->token);

                        $result['statusCode ']= 200;
                        $result['message']= 'Push send';
                        $result['token']= $friend->token;
                        $result['result']= [];
                    }else{
                        $result['statusCode ']= 401;
                        $result['message']= 'Push send';
                        $result['result']= [];
                    }

                }else{
                    $result['statusCode ']= 404;
                    $result['message']= 'User not found';
                    $result['result']= [];
                }
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function AcceptFriend(Request $request){
        $rules = [
            'token' => 'required',
            'user_id' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $friends = PositionFriend::where('user_id',$request['user_id'])->where('friend_user_id',$user->id)->first();
                if ($friends == null){
                    $position = new PositionFriend();
                    $position->user_id = $request['user_id'];
                    $position->friend_user_id = $user->id;
                    $position->save();

                    $position = new PositionFriend();
                    $position->user_id =$user->id;
                    $position->friend_user_id = $request['user_id'];
                    $position->save();

                    $result['statusCode ']= 200;
                    $result['message']= 'Success';
                    $result['result']= $position;
                }
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function Friends(Request $request){
        $rules = [
            'token' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $friends = PositionFriend::where('user_id',$user->id)->get();
                if (count($friends) != 0){
                    $arr = [];
                    foreach ($friends as $friend) {
                        $temp = $this->GetUser($friend->friend_user_id);
                        if   ($temp['statusCode'] == 200){
                            $arr[] = $temp['result'];
                        }
                    }
                    $result['statusCode ']= 200;
                    $result['message']= 'Success';
                    $result['result']= $arr;
                }
                else{
                    $result['statusCode ']= 404;
                    $result['message']= 'friend not found';
                    $result['result']= [];
                }
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function DeleteFriend(Request $request){
        $rules = [
            'token' => 'required',
            'user_id' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $friends = PositionFriend::where('user_id',$request['user_id'])->where('friend_user_id',$user->id)->first();
                if ($friends != null){
                    $friends->delete();
                }
                $friends = PositionFriend::where('user_id',$user->id)->where('friend_user_id',$request['user_id'])->first();
                if ($friends != null){
                    $friends->delete();
                }

                $result['statusCode ']= 200;
                $result['message']= 'Success';
                $result['result']= [];
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }

    protected static $key = 'key=AAAAs-aGZ7E:APA91bEKxqW0mT9bj2HxXt9YBgVz7xt_Ee-dJmYtbnm6w9c2nj3skVDs_rjnwPG8b5nyxIa_RD7G_vYle8uTtQhKA1hyJXqBJTEWdTHOygyT6shwxe7qxaG0VP1TQ9I2HgCyJh-ifMaM';

    public function Push_QueryFriend($user_id,$token){
        $client = new Client;
        $user = User::find($user_id);
        $client->request('POST','https://fcm.googleapis.com/fcm/send',[
                'headers' => [
                    'Authorization' => self::$key,
                    'Content-Type'     => 'application/json',
                ],
                'json' =>[
                    "to" => "/topics/" +$token+"_a",
                    "data" => [
                        'user_id'=>$user_id,
                        'name'=>$user->name,
                        'phone'=>$user->phone,
                        "type"=>"friend"
                    ],
                ]]
        );
        $client->request('POST','https://fcm.googleapis.com/fcm/send',[
                'headers' => [
                    'Authorization' => self::$key,
                    'Content-Type'     => 'application/json',
                ],
                'json' =>[
                    "to" => "/topics/$token",
                    "notification" => [
                        "body" => $user->name,
                        'user_id'=>$user_id,
                        'name'=>$user->name,
                        'phone'=>$user->phone,
                        "sound" => "default"
                    ]
                ]]
        );
    }



//   ==================================Socket API==========================================================
    public function Geo(Request $request){
        $rules = [
            'token' => 'required',
            'lon' => 'required',
            'lat' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else{
            $user = User::where('token',$request['token'])->first();
            if ($user != null){
                $user->lat = $request['lat'];
                $user->lon = $request['lon'];
                $user->save();

                $result['statusCode ']= 200;
                $result['message']= 'success!';
                $result['result']= $user;
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User Not found';
                $result['result']= [];
            }

        }
        return $result;
    }
    public function Geopositions(Request $request){
        $users = User::where('role',2)->where('online',1)->get();
        $items = [];
        if (count($users) != 0){
            foreach ($users as $user) {
                $item = $this->GetUser($user->id);
                if ($item['statusCode'] == 200){
                    $items[] = $item['result'];
                }
            }
            $result['statusCode ']= 200;
            $result['message']= 'success!';
            $result['result']= $items;
        }
        else{
            $result['statusCode']= 404;
            $result['message']= 'success!';
            $result['message']= [];
        }

        return $result;
    }
    public function CreateTaxiOrder(Request $request){
        $rules = [
            'token' => 'required',
            'from' => 'required',
            'from_lat' => 'required',
            'from_lon' => 'required',
            'to' => 'required',
            'to_lat' => 'required',
            'to_lon' => 'required',
            'price' => 'required',
            'count_passenger' => 'required',
            'get_passenger' => 'required',
            'bonus' => 'required',
            'woman_driver' => 'required',
            'invalid' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                if ($request['bonus'] == 1){
                    $orderBonus = ($request['price'] * 25 ) / 100;
                    if	($orderBonus > $user->balanse){
                        $result['statusCode ']= 202;
                        $result['message'][0]= 'Нехватка баланска  оплатит бонуса!';
                        $result['message'][1]= "ваш balanse $user->balanse";
                        $result['message'][2]= "Бонус в % $orderBonus";
                        $result['result']= [];
                    }
                    else{
                        $order = new TaxiOrder();
                        $order->passenger_id = $user->id;
                        $order->city_id = $user->city_id;
                        $order->from = $request['from'];
                        $order->from_lat = $request['from_lat'];
                        $order->from_lon = $request['from_lon'];
                        $order->to = $request['to'];
                        $order->to_lat = $request['to_lat'];
                        $order->to_lon = $request['to_lon'];
                        $order->price = $request['price'];
                        $order->count_passenger = $request['count_passenger'];
                        $order->get_passenger = $request['get_passenger'];
                        $order->bonus = $request['bonus'];
                        $order->woman_driver = $request['woman_driver'];
                        $order->invalid = $request['invalid'];
                        $order->description = $request['description'];
                        $order->save();
                        $result['statusCode ']= 200;
                        $result['message']= 'Success!';
                        $result['result']= $this->GetTaxiOrder($order->id)['result'];
                    }
                }
                else{
                    $order = new TaxiOrder();
                    $order->passenger_id = $user->id;
                    $order->city_id = $user->city_id;
                    $order->from = $request['from'];
                    $order->from_lat = $request['from_lat'];
                    $order->from_lon = $request['from_lon'];
                    $order->to = $request['to'];
                    $order->to_lat = $request['to_lat'];
                    $order->to_lon = $request['to_lon'];
                    $order->price = $request['price'];
                    $order->count_passenger = $request['count_passenger'];
                    $order->get_passenger = $request['get_passenger'];
                    $order->bonus = $request['bonus'];
                    $order->woman_driver = $request['woman_driver'];
                    $order->invalid = $request['invalid'];
                    $order->description = $request['description'];
                    $order->save();
                    $result['statusCode ']= 200;
                    $result['message']= 'Success!';
                    $result['result']= $this->GetTaxiOrder($order->id)['result'];
                }
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function CancelTaxiOrder(Request $request){
        $rules = [
            'token' => 'required',
            'order_id' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $order = TaxiOrder::find($request['order_id']);
                $order->delete();
                //Push
                $result['statusCode ']= 200;
                $result['message']= 'Success!';
                $result['result']= $this->GetTaxiOrder($order->id)['result'];
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function RemoveTaxiOrder(Request $request){
        $rules = [
            'order_id' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $order = TaxiOrder::find($request['order_id']);

            if  ($order != null){
                $order->step = 0;
                $order->save();

                return  $this->GetTaxiOrder($order->id);
            }
            else{
                $result['statusCode ']= 404;
            }

        }
        return $result;
    }
    public function AcceptTaxiOrder(Request $request){
        $rules = [
            'token' => 'required',
            'order_id' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $order = TaxiOrder::find($request['order_id']);
                if  ($order){
                    $order->driver_id = $user->id;
                    $order->step = 2;
                    $order->save();
                    //Push
                    $result= $this->GetTaxiOrder($order->id);
                }
                else{
                    $result['statusCode ']= 404;
                    $result['message']= 'Order not found';
                    $result['result']= [];
                }


            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function TradeAcceptTaxiOrder(Request $request){
        $rules = [
            'driver_id' => 'required',
            'order_id' => 'required',
            'price' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $order = TaxiOrder::find($request['order_id']);
            if  ($order){
                $order->driver_id = $request['driver_id'];
                $order->price= $request['price'];
                $order->step = 2;
                $order->save();

                //Push
                $result= $this->GetTaxiOrder($order->id);
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'Order not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function ArrivedTaxiOrder(Request $request){
        $rules = [
            'token' => 'required',//Driver
            'order_id' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $order = TaxiOrder::find($request['order_id']);
                $order->step = 3;
                $order->save();
                //Push
                $result['statusCode ']= 200;
                $result['message']= 'Success!';
                $result['result']= $this->GetTaxiOrder($order->id)['result'];
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function OutTaxiOrder(Request $request){
        $rules = [
            'token' => 'required',//Passenger
            'order_id' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $order = TaxiOrder::find($request['order_id']);
                $order->step = 4;
                $order->save();
                //Push
                $result['statusCode ']= 200;
                $result['message']= 'Success!';
                $result['result']= $this->GetTaxiOrder($order->id)['result'];
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function EndTaxiOrder(Request $request){
        $rules = [
            'token' => 'required',//Driver
            'order_id' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user = User::where('token', $request['token'])->first();

            if ($user){
                $order = TaxiOrder::find($request['order_id']);
                if ($order){
                    $order->step = 5;
                    $order->status = 0;
                    $order->save();



                    $history = new OrderHistory();
                    $history->parent_type = 'taxi_orders';
                    $history->parent_id = $order->id;
                    $history->user_id = $order->passenger_id;
                    $history->role = 1;
                    $history->save();

                    $history = new OrderHistory();
                    $history->parent_type = 'taxi_orders';
                    $history->parent_id = $order->id;
                    $history->user_id = $order->driver_id;
                    $history->role = 2;
                    $history->save();

                    if ($order->bonus == 1){
                        $driver = User::find($order->passenger_id);
                        $driver->balanse -= ($order->price * 10 ) / 100;
                        $driver->save();

                        $passenger = User::find($order->driver_id);
                        $passenger->balanse += ($order->price * 10 ) / 100;
                        $passenger->save();
                    }
                    //Push
                    $result['statusCode ']= 200;
                    $result['message']= 'Success!';
                    $result['result']= $this->GetTaxiOrder($order->id)['result'];
                }
                else{
                    $result['statusCode ']= 404;
                    $result['message']= 'Order not found';
                    $result['result']= [];
                }

            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function HistoryTaxiOrder(Request $request){
        $rules = [
            'token' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                $histories = OrderHistory::where('parent_type','taxi_orders')
                    ->where('role',$user->role)
                    ->where('user_id',$user->id)
                    ->get();
                $orders = [];
                if (count($histories) != 0){
                    foreach ($histories as $history) {
                        $order = $this->GetTaxiOrder($history->parent_id);
                        if ($order['statusCode'] == 200){
                            $orders[] = $order['result'];
                        }
                    }
                }
                $result['statusCode ']= (count($orders) != 0) ? 200:404;
                $result['message']= 'Success!';
                $result['result']= $orders;
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }
    public function ListTaxiOrder(Request $request){
        $items = [];
        $orders = TaxiOrder::where('status',1)
            ->where('step',1)
            ->where('city_id',$request['city_id'])
            ->orderBy('id','DESC')
            ->get();
        if (count($orders) != 0){
            foreach ($orders as $item) {
                $order = $this->GetTaxiOrder($item->id);
                if ($order['statusCode'] == 200){
                    $items[] = $order['result'];
                }
            }
        }
        $result['statusCode ']= (count($items) != 0) ? 200:404;
        $result['message']= 'Success!';
        $result['result']= $items;

        return $result;
    }
    public function HistoryAddressTaxiOrder(Request $request){
        $rules = [
            'token' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user){
                if ($user->role == 1){
                    $orders = TaxiOrder::where('passenger_id',$user->id)
                        ->select('taxi_orders.from','taxi_orders.from_lat','taxi_orders.from_lon')
                        ->orderBy('id','desc')
                        ->limit(10)
                        ->get();
                }else{
                    $orders = TaxiOrder::where('driver_id',$user->id)
                        ->select('taxi_orders.from','taxi_orders.from_lat','taxi_orders.from_lon')
                        ->orderBy('id','desc')
                        ->limit(10)
                        ->get();
                }
                $result['statusCode ']= (count($orders) != 0) ? 200:404;
                $result['message']= 'Success!';
                $result['result']= $orders;
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User not found';
                $result['result']= [];
            }
        }
        return $result;
    }

    public function Online(Request $request){
        $rules = [
            'token' => 'required',
            'socket_id' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else{
            $user = User::where('token',$request['token'])->first();
            if ($user != null){
                $user->online = 1;
                $user->socket_id = $request['socket_id'];
                $user->save();

                $result['statusCode ']= 200;
                $result['message']= 'success!';
                $result['result']= $user;
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User Not found';
                $result['result']= [];
            }

        }
        return $result;
    }
    public function Offline(Request $request){
        $rules = [
            'socket_id' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else{
            $user = User::where('socket_id',$request['socket_id'])->first();
            if ($user != null){
                $user->online = 0;
                $user->save();

                $result['statusCode ']= 200;
                $result['message']= 'success!';
                $result['result']= $user;
            }
            else{
                $result['statusCode ']= 404;
                $result['message']= 'User Not found';
                $result['result']= [];
            }

        }
        return $result;
    }

//    public function Access(Request $request){
//        $rules = [
//            'token' => 'required',
//        ];
//        $validator = $this->validator($request->all(),$rules);
//        if($validator->fails()) {
//            $result['statusCode ']= 400;
//            $result['message']= $validator->errors();
//            $result['result']= [];
//        }else {
//            $user = User::where('token', $request['token'])->first();
//            if ($user != null) {
//                if  ($user->access_date){
//                    if (Carbon::now()->gte(Carbon::parse($user->access_date))){
//                        if ($user->balanse >= 700){
//                            $user->balanse -= 700;
//                            $user->access_date = Carbon::now()->addHour(24);
//                            $user->save();
//
//                            $result['statusCode ']= 200;
//                            $result['message']= 'Success Balanse sub';
//                            $result['result']= $user;
//                        }
//                        else{
//                            $result['statusCode ']= 401;
//                            $result['message']= '$user->balanse >= 20';
//                            $result['result']= $user;
//                        }
//                    }
//                    else{
//                        $result['statusCode ']= 200;
//                        $result['message']= 'success';
//                        $result['result']= $user;
//                    }
//                }else{
//                    if ($user->balanse >= 700){
//                        $user->balanse -= 700;
//                        $user->access_date = Carbon::now()->addHour(24);
//                        $user->save();
//
//                        $result['statusCode ']= 200;
//                        $result['message']= 'Success Balanse sub';
//                        $result['result']= $user;
//                    }  else{
//                        $result['statusCode ']= 401;
//                        $result['message']= '$user->balanse >= 900';
//                        $result['result']= $user;
//                    }
//                }
//            }else{
//                $result['statusCode ']= 404;
//                $result['message']= 'success';
//                $result['result']= $user;
//            }
//        }
//
//        return $result;
//    }


    public function Access(Request $request){
        $rules = [
            'token' => 'required',
            'driver_type'   =>  'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        } else {
            $user = User::where('token', $request['token'])->first();
            $city = City::where('id', $user['city_id'])->first();
            if ($user != null) {
                if ($user->access_date){
                    if (Carbon::now()->gte(Carbon::parse($user->access_date))){

                        if (($request['driver_type'] == 1 && $user->balanse >= $city['price_first']) || ($request['driver_type'] == 2 && $user->balanse >= $city['price_second'])
                            || ($request['driver_type'] == 3 && $user->balanse >= $city['price_third'])){;
                            switch ($request['driver_type']) {
                                case "1":
                                    $user->balanse -= $city['price_first'];
                                    $user->driver_type = 1;
                                    $user->access_date = Carbon::now()->addHour(4);
                                    $user->save();
                                    break;
                                case "2":
                                    $user->balanse -= $city['price_second'];
                                    $user->driver_type = 2;
                                    $user->access_date = Carbon::now()->addHour(8);
                                    $user->save();
                                    break;
                                case "3":
                                    $user->balanse -= $city['price_third'];
                                    $user->driver_type = 3;
                                    $user->access_date = Carbon::now()->addHour(12);
                                    $user->save();
                                    break;
                            }

                            $result['statusCode ']= 200;
                            $result['message']= 'Success Balanse sub';
                            $result['result']= $user;

                        } else {
                            $result['statusCode ']= 401;
                            $result['message']= 'Недостаточно средств!';
                            $result['result']= $user;
                        }
                    } else {
                        $result['statusCode ']= 200;
                        $result['message']= 'Пока не нужно обновлять';
                        $result['result']= $user;
                    }
                }else{
                    if (($request['driver_type'] == 1 && $user->balanse >= $city['price_first']) || ($request['driver_type'] == 2 && $user->balanse >= $city['price_second'])
                        || ($request['driver_type'] == 3 && $user->balanse >= $city['price_third'])){
                        switch ($request['driver_type']) {
                            case "1":
                                $user->balanse -= $city['price_first'];
                                $user->driver_type = 1;
                                $user->access_date = Carbon::now()->addHour(4);
                                $user->save();
                                break;
                            case "2":
                                $user->balanse -= $city['price_second'];
                                $user->driver_type = 2;
                                $user->access_date = Carbon::now()->addHour(8);
                                $user->save();
                                break;
                            case "3":
                                $user->balanse -= $city['price_third'];
                                $user->driver_type = 3;
                                $user->access_date = Carbon::now()->addHour(12);
                                $user->save();
                                break;
                        }

                        $result['statusCode ']= 200;
                        $result['message']= 'Success Balanse sub';
                        $result['result']= $user;
                    } else{
                        $result['statusCode ']= 401;
                        $result['message']= '$user->balanse >= 900';
                        $result['result']= $user;
                    }
                }
            }else{
                $result['statusCode ']= 404;
                $result['message']= 'success';
                $result['result']= $user;
            }
        }

        return $result;
    }


    public function Check(Request $request){
        $rules = [
            'token' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user != null) {
                if ($user->access_date != null){
                    if (Carbon::now()->gte(Carbon::parse($user->access_date))){
                        $result['statusCode '] = 401;
                        $result['message'] = 'access_date expired';
                        $result['result'] = $user;
                    }
                    else{
                        $result['statusCode '] = 200;
                        $result['message'] = 'success 1';
                        $result['result'] = $user;
                    }
                }
                else{
                    $result['statusCode '] = 401;
                    $result['message'] = 'access_date expired';
                    $result['result'] = $user;
                }
            }
            else{
                $result['statusCode '] = 404;
                $result['message'] = 'user not found';
                $result['result'] = $user;
            }
        }

        return $result;
    }
    public function SendMe(Request $request){
        $rules = [
            'token' => 'required',
            'text' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }else {
            $user = User::where('token', $request['token'])->first();
            if ($user) {
                $item = new AdminFeedback();
                $item->user_id = $user->id;
                $item->text = $request['text'];
                $item->save();
                if (isset($request['images'])){
                    foreach ($request['images'] as $img) {
                        $image  = new Image();
                        $image->path = $this->uploadFile($img);
                        $image->parent_id = $item->id;
                        $image->parent_type = 'admin_feedback';
                        $image->save();
                    }
                }
                $result['statusCode '] = 200;
                $result['message'] = 'success';
                $result['result'] = $item;

            }
            else{
                $result['statusCode '] = 404;
                $result['message'] = 'user not ';
                $result['result'] = [];
            }
        }

        return $result;
    }


    public function City(Request $request){
        foreach ($this->parse($request['city']) as $item) {
            $city =  new City();

            $city->name = $item;
            $city->save();
        }
        dd(1);
    }


//    New API

    public function OrderCreate(Request $request){
        $rules = [
            'token' => 'required',//Passenger
            'type' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user  = User::where('token',$request['token'])->first();
            if ($user){
                $order = new Order();
                $order->type = $request['type'];
                $order->price = $request['price'];
                $order->from = $request['from'];
                $order->to = $request['to'];
                $order->description = $request['description'];
                $order->user_id = $user->id;
                $order->out_date = $request['out_date'];
                $order->save();

                if  ($request['images']){
                    foreach ($request['images'] as $image){
                        $img = new Image();
                        $img->parent_type = $request['type'];
                        $img->parent_id = $order->id;
                        $img->path = $this->uploadFile($image);
                        $img->save();
                    }
                }

                $result['statusCode ']  = 200;
                $result['message'] =  'success!';
                $result['result'] =  [];
            }
            else{
                $result['statusCode ']  = 404;
                $result['message'] =  'user not found';
                $result['result'] =  [];
            }
        }

        return response()->json($result,$result['statusCode ']);
    }
    public function OrderEdit(Request $request){
        $rules = [
            'token' => 'required',//Passenger
            'order_id' => 'required',
            'price' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user  = User::where('token',$request['token'])->first();
            if ($user){
                $order = Order::find($request['order_id']);
                if ($order){
                    $order->price = $request['price'];
                    $order->from = $request['from'];
                    $order->to = $request['to'];
                    $order->description = $request['description'];
                    $order->out_date = $request['out_date'];
                    $order->save();

                    if (isset($request['images'])){
                        $images = Image::where('parent_type',$order->id)->where('parent_id',$order->id)->get();
                        foreach ($images as $image) {
                            $this->deleteFile($image->path);
                            $image->delete();
                        }
                        foreach ($request['images'] as $image){
                            $img = new Image();
                            $img->parent_type =$order->type;
                            $img->parent_id = $order->id;
                            $img->path = $this->uploadFile($image);
                            $img->save();
                        }
                    }

                    $result['statusCode ']  = 200;
                    $result['message'] =  'success!';
                    $result['result'] =  [];
                }
                else{
                    $result['statusCode ']  = 404;
                    $result['message'] =  'order not found';
                    $result['result'] =  [];
                }

            }
            else{
                $result['statusCode ']  = 404;
                $result['message'] =  'user not found';
                $result['result'] =  [];
            }
        }

        return response()->json($result,$result['statusCode ']);
    }
    public function OrderRemove(Request $request){
        $rules = [
            'token' => 'required',//Passenger
            'order_id' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user  = User::where('token',$request['token'])->first();
            if ($user){
                $order = Order::find($request['order_id']);
                if ($order){
                    $order->status = 0;
                    $order->save();

                    $result['statusCode ']  = 200;
                    $result['message'] =  'success!';
                    $result['result'] =  [];
                }
                else{
                    $result['statusCode ']  = 404;
                    $result['message'] =  'order not found';
                    $result['result'] =  [];
                }

            }
            else{
                $result['statusCode ']  = 404;
                $result['message'] =  'user not found';
                $result['result'] =  [];
            }
        }

        return response()->json($result,$result['statusCode ']);
    }
    public function OrderList(Request $request){
        /*
         * SELECT orders.*, IF (orders.id = order_favorites.order_id,'true','false') FROM orders
LEFT JOIN order_favorites ON orders.id = order_favorites.order_id
         */
        $rules = [
            'type' => 'required',
            'page' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            if ($request['type'] == 'intercity_orders'){

                $count = DB::table('orders')
                    ->join('users','users.id','=','orders.user_id')
                    ->where('users.city_id','=',$request['city_id'])
                    ->where('orders.type','=',$request['type'])
                    ->where('orders.status',1)
                    ->where('orders.removed',0)
                    ->where('orders.from','like',"%$request->from%")
                    ->where('orders.to','like',"%$request->to%")
                    ->count();
                $limit = 20;
                $offset = $limit * $request['page'];
                $pages = (int)ceil($count/$limit) - 1;

                $ordersDB = DB::table('orders')
                    ->join('users','users.id','=','orders.user_id')
                    ->where('orders.type','=',$request['type'])
                    ->where('orders.status',1)
                    ->where('orders.removed',0)
                    ->where('orders.from','like',"%$request->from%")
                    ->where('orders.to','like',"%$request->to%")

                    ->limit($limit)
                    ->offset($offset)
                    ->select('orders.*','users.phone')
                    ->orderBy('id','desc')
                    ->get();

            }
            else if (isset($request['city_id'])){
                $count = DB::table('orders')
                    ->join('users','users.id','=','orders.user_id')
                    ->where('users.city_id','=',$request['city_id'])
                    ->where('orders.type','=',$request['type'])
                    ->where('orders.status',1)
                    ->where('orders.removed',0)
                    ->count();
                $limit = 20;
                $offset = $limit * $request['page'];
                $pages = (int)ceil($count/$limit) - 1;


                $ordersDB = DB::table('orders')
                    ->join('users','users.id','=','orders.user_id')
                    ->where('users.city_id','=',$request['city_id'])
                    ->where('orders.type','=',$request['type'])
                    ->where('orders.status',1)
                    ->where('orders.removed',0)
                    ->limit($limit)
                    ->offset($offset)
                    ->select('orders.*','users.phone')
                    ->orderBy('id','desc')
                    ->get();

            }
            else{
                $count = DB::table('orders')
                    ->where('orders.type',$request['type'])
                    ->where('orders.status',1)
                    ->where('orders.removed',0)
                    ->count();
                $limit = 20;
                $offset = $limit * $request['page'];
                $pages = (int)ceil($count/$limit) - 1;

                $ordersDB = DB::table('orders')
                    ->join('users','users.id','=','orders.user_id')
                    ->where('orders.type',$request['type'])
                    ->where('orders.status',1)
                    ->where('orders.removed',0)
                    ->limit($limit)
                    ->offset($offset)
                    ->select('orders.*','users.phone')
                    ->orderBy('id','desc')
                    ->get();
            }

            $orders = [];
            foreach ($ordersDB as $order) {
                $temp['id'] = $order->id;
                $temp['user'] = User::find($order->user_id);
                $temp['user_id'] = $order->user_id;
                $temp['type'] = $order->type;
                $temp['from'] = $order->from;
                $temp['to'] = $order->to;
                $temp['price'] = $order->price;
                $temp['description'] = $order->description;
                $temp['status'] = $order->status;
                $temp['out_date'] = $order->out_date;
                $temp['created_at'] = Carbon::parse($order->created_at)->format('d.m.Y; h:i');
                $temp['images'] = $this->Images($order->type,$order->id);
                $orders[] = $temp;
            }
            if (count($orders) != 0){

                $result['statusCode '] = 200;
                $result['message'] = "success";

                $result['result']['count_pages'] = $pages;
                $result['result']['count_data'] = $count;
                $result['result']['offset'] = $offset;
                $result['result']['limit'] = $limit;
                $result['result']['current_page'] = (int)$request['page'];

                $result['result']['orders'] = $orders;
            }
            else{
                $result['statusCode ']  = 404;
                $result['message'] =  'order not found';
                $result['result'] =  [];
            }

        }

        return response()->json($result,$result['statusCode ']);
    }
    public function OrderMy(Request $request){
        $rules = [
            'type' => 'required',
            'token' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user = User::where('token',$request['token'])->first();
            if  ($user){
                $ordersDB = Order::where('user_id',$user->id)->where('type',$request['type'])->where('status',1)->orderBy('id','desc')->get();
                $orders = [];
                foreach ($ordersDB as $order) {
                    $temp['id'] = $order->id;
                    $temp['user_id'] = User::find($order->user_id);
                    $temp['type'] = $order->type;
                    $temp['from'] = $order->from;
                    $temp['to'] = $order->to;
                    $temp['price'] = $order->price;
                    $temp['description'] = $order->description;
                    $temp['status'] = $order->status;
                    $temp['created_at'] = Carbon::parse($order->created_at)->format('d.m.Y; h:i');
                    $temp['images'] = $this->Images($order->type,$order->id);

                    $orders[] = $temp;
                }
                if (count($orders) != 0){
                    $result['statusCode ']  = 200;
                    $result['message'] =  'success';
                    $result['result'] = $orders;
                }
                else{
                    $result['statusCode ']  = 404;
                    $result['message'] =  'order not found';
                    $result['result'] =  [];
                }
            }
            else{
                $result['statusCode ']  = 404;
                $result['message'] =  'User not found';
                $result['result'] =  [];
            }
        }

        return response()->json($result,$result['statusCode ']);
    }

    public function AutoCreate(Request $request){
        $rules = [
            'token' => 'required',//Driver
            'type' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user  = User::where('token',$request['token'])->first();
            if ($user){
                $order = new Auto();
                $order->type = $request['type'];
                $order->from = $request['from'];
                $order->to = $request['to'];
                $order->description = $request['description'];
                $order->price = $request['price'];
                $order->user_id = $user->id;
                $order->save();


                if  (count($request['images']) != 0){
                    foreach ($request['images'] as $image){
                        $img = new Image();
                        $img->parent_type = $request['type'];
                        $img->parent_id = $order->id;
                        $img->path = $this->uploadFile($image);
                        $img->save();
                    }
                }

                $result['statusCode ']  = 200;
                $result['message'] =  'success!';
                $result['result'] =  [];
            }
            else{
                $result['statusCode ']  = 404;
                $result['message'] =  'user not found';
                $result['result'] =  [];
            }
        }

        return response()->json($result,$result['statusCode ']);
    }
    public function AutoEdit(Request $request){
        $rules = [
            'token' => 'required',//Passenger
            'auto_id' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user  = User::where('token',$request['token'])->first();
            if ($user){
                $order = Auto::find($request['auto_id']);
                if ($order){
                    $order->from = $request['from'];
                    $order->to = $request['to'];
                    $order->description = $request['description'];
                    $order->save();


                    $result['statusCode ']  = 200;
                    $result['message'] =  'success!';
                    $result['result'] =  [];
                }
                else{
                    $result['statusCode ']  = 404;
                    $result['message'] =  'auto not found';
                    $result['result'] =  [];
                }

            }
            else{
                $result['statusCode ']  = 404;
                $result['message'] =  'user not found';
                $result['result'] =  [];
            }
        }

        return response()->json($result,$result['statusCode ']);
    }
    public function AutoRemove(Request $request){
        $rules = [
            'token' => 'required',//Passenger
            'auto_id' => 'required',
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $user  = User::where('token',$request['token'])->first();
            if ($user){
                $order = Auto::find($request['auto_id']);
                if ($order){
                    $order->removed = 1;
                    $order->save();

                    $result['statusCode ']  = 200;
                    $result['message'] =  'success!';
                    $result['result'] =  [];
                }
                else{
                    $result['statusCode ']  = 404;
                    $result['message'] =  'auto not found';
                    $result['result'] =  [];
                }

            }
            else{
                $result['statusCode ']  = 404;
                $result['message'] =  'user not found';
                $result['result'] =  [];
            }
        }

        return response()->json($result,$result['statusCode ']);
    }
    public function AutoList2(Request $request){
        $rules = [
            'type' => 'required',
            'page' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            if (isset($request['city_id'])){
                $count = DB::table('autos')
                    ->join('users','users.id','=','autos.user_id')
                    ->where('users.city_id','=',$request['city_id'])
                    ->where('autos.type','=',$request['type'])
                    ->where('autos.status',1)
                    ->count();
                $limit = 20;
                $offset = $limit * $request['page'];
                $pages = (int)ceil($count/$limit) - 1;


                $ordersDB = DB::table('autos')
                    ->join('users','users.id','=','autos.user_id')
                    ->where('users.city_id','=',$request['city_id'])
                    ->where('autos.type','=',$request['type'])
                    ->where('autos.status',1)
                    ->limit($limit)
                    ->offset($offset)
                    ->select('autos.*','users.phone')
                    ->orderBy('id','desc')
                    ->get();
            }
            else{
                $count = DB::table('autos')
                    ->where('autos.type',$request['type'])
                    ->where('status',1)
                    ->where('removed',0)
                    ->count();
                $limit = 20;
                $offset = $limit * $request['page'];
                $pages = (int)ceil($count/$limit) - 1;

                $ordersDB = DB::table('autos')
                    ->join('users','users.id','=','autos.user_id')
                    ->where('autos.type',$request['type'])
                    ->where('status',1)
                    ->limit($limit)
                    ->offset($offset)
                    ->select('autos.*','users.phone')
                    ->orderBy('id','desc')
                    ->get();
            }
            $orders = [];
            foreach ($ordersDB as $item) {
                $temp['id'] = $item->id;
                $temp['user_id'] = $item->user_id;
                $temp['user'] = User::find($item->user_id);
                $temp['type'] = $item->type;
                $temp['from'] = $item->from;
                $temp['to'] = $item->to;
                $temp['description'] = $item->description;
                $temp['price'] = $item->price;
                $temp['status'] = $item->status;
                $temp['created_at'] = $item->created_at;
                $temp['updated_at'] = $item->updated_at;
                $temp['phone'] = $item->phone;
                $temp['images'] = $this->Images($item->type,$item->id);
                $orders [] =$temp;
            }
            if (count($orders) != 0){

                $result['statusCode '] = 200;
                $result['message'] = "success";

                $result['result']['count_pages'] = $pages;
                $result['result']['count_data'] = $count;
                $result['result']['offset'] = $offset;
                $result['result']['limit'] = $limit;
                $result['result']['current_page'] = (int)$request['page'];

                $result['result']['orders'] = $orders;
            }
            else{
                $result['statusCode ']  = 404;
                $result['message'] =  'order not found';
                $result['result'] =  [];
            }
        }

        return response()->json($result,$result['statusCode ']);
    }
    public function AutoList(Request $request){
        'select * from `autos` inner join `users` on `users`.`id` = `autos`.`user_id` where `users`.`city_id` = ?';
        $rules = [
            'type' => 'required',
            'page' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {
            $s  = Auto::join('users',"users.id","autos.user_id")
                ->where('autos.type',$request['type'])
                ->where("autos.status",1)
                ->where("autos.removed",0)
                ->select("autos.*");


            if (isset($request['city_id'])){
                $s = $s->where("users.city_id",$request['city_id']);
            }
            if (isset($request['from'])){
                $s = $s->where("autos.from","like","$request->from%");
            }
            if (isset($request['to'])){
                $s = $s->where("autos.to","like","$request->to%");
            }
            $count = $s->count();

            $limit = 20;
            $offset = $limit * $request['page'];
            $pages = (int)ceil($count/$limit) - 1;

            $autos = $s->orderBy("autos.id","desc")->limit($limit)->offset($offset)->get();

            $data = [];
            foreach ($autos as $item) {
                $temp['id'] = $item->id;
                $temp['user_id'] = $item->user_id;
                $temp['user'] = User::find($item->user_id);
                $temp['type'] = $item->type;
                $temp['from'] = $item->from;
                $temp['to'] = $item->to;
                $temp['description'] = $item->description;
                $temp['price'] = $item->price;
                $temp['status'] = $item->status;
                $temp['created_at'] = Carbon::parse($item->created_at)->format("d.m.Y");
                $temp['updated_at'] = Carbon::parse($item->updated_at)->format("d.m.Y");
                $temp['phone'] = $item->phone;
                $temp['images'] = $this->Images($item->type,$item->id);
                $data[] = $temp;
            }
            if (count($data) != 0){

                $result['statusCode '] = 200;
                $result['message'] = "success";

                $result['result']['count_pages'] = $pages;
                $result['result']['count_data'] = $count;
                $result['result']['offset'] = $offset;
                $result['result']['limit'] = $limit;
                $result['result']['current_page'] = (int)$request['page'];

                $result['result']['orders'] = $data;
            }
            else{
                $result['statusCode ']  = 404;
                $result['message'] =  'order not found';
                $result['result'] =  [];
            }
        }

        return response()->json($result,$result['statusCode ']);
    }
    public function AutoMy(Request $request){
        $rules = [
            'type' => 'required',
            'token' => 'required'
        ];
        $validator = $this->validator($request->all(),$rules);
        if($validator->fails()) {
            $result['statusCode ']= 400;
            $result['message']= $validator->errors();
            $result['result']= [];
        }
        else {

            $user = User::where('token',$request['token'])->first();
            if  ($user){
                $ordersDB = Auto::where('user_id',$user->id)
                    ->where('type',$request['type'])
                    ->orderBy('id','desc')
                    ->where('removed',0)
                    ->get();

                $orders = [];
                foreach ($ordersDB as $item) {
                    $temp['id'] = $item->id;
                    $temp['user_id'] = $item->user_id;
                    $temp['user'] = User::find($item->user_id);
                    $temp['type'] = $item->type;
                    $temp['from'] = $item->from;
                    $temp['to'] = $item->to;
                    $temp['description'] = $item->description;
                    $temp['price'] = $item->price;
                    $temp['status'] = $item->status;
                    $temp['created_at'] = Carbon::parse($item->created_at)->format('d.m.Y H:i:s');
                    $temp['phone'] = $item->phone;
                    $temp['images'] = $this->Images($item->type,$item->id);
                    $orders [] =$temp;
                }
                if (count($orders) != 0){
                    $result['statusCode ']  = 200;
                    $result['message'] =  'success';
                    $result['result'] = $orders;
                }
                else{
                    $result['statusCode ']  = 404;
                    $result['message'] =  'order not found';
                    $result['result'] =  [];
                }
            }
            else{
                $result['statusCode ']  = 404;
                $result['message'] =  'User not found';
                $result['result'] =  [];
            }
        }

        return response()->json($result,$result['statusCode ']);
    }



    public function AutoActivate(Request $request)
    {
        $rules = [
            'token' => 'required',
            'id' => 'required'
        ];
        $validator = $this->validator($request->all(), $rules);
        if ($validator->fails()) {
            $result['statusCode '] = 400;
            $result['message'] = $validator->errors();
            $result['result'] = [];
        } else {
            $user = User::where('token',$request['token'])->first();
            if ($user){
                $auto = Auto::find($request['id']);
                if  ($auto){
                    if ($user->balanse > 5){

                        $auto->status = 1;
                        $auto->save();

                        $result['statusCode '] = 200;
                        $result['message'] = 'success';
                        $result['result'] = [];
                    }
                    else{
                        $result['statusCode '] = 401;
                        $result['message'] = 'нехватка баланса';
                        $result['result'] = [];
                    }
                }
                else{
                    $result['statusCode '] = 404;
                    $result['message'] = 'авто не найдень';
                    $result['result'] = [];
                }
            }
            else{
                $result['statusCode '] = 404;
                $result['message'] = 'User not found';
                $result['result'] = [];
            }

        }
        return $result;
    }
    public function AutoDeactivate(Request $request)
    {
        $rules = [
            'token' => 'required',
            'id' => 'required'
        ];
        $validator = $this->validator($request->all(), $rules);
        if ($validator->fails()) {
            $result['statusCode '] = 400;
            $result['message'] = $validator->errors();
            $result['result'] = [];
        } else {
            $user = User::where('token',$request['token'])->first();
            if ($user){
                $auto = Auto::find($request['id']);
                if  ($auto){
                    $auto->status =0;
                    $auto->save();
                    $result['statusCode '] = 200;
                    $result['message'] = 'success';
                    $result['result'] = [];
                }
                else{
                    $result['statusCode '] = 404;
                    $result['message'] = 'авто не найдень';
                    $result['result'] = [];
                }
            }
            else{
                $result['statusCode '] = 404;
                $result['message'] = 'User not found';
                $result['result'] = [];
            }

        }

        return $result;
    }
    public function AutoCheck(){

        DB::table('autos')
            ->join('users','users.id','=','autos.user_id')
            ->where('autos.status',1)
            ->where('users.balanse','<',5)
            ->update(['autos.status' => 0]);

        DB::table('autos')
            ->join('users','users.id','=','autos.user_id')
            ->where('autos.status',1)
            ->decrement('users.balanse', 5);


        return 1;
    }

    protected function Images($parent_type,$parent_id){
        $images = Image::where('parent_type',$parent_type)->where('parent_id',$parent_id)->get();
        if (count($images) > 0){
            return $images;
        }
        else{
            $item[0]['path'] = 'public/images/no-photo.png';
            return $item;
        }
    }
    protected function mail($view,$array,$mail = 'agabek309@gmail.com',$subject='ArzanTaxi'){
        Mail::send($view, $array,  function ($message) use($mail,$subject)  {
            $message->
            to($mail, $subject)->subject($subject);
        });
    }
    protected function parse($string){
        return explode(',',$string);
    }

    protected function validator($errors,$rules) {
        return Validator::make($errors,$rules);
    }
    protected function uploadFile($media,$dir = 'images') {
//       if (isset($media)){
//           $filename = $media->getClientOriginalName();
//           return 'public/'.Storage::disk('public')->putFileAs($dir,$media,str_random(20).'.'.File::extension($filename));
//       }

        if (isset($media)){
            $file_type = File::extension($media->getClientOriginalName());
            $file_name = time().str_random(5).'.'.$file_type;
            $media->move($dir, $file_name);
            return $dir.'/'.$file_name;
        }
    }
    protected function deleteFile($media) {
        if (File::exists($media)) {
            File::delete($media);
            return 1;
        }
        else{
            return 0;
        }
    }


    public function tariffsCity(Request $request)
    {
        $rules = [
            'token' => 'required',
        ];

        $validator = $this->validator($request->all(), $rules);

        if ($validator->fails()) {
            $result['statusCode '] = 400;
            $result['message'] = $validator->errors();
            $result['result'] = [];
        } else {
            $user = User::where('token', $request['token'])->first();
            $city = City::where('id', $user['city_id'])->first();
            $result['statusCode'] = 200;
            $result['message'] = 'Success!';
            $result['result'] = $city;
        }

        return $result;
    }
}
