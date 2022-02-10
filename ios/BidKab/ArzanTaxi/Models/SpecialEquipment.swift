//
//  SpecialEquipment.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 12/6/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SpecialEquipment {
    var id : Int?
    var type : String?
    var name : String?
    var phone : String?
    var info : String?
    var text : String?
    var images : [String]?
    
    init(){}
    
    init(spec: JSON){
        id = spec["id"].intValue
        type = spec["type"].stringValue
        name = spec["name"].stringValue
        phone = spec["phone"].stringValue
        info = spec["info"].stringValue
        text = spec["text"].stringValue
    }
    
    static func getSpecialEquipment(completion : @escaping (_ specialEquipments : [SpecialEquipment]) -> Void) {
        var specialEquipments = [SpecialEquipment]()
        
        Alamofire.request(Constant.api.special_cars).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if json["statusCode"].intValue == Constant.statusCode.success {
                    
                        for se in json["result"].arrayValue {
                            let specialEquipment = SpecialEquipment()
                            
                            print(se)
                            
                            specialEquipment.id = se["id"].intValue
                            specialEquipment.type = se["type"].stringValue
                            specialEquipment.name = se["name"].stringValue
                            specialEquipment.phone = se["phone"].stringValue
                            specialEquipment.info = se["info"].stringValue
                            specialEquipment.text = se["text"].stringValue
                            
                            for image in se["images"].arrayValue {
                                let temp = image["path"].stringValue
                                let startIndex = temp.index(temp.startIndex, offsetBy: 14)
                                let url = temp[startIndex...]
                                print(url)
//                                specialEquipment.images?.append(Constant.api.images + url)
//                                print(specialEquipment.images?.first)
                                
                                specialEquipment.images = [String]()
                                specialEquipment.images?.append(Constant.api.images + url)
                                
                                print(Constant.api.images + url)
                            }
                            
                            specialEquipments.append(specialEquipment)
                        }
                        
                        completion(specialEquipments)
                    } else {
                        completion([SpecialEquipment]())
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
