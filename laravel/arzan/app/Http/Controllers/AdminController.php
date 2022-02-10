<?php

namespace App\Http\Controllers;

use App\Models\AdminFeedback;
use App\Models\BalanseTranslate;
use App\Models\CargoCar;
use App\Models\CargoOrder;
use App\Models\CarMark;
use App\Models\CarModel;
use App\Models\City;
use App\Models\Color;
use App\Models\Feedback;
use App\Models\Image;
use App\Models\IntercityOrder;
use App\Models\Moderator;
use App\Models\Notification;
use App\Models\Offer;
use App\Models\Order;
use App\Models\OrderHistory;
use App\Models\Payment;
use App\Models\PositionFriend;
use App\Models\PromoCode;
use App\Models\SpecialCar;
use App\Models\TaxiCar;
use App\Models\TaxiOrder;
use App\Models\ToyCar;
use App\Models\User;
use App\Objects\Exceptions\Exception;
use Illuminate\Http\Request;
use Validator;
use File;
use DB;
use Carbon\Carbon;
use Illuminate\Support\Facades\Storage;
use Mail;
use GuzzleHttp\Client;
class AdminController extends Controller
{
    public function SignIn()
    {
        if (session()->has('admin')) {
            return redirect()->route('MainPage');
        } else {
            return view('index');
        }
    }

    public function Out(Request $request)
    {
        foreach (session()->all() as $k => $item) {
            session()->forget($k);
            session()->save();
        }
        return redirect()->route('SignIn');
    }

    public function SignInPost(Request $request)
    {
        $moderator = Moderator::where('login', $request['login'])->where('password', $request['password'])->first();
        if ($moderator) {
            session()->put('admin', 1);
            session()->put('login', $moderator->login);
            session()->save();
        } else {
            return redirect()->route('MainPage');
        }
        return redirect()->route('SignIn');

        return view('index');
    }

    public function MainPage()
    {
        return view('main');
    }

    public function search(Request $request)
    {
        $usersDB = DB::table('users')
            ->where('phone', 'like', '%' . $request['text'] . '%')
            ->orWhere('surname', 'like', '%' . $request['text'] . '%')
            ->orWhere('name', 'like', '%' . $request['text'] . '%')
            ->orWhere('middle_name', 'like', '%' . $request['text'] . '%')
            ->orderBy('id', 'DESC')
            ->paginate(15);
        $users = [];
        if (count($usersDB) != 0) {
            foreach ($usersDB as $user) {
                $item = $this->GetUser($user->id);
                if ($item['statusCode'] == 200) {
                    $users[] = $item['result'];
                }
            }
        }
        return view('users.search', compact(['usersDB', 'users']));
    }

    public function Orders($type, $status = null)
    {
        if ($status == null) {
            $orders = Order::where('type', $type)->orderBy('id', 'DESC')->paginate(15);
        } else {
            $orders = Order::where('type', $type)
                ->where('status', $status)
                ->orderBy('id', 'DESC')
                ->paginate(15);
        }

        return view('orders.orders', compact(['orders', 'type']));
    }

    public function OrderDelete($id)
    {
        $order = Order::find($id);
        $order->delete();

        return redirect()->back();
    }

    public function Moderators()
    {
        if (session()->get('admin') == 1) {
            $items = Moderator::all();
            return view('users.moderators', compact('items'));
        } else {
            echo 'Нет доступа';
        }

    }

    public function DeleteModerator($id)
    {
        if (session()->get('admin') == 1) {
            $items = Moderator::find($id);
            $items->delete();
            return redirect()->route('Moderators');
        } else {
            echo 'Нет доступа';
        }
    }

    public function CreateModerator(Request $request)
    {
        if (session()->get('admin') == 1) {
            $items = new Moderator();
            $items->login = $request['login'];
            $items->password = $request['password'];
            $items->save();

            return redirect()->route('Moderators');
        } else {
            echo 'Нет доступа';
        }
    }

