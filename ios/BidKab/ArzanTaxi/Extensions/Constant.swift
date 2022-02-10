//
//  Constant.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/20/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import Foundation

class Constant : NSObject {
    struct api {
        static let prefixForImage = "http://185.111.106.48/"
        static let main = "http://185.111.106.48/api/"
        static let socketApi = String(prefixForImage.prefix(prefixForImage.count - 1)) + ":3000"
        static let register = main + "register"
        static let auth = main + "sms/auth"
        static let verify = main + "verify"
        static let get_user = main + "user/"
        static let switch_to = main + "transition/"
        static let driver = switch_to + "driver"
        static let order = main + "order/"
        static let intercity = order + "intercity/"
        static let intercity_list = intercity + "list"
        static let accept_order = main + "offer/create"
        static let cancel_intercity = main + "v2/order/remove"
        static let cargo = order + "cargo/"
        static let cargo_list = cargo + "list"
        static let profile = main + "profile/"
        static let edit_profile = profile + "edit"
        static let cities = main + "cities"
        static let car_marks = main + "car_marks"
        static let car_model = main + "car_model/"
        static let special_cars = main + "special_cars"
        static let toy_cars = main + "toy_cars"
        static let toy_car_by_id = main + "toy_car"
        static let images = "\(Constant.api.prefixForImage)images/"
        static let car_colors = main + "colors"
        static let friends_list = main + "friends"
        static let add_friend = main + "query_friend"
        static let notifications = main + "notifications"
        static let taxi_order = main + "taxi_order/"
        static let add_promo_code = main + "promo"
        static let order_history = main + "order_history"
        static let add_cargo = main + "create_cargo_car"
        static let add_special = main + "create_special_car"
        static let add_toi = main + "create_toy_car"
        static let access = main + "access"
        static let check = main + "check"
        static let transition = main + "transition"
        static let get_intercity_order = intercity + "get/"
        static let user_accept = main + "offer/accept"
        static let active = intercity + "active"
        static let end_intercity_order = intercity + "end"
        static let get_cargo_order = cargo + "get/"
        static let end_cargo_order = cargo + "end"
        static let intercity_history = intercity + "history"
        static let cargo_active = cargo + "active"
        static let accept_friend = main + "accept_friend"
        static let feedback = main + "feedback/create"
        static let bonus = main + "paystack/pay?token="
        static let smsPaymentFirstPart = main + "paystack/pay?token="
        static let translate = main + "balanse/translate/to/price"
        static let translate_to_price = main + "balanse/translate/to/price"
        static let translate_to_user = main + "balanse/translate/to/user"
        
        static let create_cargo = main + "v2/order/create"
        static let create_intercity = main + "v2/order/create"
        static let create_moto = main + "v2/order/create"
        static let create_special = main + "v2/order/create"
        static let create_toy = main + "v2/order/create"
        static let itunesLink = "http://onelink.to/bidkab"
        
        static let driver_create_intercity = main + "v2/auto/create"
        
        static let free_auto = main + "v2/auto/list?type=cargo_autos&page=0"
        static let intercity_free_auto = main + "v2/auto/list?type=intercity_autos&page=0"
        static let moto_free_auto = main + "v2/auto/list?type=moto_autos&page=0"
        static let special_free_auto = main + "v2/auto/list?type=special_autos&page=0"
        static let toy_free_auto = main + "v2/auto/list?type=toy_autos&page=0"
        
        static let driver_cargo_orders = main + "v2/order/list?type=cargo_orders&page=0"
        static let driver_inter_orders = main + "v2/order/list?type=intercity_orders&page=0"
        static let driver_moto_orders = main + "v2/order/list?type=moto_orders&page=0"
        static let driver_toy_orders = main + "v2/order/list?type=toy_orders&page=0"
        static let driver_special_orders = main + "v2/order/list?type=special_orders&page=0"
        
        static let cargo_my_order = main + "v2/order/my?type=cargo_orders&token="
        static let intercity_my_order = main + "v2/order/my?type=intercity_orders&token="
        static let moto_my_order = main + "v2/order/my?type=moto_orders&token="
        static let special_my_order = main + "v2/order/my?type=special_orders&token="
        static let toy_my_order = main + "v2/order/my?type=toy_orders&token="
        
        static let driver_inter_my_order = main + "v2/auto/my?type=intercity_autos&token="
        static let driver_cargo_my_order = main + "v2/auto/my?type=cargo_autos&token="
        static let driver_moto_my_order = main + "v2/auto/my?type=moto_autos&token="
        static let driver_toy_my_order = main + "v2/auto/my?type=toy_autos&token="
        static let driver_special_my_order = main + "v2/auto/my?type=special_autos&token="
        
        static let activate = main + "v2/auto/activate"
        static let deactivate = main + "v2/auto/deactivate"
        static let remove = main + "v2/auto/remove"
        static let order_remove = main + "v2/order/remove"
        static let friend_delete = main + "friends/delete"
        static let sendMessage = main + "sendme"
    }
    
    struct statusCode {
        static let success = 200
        static let notFound = 404
        static let phoneExist = 401
        static let promoExist = 403
    }
}
