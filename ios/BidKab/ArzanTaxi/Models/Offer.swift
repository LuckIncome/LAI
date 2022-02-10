//
//  Offer.swift
//  ArzanTaxi
//
//  Created by yung meg on 2/28/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SwiftyJSON

class Offer {
    var parentID : Int?
    var type : String?
    var id : Int?
    var surname : String?
    var name : String?
    var phone : String?
    var taxi_car : Car?
    var cargo_car : CargoCar?
    
    init() {
        
    }
    
    init(parentID : Int, type : String, offer : JSON) {
        self.parentID = parentID
        self.type = type
        self.id = offer["id"].intValue
        self.surname = offer["surname"].stringValue
        self.name = offer["name"].stringValue
        self.phone = offer["phone"].stringValue.removingWhitespaces()
        
        let car = Car()
        car.id = offer["taxi_cars"]["id"].intValue
        let carMark = CarMark()
        carMark.id = offer["texi_cars"]["car_mark_id"].intValue
        carMark.name = offer["taxi_cars"]["car_mark"].stringValue
        
        car.mark = carMark
        
        let carModel = CarModel()
        carModel.car_mark_id = car.mark?.id
        carModel.id = offer["taxi_cars"]["car_model_id"].intValue
        carModel.name = offer["taxi_cars"]["car_model"].stringValue
        
        car.model = carModel
        
        self.taxi_car = car
        
        let cargo = CargoCar()
        
        cargo.id = offer["cargo_cars"][0]["id"].intValue
        cargo.type = offer["cargo_cars"][0]["type"].stringValue
        cargo.user_id = offer["cargo_cars"][0]["user_id"].intValue
        cargo.info = offer["cargo_cars"][0]["info"].stringValue
        
        self.cargo_car = cargo
    }
}