    public function BlackLists()
    {
        $users = User::where('access', 0)->get();
        return view('users.black_lists', compact('users'));
    }

    public function BlackListAdd($id)
    {
        $user = User::find($id);
        $user->access = 0;
        $user->save();
        return redirect()->back();
    }

    public function BlackListDelete($id)
    {
        $user = User::find($id);
        $user->access = 1;
        $user->save();
        return redirect()->back();
    }

    public function Passengers(Request $request)
    {

        $sql = " SELECT COUNT(*) FROM users
            where access = 1 ";

        if (isset($request['city_id']) and $request['city_id'] != 'on') {
            $sql .= " AND city_id = $request->city_id ";
        }
        if (isset($request['role']) and $request['role'] != 'on') {
            $sql .= " AND role = $request->role ";
        }

        $count = collect(DB::select($sql))->pluck('COUNT(*)')->toArray()[0];
        $limit = 20;

        $pages = ceil($count / $limit);
        $page = min($pages, filter_input(INPUT_GET, 'page', FILTER_VALIDATE_INT, array(
            'options' => array(
                'default' => 1,
                'min_range' => 1,
            ),
        )));
        $offset = ($page - 1) * $limit;
        if ($offset <= 0) $offset = 0;

        $start = $offset + 1;
        $end = min(($offset + $limit), $count);

        $firstlink = "<a class='btn btn-link' href='?page=1'>Первая Страница</a>";;
        $lastlink = "<a class='btn btn-link' href='?page=" . $pages . "'>Первая Страница</a>";;
        if ($page > 1) {
            $link = '?page=' . ($page - 1);
            if (isset($request['city_id']) and $request['city_id'] != 'on') {
                $link .= "&city_id=$request->city_id";
            }
            if (isset($request['role']) and $request['role'] != 'on') {
                $link .= "&role=$request->role";
            }
            $prevlink = "<a class='btn btn-link' href=" . url('/system/users' . $link) . ">Пред</a>";
        } else {
            $prevlink = '<span class="disabled"></span> <span class="disabled"></span>';
        }
        $links = '';
        if ($page < $pages) {
            $link = '';
            if (isset($request['city_id']) and $request['city_id'] != 'on') {
                $link .= "&city_id=$request->city_id";
            }
            if (isset($request['role']) and $request['role'] != 'on') {
                $link .= "&role=$request->role";
            }
            $nextlink = "<a class='btn btn-link' href=" . url('/system/users?page=' . ($page + 1) . $link) . ">След</a>";

            for ($i = 1; $i < $pages; $i++) {
                $links .= "<a class='btn btn-link' href=" . url('/system/users?page=' . $i . $link) . ">$i</a>";
            }
        } else {
            $nextlink = '<span class="disabled"></span> <span class="disabled"></span>';
        }

        $sql = "
            SELECT * FROM users
            where access = 1
        ";
        if (isset($request['city_id']) and $request['city_id'] != 'on') {
            $sql .= " AND city_id = $request->city_id ";
        }


        if (isset($request['role']) and $request['role'] != 'on') {
            $sql .= " AND role = $request->role ";
        }
        $sql .= " ORDER BY id DESC LIMIT $limit OFFSET $offset  ";

        $usersDB = DB::select($sql);
        $users = [];
        if (count($usersDB) != 0) {
            foreach ($usersDB as $user) {
                $item = $this->GetUser($user->id);
                if ($item['statusCode'] == 200) {
                    $users[] = $item['result'];
                }
            }
        }
        return view('users.users', compact(
            ['usersDB',
                'users',
                'links',
                'request',
                'count',
                'start',
                'end',
                'firstlink',
                'prevlink',
                'lastlink',
                'nextlink',
            ]));
    }

