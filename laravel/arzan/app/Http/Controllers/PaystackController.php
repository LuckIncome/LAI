<?php

namespace App\Http\Controllers;

use App\Models\Payment;
use App\Models\PromoCode;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class PaystackController extends Controller
{



    public function Pay(Request $request)
    {
        $curl = curl_init();

        $email = "$request->token@BIDKAB.com";
        $amount = $request->amount * 100; //the amount in kobo. This value is actually NGN 300
        $sk = "sk_live_6da9a4ce516a5be15586d8e7981708fbc177fcba";
        $TEST_sk = "sk_test_58a7a643e11733480b9ae2d759fb7751c4401f4f";
        curl_setopt_array($curl, array(
            CURLOPT_URL => "https://api.paystack.co/transaction/initialize",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_CUSTOMREQUEST => "POST",
            CURLOPT_POSTFIELDS => json_encode([
                'amount'=>$amount,
                'email'=>$email,
            ]),
            CURLOPT_HTTPHEADER => [
                "authorization: Bearer $sk", //replace this with your own test key
                "content-type: application/json",
                "cache-control: no-cache"
            ],
        ));

        $response = curl_exec($curl);
        $err = curl_error($curl);

        if($err){
            // there was an error contacting the Paystack API
            die('Curl returned error: ' . $err);
        }

        $tranx = json_decode($response, true);

        $result['statusCode ']= 200;
        $result['message']= 'User not found';
        $result['result']= $tranx['data'];

       return $tranx;
    }

    public function Callback(Request $request){
        Storage::append('callback.log',$request);
    }

    public function Webhook(Request $request){
        Storage::append('webhook.log',$request);
        if ($request['data']){
            $user = User::where('token',substr($request['data']['customer']['email'],0,60))->first();
            Storage::append('user.log',$user);
            if ($user){
                $user->balanse += $request["data"]['amount'] / 100;
                $user->save();



                $payment = new Payment();
                $payment->user_id = $user->id;
                $payment->amount = $request["data"]['amount'] / 100;
                $payment->save();

                $promo = PromoCode::where('user_id',$user->id)->orderBy('id',"desc")->first();
                if ($promo){
                    $f = User::find($promo->friend_user_id);
                    if ($f){
                        $f->bonus += round ($request["data"]['amount'] / 10);
                        $f->save();
                    }
                }
            }
        }
    }

}
