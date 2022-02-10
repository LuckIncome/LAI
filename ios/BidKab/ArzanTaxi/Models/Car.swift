//
//  Car.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 12/12/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SwiftyJSON

class Car {
    var id : Int?
    var type : String?
    var mark : CarMark?
    var model : CarModel?
    var year : String?
    var color : CarColor?
    var number : String?
    var imageURLs : [String]?
    
    init(){}
    
    init(json: JSON){
        id = json["result"]["driver"]["taxi_cars"]["id"].intValue
        type = json["result"]["driver"]["taxi_cars"]["type"].stringValue
        number = json["result"]["taxi_cars"]["number"].stringValue
        year = json["result"]["taxi_cars"]["year"].stringValue
    }
}