    public function Passenger($id)
    {
        $user = $this->GetUser($id)['result'];
        $taxi_orders = [];
        $taxi_ordersDB = TaxiOrder::where('passenger_id', $id)->get();
        if (count($taxi_ordersDB) != 0) {
            foreach ($taxi_ordersDB as $item) {
                $taxi_orders[] = $this->GetTaxiOrder($item->id)['result'];
            }
        }
        return view('users.passenger', compact(['user', 'taxi_orders']));
    }

    public function Direction($id)
    {
        $order = TaxiOrder::find($id);
        return view('orders.direction', compact('order'));
    }

    public function Drivers()
    {
        return view('users.drivers');
    }

    public function Driver($id)
    {
        $user = $this->GetUser($id)['result'];
        $taxi_orders = [];
        $taxi_ordersDB = TaxiOrder::where('driver_id', $id)->get();
        if (count($taxi_ordersDB) != 0) {
            foreach ($taxi_ordersDB as $item) {
                $taxi_orders[] = $this->GetTaxiOrder($item->id)['result'];
            }
        }
        return view('users.driver', compact(['user', 'taxi_orders']));
    }

    public function EditPassenger($id)
    {
        $user = User::find($id);
        $cities = City::all();

        return view('users.passenger_edit', compact(['user', 'cities']));
    }

    public function EditDriver($id)
    {
        $user = User::find($id);
        $cities = City::all();

        return view('users.driver_edit', compact(['user', 'cities']));
    }

    public function SavePassenger(Request $request)
    {
        $user = User::find($request['id']);
        $user->surname = $request['surname'];
        $user->name = $request['name'];
        $user->middle_name = $request['middle_name'];
        $user->phone = $request['phone'];
        $user->city_id = $request['city_id'];
        $user->promo_code = $request['promo_code'];
        $user->balanse = $request['balanse'];
        $user->rating = $request['rating'];
        if (isset($request['avatar'])) {
            $this->deleteFile($user->avatar);
            $user->avatar = $this->uploadFile($request['avatar']);
        }
        $user->save();

        return redirect()->route('Passenger', $request['id']);
    }

    public function SaveDriver(Request $request)
    {
        $user = User::find($request['id']);
        $user->surname = $request['surname'];
        $user->name = $request['name'];
        $user->middle_name = $request['middle_name'];
        $user->phone = $request['phone'];
        $user->city_id = $request['city_id'];
        $user->promo_code = $request['promo_code'];
        $user->balanse = $request['balanse'];
        $user->rating = $request['rating'];
        $user->iin = $request['iin'];
        $user->id_card = $request['id_card'];
        $user->expired_date = $request['expired_date'];
        if (isset($request['avatar'])) {
            $this->deleteFile($user->avatar);
            $user->avatar = $this->uploadFile($request['avatar']);
        }
        $user->save();

        return redirect()->route('Driver', $request['id']);
    }

    public function DeleteUser($id)
    {
        $user = User::find($id);
        $orders = TaxiOrder::where('passenger_id', $user->id)->orWhere('driver_id', $user->id)->get();
        if (count($orders) != 0) {
            foreach ($orders as $order) {
                $order->delete();
            }
        }

        $taxi_cars = TaxiCar::where('user_id', $user->id)->get();
        if (count($taxi_cars) != 0) {
            foreach ($taxi_cars as $taxi_car) {
                $taxi_car->delete();
            }
        }
        $history = OrderHistory::where('user_id', $user->id)->get();
        if (count($history) != 0) {
            foreach ($history as $item) {
                $item->delete();
            }
        }
        $intercity_orders = IntercityOrder::where('passenger_id', $user->id)->orWhere('driver_id', $user->id)->get();
        if (count($intercity_orders) != 0) {
            foreach ($intercity_orders as $item) {
                $item->delete();
            }
        }
        $cargo_orders = CargoOrder::where('passenger_id', $user->id)->orWhere('driver_id', $user->id)->get();
        if (count($cargo_orders) != 0) {
            foreach ($cargo_orders as $item) {
                $item->delete();
            }
        }
        $cargo_car = CargoCar::where('user_id', $user->id)->get();
        if (count($cargo_car) != 0) {
            foreach ($cargo_car as $item) {
                $item->delete();
            }
        }
        $feedback = Feedback::where('passenger_id', $user->id)->orWhere('driver_id', $user->id)->get();
        if (count($feedback) != 0) {
            foreach ($feedback as $item) {
                $item->delete();
            }
        }

        $this->deleteFile($user->avatar);
        $this->deleteFile($user->card_photo);
        $this->deleteFile($user->tech_photo);

        $user->delete();

        return redirect()->route('Passengers');
    }

