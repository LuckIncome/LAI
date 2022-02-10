<?php

namespace App\Http\Middleware;

use App\User;
use Closure;
use http\Env\Request;

class UserAuth
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next, string $role = null)
    {
        $onlyAccessedType = null;
        if ($role) {
            $onlyAccessedType = ($role == 'user') ? User::where('role', 1)->first() : User::where('role', 2)->first();
        }

        $user = User::where('token', $request->bearerToken())->whereNotNull('access_date')->first();

        if (!$user) {
            $res = $this->errorMessage(trans('User not found'));
            return response()->json($res, $res['status_code']);
        }
        if ($onlyAccessedType && $user['role'] != $onlyAccessedType) {
            $res = $this->errorMessage(trans('You have no permissions to access this request'));
            return response()->json($res, $res['status_code']);
        }

        $request['user'] = $user;
        return $next($request);
    }

    public function errorMessage($message = null)
    {
        return [
            'status_code'   =>  401,
            'message'       =>  $message,
            'data'          =>  null
        ];
    }
}
