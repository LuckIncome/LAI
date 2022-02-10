//
//  VipTaxi.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 12/29/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SwiftyJSON

class VipTaxi {
    var id : Int?
    var type : String?
    var name : String?
    var phone : String?
    var price : String?
    var car_mark_id : Int?
    var car_mark : String?
    var car_model_id : Int?
    var car_model : String?
    var year : String?
    var color : CarColor?
    var imageURLs : [String]?
    
    init(){}
    
    init(toiCar: JSON){
        id = toiCar["id"].intValue
        type = toiCar["type"].stringValue
        phone = toiCar["phone"].stringValue
        price = toiCar["price"].stringValue
        car_mark_id = toiCar["car_mark_id"].intValue
        car_mark = toiCar["car_mark"].stringValue
        car_model_id = toiCar["car_model_id"].intValue
        car_model = toiCar["car_model"].stringValue
        year = toiCar["year"].stringValue
    }
}