    public function DeleteOrder($id)
    {
        $order = TaxiOrder::find($id);
        $order->delete();

        return redirect()->back();
    }

    public function Translates()
    {
        $users = DB::table('balanse_translates')
            ->join('users', 'balanse_translates.user_id', '=', 'users.id')
            ->select('users.*', 'balanse_translates.balanse as balanse_translate')
            ->orderBy('balanse_translates.id', 'DESC')
            ->get();

        return view('users.translates', compact('users'));
    }

    public function TranslateToPrice($user_id, $price)
    {
        $user = User::find($user_id);
        $user->balanse -= $price;
        $user->save();

        foreach (BalanseTranslate::where('user_id', $user_id)->get() as $item) {
            $item->delete();
        }

        return redirect()->back();
    }

    /*
    public function Orders($bool = 1){

        $ordersDB = DB::table('taxi_orders')->where('status',$bool)->orderBy('id','DESC')->paginate(15);
        $orders = [];
        if (count($ordersDB) != 0){
            foreach ($ordersDB as $user) {
                $item = $this->GetTaxiOrder($user->id);
                if ($item['statusCode'] == 200){
                    $orders[] = $item['result'];
                }
            }
        }
        return view('orders.orders',compact(['ordersDB',['orders']]));
    }
    public function IntercityOrders(){
        $ordersDB = DB::table('intercity_orders')->orderBy('id','DESC')->paginate(15);
        $orders = [];
        if (count($ordersDB) != 0){
            foreach ($ordersDB as $user) {
                $item = $this->GetIntercityOrder($user->id);
                if ($item['statusCode'] == 200){
                    $orders[] = $item['result'];
                }
            }
        }
        return view('orders.intercity_orders',compact(['ordersDB',['orders']]));
    }
    public function DeleteIntercityOrder($id){
        $order = IntercityOrder::find($id);
        $order->delete();
        return redirect()->back();
    }


    public function ToyCars(){
        $carsDB = DB::table('toy_cars')->orderBy('id','DESC')->paginate(15);
        $cars = [];
        if (count($carsDB) != 0){
            foreach ($carsDB as $item) {
                $car = $this->GetToyCat($item->id);
                if ($car['statusCode'] == 200){
                    $cars[] = $car['result'];
                }
            }
        }
        return view('orders.toy_cars',compact(['carsDB','cars']));
    }
    public function CreateToyCar(){
        $marks = CarMark::all();
        $models = CarModel::all();
        $colors = Color::all();
        return view('orders.create_toy_car',compact(['marks','models','colors']));
    }
    public function AddToyCar(Request $request){
        $car = new ToyCar();
        $car->name = $request['name'];
        $car->phone = $request['phone'];
        $car->price = $request['price'];
        $car->year = $request['year'];
        $car->car_mark_id = $request['car_mark_id'];
        $car->car_model_id = $request['car_model_id'];
        $car->color_id = $request['color_id'];
        $car->save();
        if (isset($request['images'])){
            foreach ($request->file() as $file) {
                foreach ($file as $img) {
                    $car_img  = new Image();
                    $car_img->path = $this->uploadFile($img);
                    $car_img->parent_id = $car->id;
                    $car_img->parent_type = 'toy_cars';
                    $car_img->save();
                }
            }
        }
        return redirect()->route('ToyCars');
    }
    public function DeleteToyCar($id){
        $car = ToyCar::find($id);
        $images = Image::where('parent_type',$car->type)->where('parent_id',$car->id)->get();
        if (count($images) != 0){
            foreach ($images as $image) {
                $this->deleteFile($image->path);
                $image->delete();
            }
        }
        $car->delete();

        return redirect()->route('ToyCars');
    }


    public function SpecialCars(){
        $carsDB = DB::table('special_cars')->orderBy('id','DESC')->paginate(15);
        $cars = [];
        if (count($carsDB) != 0){
            foreach ($carsDB as $item) {
                $car = $this->GetSpecialCar($item->id);
                if ($car['statusCode'] == 200){
                    $cars[] = $car['result'];
                }
            }
        }
        return view('orders.special_cars',compact(['carsDB','cars']));
    }
    public function CreateSpecialCar(){
        return view('orders.create_special_car',compact(['marks','models','colors']));
    }
    public function AddSpecialCar(Request $request){
        $car = new SpecialCar();
        $car->name = $request['name'];
        $car->phone = $request['phone'];
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
                }
            }
        }
        return redirect()->route('SpecialCars');
    }
    public function DeleteSpecialCar($id){
        $car = SpecialCar::find($id);
        $images = Image::where('parent_type',$car->type)->where('parent_id',$car->id)->get();
        if (count($images) != 0){
            foreach ($images as $image) {
                $this->deleteFile($image->path);
                $image->delete();
            }
        }
        $car->delete();

        return redirect()->route('SpecialCars');
    }


    public function CargoOrders(){
        $ordersDB = DB::table('cargo_orders')->orderBy('id','DESC')->paginate(15);
        $orders = [];
        if (count($ordersDB) != 0){
            foreach ($ordersDB as $user) {
                $item = $this->GetCargoOrder($user->id);
                if ($item['statusCode'] == 200){
                    $orders[] = $item['result'];
                }
            }
        }
        return view('orders.cargo_orders',compact(['ordersDB','orders']));
    }
    public function DeleteCargoOrder($id){
        $order = CargoOrder::find($id);
        $order->delete();

        return redirect()->back();
    }
    */
    public function Notifications()
    {
        $orders = DB::table('notifications')->orderBy('id', 'DESC')->paginate(15);
        return view('orders.notifications', compact('orders'));
    }

