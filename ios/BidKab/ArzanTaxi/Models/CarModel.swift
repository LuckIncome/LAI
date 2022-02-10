//
//  CarModel.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/24/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CarModel {
    var id : Int?
    var name : String?
    var car_mark_id : Int?
    
    init(){}
    
    init(json: JSON){
        id = json["result"]["taxi_cars"]["car_model_id"].intValue
        name = json["result"]["taxi_cars"]["car_model"].stringValue
    }
    
    static func getCarModel(id : Int, completion: @escaping ([CarModel]) -> ()) {
        Alamofire.request(Constant.api.car_model + "\(id)").validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    var carsModel = [CarModel]()
                    
                    if json["statusCode"].intValue == Constant.statusCode.success {
                        for c in json["result"].arrayValue {
                            let carModel = CarModel()
                            
                            carModel.id = c["id"].intValue
                            carModel.name = c["name"].stringValue
                            carModel.car_mark_id = c["car_mark_id"].intValue
                            
                            carsModel.append(carModel)
                        }
                        completion(carsModel)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
