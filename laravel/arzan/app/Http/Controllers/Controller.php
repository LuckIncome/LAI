<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Mail;
use Validator;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    public function Index(){
	    return view('main.index');
    }
    public function SendEmail(Request $request){
        if(!isset($request['type'])){
            $request['type'] = 0;
        }
        $rules = [
            'phone' => 'required',
        ];
        $messages = [
            'phone.required' => 'Телефон обязателен для заполнение',
        ];
        $validator = $this->validatorr($request->all(), $rules, $messages);
        if($validator->fails()) {
            return back()->with('phone'.$request['type'], 'Телефон обязателен для заполнение');
        }else{
            if(isset($request['name'])){
                $name = 'Name: '.$request['name'];
            }else{
                $name = 'Unknown';
            }
            if(isset($request['email'])){
                $email = 'Email: '.$request['email'];
            }else{
                $email = 'Unknown';
            }
            $phone = 'Phone number: '.$request['phone'];
            try{
                Mail::raw($name.', '.$phone.', '.$email, function ($message) {
                    $message->from('kazbidkab@gmail.com','Your Application');
                    $message->to('kazbidkab@gmail.com')->subject('Order!');
                });
                $message = 'success';
            }catch(\Exception $e){
                dd($e);
            }
        }
        return back()->with('success'.$request['type'], 'Successfully send');
    }

    protected function validatorr($errors,$rules,$messages) {
        return Validator::make($errors,$rules,$messages);
    }
}