    public function Notification($id)
    {
        $order = Notification::find($id);
        return view('orders.notification', compact('order'));
    }

    public function NotificationDelete($id)
    {
        $order = Notification::find($id);
        $this->deleteFile($order->image);
        $order->delete();
        return redirect()->route('Notifications');
    }

    public function NotificationCreate()
    {
        return view('orders.notificationCreate');
    }

    public function NotificationAdd(Request $request)
    {
        $order = new Notification();
        $order->title = $request['title'];
        $order->text = $request['text'];
        $order->created_at = Carbon::now();
        if (isset($request['image'])) {
            $this->deleteFile($order->image);
            $order->image = $this->uploadFile($request['image']);
        }
        $order->save();
        self::push($order->id, $order->title);
        return redirect()->route('Notifications');
    }

    public function NotificationSave(Request $request)
    {
        $order = Notification::find($request['id']);
        $order->title = $request['title'];
        $order->text = $request['text'];
        $order->created_at = Carbon::now();
        if (isset($request['image'])) {
            $this->deleteFile($order->image);
            $order->image = $this->uploadFile($request['image']);
        }
        $order->save();
        return redirect()->route('Notifications');
    }

    //GET
    public function GetUser($id)
    {
        $user = User::find($id);
        if ($user) {
            try {
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
                $item['balanse'] = $user->balanse;
                $item['online'] = $user->online;
                $item['iin'] = $user->iin;
                $item['id_card'] = $user->id_card;
                $item['expired_date'] = $user->expired_date;
                $item['year'] = $user->year;
                $item['driver_was'] = $user->driver_was;
                $item['created_at'] = Carbon::parse($user->created_at)->format('d.m.Y h:i');
                $item['updated_at'] = Carbon::parse($user->updated_at)->format('d.m.Y h:i');
                $item['tech_passport'] = $user->tech_passport;
                $item['card_photo'] = $user->card_photo;
                $item['tech_photo'] = $user->tech_photo;
                $item['rating'] = $user->rating;
                $item['socket_id'] = $user->socket_id;
                $item['access'] = $user->access;
                $taxi_car = TaxiCar::where('user_id', $id)->first();
                if ($taxi_car) {
                    $temp = $item['taxi_cars'] = $this->GetTaxiCar($taxi_car->id);
                    if ($temp['statusCode'] == 200) {
                        $item['taxi_cars'] = $temp['result'];
                    }
                } else {
                    $item['taxi_cars'] = [];
                }


                $cargo_car = CargoCar::where('user_id', $id)->first();
                if ($cargo_car) {
                    $item['cargo_cars'] = $this->GetCargoCar($cargo_car->id)['result'];

                    $temp = $item['cargo_cars'] = $this->GetCargoCar($cargo_car->id);
                    if ($temp['statusCode'] == 200) {
                        $item['cargo_cars'] = $temp['result'];
                    }
                } else {
                    $item['cargo_cars'] = [];
                }


                $result['statusCode'] = 200;
                $result['message'] = 'Success!';
                $result['result'] = $item;
            } catch (Exception $e) {
                $result['statusCode'] = 404;
                $result['message'] = 'User Not Found';
                $result['result'] = [];
            }
        } else {
            $result['statusCode'] = 404;
            $result['message'] = 'User Not Found';
            $result['result'] = [];
        }
        return $result;
    }

