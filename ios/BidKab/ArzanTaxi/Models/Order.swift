//
//  Order.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 12/21/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class Order {
    var id : Int?
    var type : String?
    var passenger_id : Int?
    var passenger : User?
    var driver_id : Int?
    var driver : User?
    var from : String?
    var from_lat : String?
    var from_lon : String?
    var to : String?
    var to_lat : String?
    var to_lon : String?
    var price : Int?
    var city_id : Int?
    var count_passenger : Int?
    var get_passenger : Int?
    var bonus : Int?
    var status : Int?
    var step : Int?
    var created_at : String?
    var description : String?
    var phone : String?
    var images = [String]()
    var isWoman: Bool?
    var isInvalid: Bool?
}
