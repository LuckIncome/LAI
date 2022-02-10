//
//  Car.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/24/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CarMark {
    var id : Int?
    var name : String?
    
    init(){
        
    }
    
    init(json: JSON){
        id = json["result"]["taxi_cars"]["car_mark_id"].intValue
        name = json["result"]["taxi_cars"]["car_mark"].stringValue
    }
    
    static func getCarMarks(completion: @escaping ([CarMark]) -> ()) {
        Alamofire.request(Constant.api.car_marks).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    var carsMarks = [CarMark]()
                    
                    if json["statusCode"].intValue == Constant.statusCode.success {
                        for c in json["result"].arrayValue {
                            let carMark = CarMark()
                            carMark.id = c["id"].intValue
                            carMark.name = c["name"].stringValue
                            
                            carsMarks.append(carMark)
                        }
                        
                        completion(carsMarks)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