    public function GetTaxiCar($id)
    {
        $car = TaxiCar::find($id);
        $model = CarModel::find($car->car_model_id);
        if ($car and $model) {
            $item['id'] = $car->id;
            $item['type'] = $car->type;
            $item['car_mark_id'] = $car->car_mark_id;
            $item['car_mark'] = CarMark::find($car->car_mark_id)->name;
            $item['car_model_id'] = $car->car_model_id;
            $item['car_model'] = $model->name;
            $item['number'] = $car->number;
            $item['year'] = $car->year;
            $item['color'] = Color::find($car->color_id);
            $item['vip'] = $car->vip;
            $item['images'] = $this->Images($car->type, $car->id);

            $result['statusCode'] = 200;
            $result['message'] = 'Sucesss!';
            $result['result'] = $item;
        } else {
            $result['statusCode'] = 404;
            $result['message'] = 'User Not Found';
            $result['result'] = [];
        }
        return $result;
    }

    public function GetTaxiOrder($id)
    {
        $order = TaxiOrder::find($id);
        if ($order) {
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
            $item['status'] = $order->status;
            $item['step'] = $order->step;
            $item['created_at'] = Carbon::parse($order->created_at)->format('d.m.Y H:i:s');

            $result['statusCode'] = 200;
            $result['message'] = 'Sucesss!';
            $result['result'] = $item;
        } else {
            $result['statusCode'] = 404;
            $result['message'] = 'User Not Found';
            $result['result'] = [];
        }
        return $result;
    }

    public function GetCargoCar($id)
    {
        $car = CargoCar::find($id);
        if ($car) {
            $item['id'] = $car->id;
            $item['type'] = $car->type;
            $item['user_id'] = $car->user_id;
            $item['info'] = $car->info;
            $item['images'] = $this->Images($car->type, $car->id);

            $result['statusCode'] = 200;
            $result['message'] = 'Sucesss!';
            $result['result'] = $item;
        } else {
            $result['statusCode'] = 404;
            $result['message'] = 'Cargo Car Not Found';
            $result['result'] = [];
        }
        return $result;
    }

