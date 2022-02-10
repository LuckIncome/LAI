//
//  CarColor.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 12/7/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CarColor {
    var id : Int?
    var name_kk : String?
    var name_ru : String?
    var name_en : String?
    
    init(){}
    
    init(json: JSON){
        id = json["result"]["taxi_cars"]["color"]["id"].intValue
        name_kk = json["result"]["taxi_cars"]["color"]["name_kk"].stringValue
        name_ru = json["result"]["taxi_cars"]["color"]["name_ru"].stringValue
        name_en = json["result"]["taxi_cars"]["color"]["name_en"].stringValue
    }
    
    static func getCarColors(comletion: @escaping ([CarColor]) -> ()) {
        var carColors = [CarColor]()
        
        Alamofire.request(Constant.api.car_colors).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if json["statusCode"].intValue == Constant.statusCode.success {
                        for color in json["result"].arrayValue {
                            let carColor = CarColor()
                            
                            carColor.id = color["id"].intValue
                            carColor.name_kk = color["name_kk"].stringValue
                            carColor.name_ru = color["name_ru"].stringValue
                            carColor.name_en = color["name_en"].stringValue
                            
                            carColors.append(carColor)
                        }
                        
                        comletion(carColors)
                    }
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
}
