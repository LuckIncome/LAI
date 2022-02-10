//
//  City.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/20/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class City {
    var id : Int?
    var name : String?
    
    static func getCities(completion: @escaping ([City]) -> ()) {
        let url = Constant.api.cities
        var cities = [City]()
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success :
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if json["statusCode"].intValue == Constant.statusCode.success {
                        for city in json["result"].arrayValue {
                            let temp = City()
                            
                            temp.id = city["id"].intValue
                            temp.name = city["name"].stringValue
                            
                            cities.append(temp)
                        }
                        
                        completion(cities)
                    }
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
}