    public function GetToyCat($id)
    {
        $car = ToyCar::find($id);
        if ($car) {
            $item['id'] = $car->id;
            $item['type'] = $car->type;
            $item['name'] = $car->name;
            $item['phone'] = $car->phone;
            $item['price'] = $car->price;
            $item['car_mark_id'] = $car->car_mark_id;
            $item['car_mark'] = CarMark::find($car->car_mark_id)->name;
            $item['car_model_id'] = $car->car_model_id;
            $item['car_model'] = CarModel::find($car->car_model_id)->name;
            $item['year'] = $car->year;
            $item['color'] = Color::find($car->color_id);
            $item['images'] = $this->Images($car->type, $car->id);

            $result['statusCode'] = 200;
            $result['message'] = 'Sucesss!';
            $result['result'] = $item;
        } else {
            $result['statusCode'] = 404;
            $result['message'] = 'User Not Found';
            $result['result'] = [];
        }
        return $result;
    }

    public function GetSpecialCar($id)
    {
        $car = SpecialCar::find($id);
        if ($car) {
            $item['id'] = $car->id;
            $item['type'] = $car->type;
            $item['name'] = $car->name;
            $item['phone'] = $car->phone;
            $item['info'] = $car->info;
            $item['text'] = $car->text;
            $item['images'] = $this->Images($car->type, $car->id);

            $result['statusCode'] = 200;
            $result['message'] = 'Sucesss!';
            $result['result'] = $item;
        } else {
            $result['statusCode'] = 404;
            $result['message'] = 'User Not Found';
            $result['result'] = [];
        }
        return $result;
    }

    public function GetIntercityOrder($id)
    {
        $order = IntercityOrder::find($id);
        if ($order) {
            $item['id'] = $order->id;
            $item['type'] = $order->type;
            $item['passenger'] = $this->GetUser($order->passenger_id)['result'];
            $item['driver_id'] = ($order->driver_id != null) ? $this->GetUser($order->driver_id)['result'] : null;
            $item['from'] = $order->from;
            $item['to'] = $order->to;
            $item['price'] = $order->price;
            $item['text'] = $order->text;
            $item['date'] = $order->date;
            $item['status'] = $order->status;
            $item['step'] = $order->step;
            $offers = Offer::where('parent_type', $order->type)->where('parent_id', $order->id)->get();
            if (count($offers) != 0) {
                foreach ($offers as $offer) {
                    $temp = $this->GetUser($offer->driver_id);
                    if ($temp['statusCode'] != 404) {
                        $item['offers'][] = $temp['result'];
                    }
                }
            } else {
                $item['offers'] = [];
            }

            $result['statusCode'] = 200;
            $result['result'] = $item;
        } else {
            $result['statusCode'] = 404;
        }

        return $result;
    }

    public function GetCargoOrder($id)
    {
        $order = CargoOrder::find($id);
        if ($order) {
            $item['id'] = $order->id;
            $item['type'] = $order->type;
            $item['passenger'] = $this->GetUser($order->passenger_id)['result'];
            $item['passenger_id'] = $order->passenger_id;
            $item['driver_id'] = ($order->driver_id != null) ? $this->GetUser($order->driver_id)['result'] : null;
            $item['from'] = $order->from;
            $item['to'] = $order->to;
            $item['price'] = $order->price;
            $item['text'] = $order->text;
            $item['document'] = $order->document;
            $item['bargain'] = $order->bargain;
            $item['status'] = $order->status;
            $item['step'] = $order->step;
            $offers = Offer::where('parent_type', $order->type)->where('parent_id', $order->id)->get();
            if (count($offers) != 0) {
                foreach ($offers as $offer) {
                    $temp = $this->GetUser($offer->driver_id);
                    if ($temp['statusCode'] != 404) {
                        $item['offers'][] = $temp['result'];
                    }
                }
            } else {
                $item['offers'] = [];
            }

            $result['statusCode'] = 200;
            $result['result'] = $item;
        } else {
            $result['statusCode'] = 404;
        }

        return $result;
    }

    public function Feedback()
    {
        $items = DB::table('admin_feedback')
            ->join('users', 'users.id', 'admin_feedback.user_id')
            ->select('users.*', 'admin_feedback.*')
            ->get();
        return view('orders.feedback', compact('items'));
    }

    public function FeedbackDelete($id)
    {
        $item = AdminFeedback::find($id);
        $item->delete();

        return redirect()->back();
    }

    protected static $key = 'key=AAAAs-aGZ7E:APA91bEKxqW0mT9bj2HxXt9YBgVz7xt_Ee-dJmYtbnm6w9c2nj3skVDs_rjnwPG8b5nyxIa_RD7G_vYle8uTtQhKA1hyJXqBJTEWdTHOygyT6shwxe7qxaG0VP1TQ9I2HgCyJh-ifMaM';

    public function push($id, $title)
    {
        $client = new Client;
        $client->request('POST', 'https://fcm.googleapis.com/fcm/send', [
                'headers' => [
                    'Authorization' => self::$key,
                    'Content-Type' => 'application/json',
                ],
                'json' => [
                    "to" => "/topics/notificationa",
                    "data" => [
                        'id' => $id,
                        'title' => $title,
                        'type' => 'notification',
                    ],
                ]]
        );
        $client->request('POST', 'https://fcm.googleapis.com/fcm/send', [
                'headers' => [
                    'Authorization' => self::$key,
                    'Content-Type' => 'application/json',
                ],
                'json' => [
                    "to" => "/topics/notification",
                    "notification" => [
                        "body" => $title,
                        'id' => $id,
                        'type' => 'notification',
                        "sound" => "default"
                    ]
                ]]
        );
    }


    public function Payments()
    {
        $payments = Payment::join('users', 'users.id', 'payments.user_id')
            ->select('users.*', 'payments.amount')
            ->orderBy('payments.id', 'desc')
            ->get();
        return view('payments', compact('payments'));
    }

    public function Bonus()
    {
        $users = User::where('bonus', '>', 0)->orderBy('bonus', 'desc')->get();

        return view('bonus', compact('users'));
    }

    public function BonusPaid($id)
    {
        $user = User::find($id);
        $user->bonus = 0;
        $user->save();

        PromoCode::where('friend_user_id', $user->id)->where('paid', 0)->update(['paid' => 1]);

        return redirect()->route('Bonus');
    }


    protected function Images($parent_type, $parent_id)
    {
        $images = Image::where('parent_type', $parent_type)->where('parent_id', $parent_id)->get();
        if (count($images) != 0) {
            return $images;
        } else {
            $item[0]['path'] = 'public/images/no-photo.png';
            return $item;
        }
    }

    protected function mail($view, $array, $mail = 'agabek309@gmail.com', $subject = 'ArzanTaxi')
    {
        Mail::send($view, $array, function ($message) use ($mail, $subject) {
            $message->
            to($mail, $subject)->subject($subject);
        });
    }

    protected function parse($string)
    {
        return explode(',', $string);
    }

    protected function validator($errors, $rules)
    {
        return Validator::make($errors, $rules);
    }

    protected function uploadFile($media, $dir = 'images')
    {
        $filename = $media->getClientOriginalName();
        return 'public/' . Storage::disk('public')->putFileAs($dir, $media, str_random(20) . '.' . File::extension($filename));
    }

    protected function deleteFile($media)
    {
        $media2 = ltrim($media, 'public');
        if (Storage::disk('public')->exists($media2)) {
            if ($media != 'public/images/no-photo.png') {
                Storage::disk('public')->delete($media2);
            }
            return 1;
        } else {
            return 0;
        }

    }

    public function saveRegions(Request $request)
    {
        $cityForm = $request->input('city');
        $priceForm = $request->input('price');
        $city = City::where('name', $cityForm)->first();
        $city->price = $priceForm;
        $city->save();

        return redirect('system/regions');
    }

    public function editRegionsPrice()
    {
        $cities = City::all();
        return view('regions', compact('cities'));
    }
}