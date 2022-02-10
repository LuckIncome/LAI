//
//  User.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/20/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import FirebaseMessaging

class User {
    var id : Int?
    var surname : String?
    var name : String?
    var middle_name : String?
    var phone : String?
    var role : Int?
    var city_id : Int?
    var city : String?
    var lat : String?
    var lon : String?
    var avatar : String?
    var token : String?
    var promo_code : String?
    var promo_code_access: Int?
    var balanse : Int?
    var online : Int?
    var iin : String?
    var id_card : String?
    var expired_date : String?
    var year : Int?
    var driver_was : Int?
    var tech_passport : String?
    var rating : String?
    var socket_id : Int?
    var taxi_cars : Car?
    var cargo_cars : Car?
    var special_cars : [SpecialEquipment]?
    var toi_cars : [VipTaxi]?
    var cargoExist : Bool?
    var price: String?
    var orderId: Int?
    var home_address: String?
    var home_lat: Double?
    var home_lng: Double?
    var work_address: String?
    var work_lat: Double?
    var work_lng: Double?
    
    init(){
        
    }
    
    init(json: JSON){
        id = json["result"]["passenger"]["id"].intValue
        surname = json["result"]["passenger"]["surname"].stringValue
        name = json["result"]["passenger"]["name"].stringValue
        middle_name = json["result"]["passenger"]["middle_name"].stringValue
        phone = json["result"]["passenger"]["phone"].stringValue
        role = json["result"]["passenger"]["role"].intValue
        city_id = json["result"]["passenger"]["city_id"].intValue
        city = json["result"]["passenger"]["city"].stringValue
        lat = json["result"]["passenger"]["lat"].stringValue
        lon = json["result"]["passenger"]["lon"].stringValue
        avatar = json["result"]["passenger"]["avatar"].stringValue
        token = json["result"]["passenger"]["token"].stringValue
        promo_code = json["result"]["passenger"]["promo_code"].stringValue
        balanse = json["result"]["passenger"]["balance"].intValue
        online = json["result"]["passenger"]["online"].intValue
        iin = json["result"]["passenger"]["iin"].stringValue
        id_card = json["result"]["passenger"]["id_card"].stringValue
        promo_code_access = json["result"]["passenger"]["promo_code_access"].intValue
        home_address = json["result"]["passenger"].stringValue
        home_lat = json["result"]["passenger"].doubleValue
        home_lng = json["result"]["passenger"].doubleValue
        work_address = json["result"]["passenger"].stringValue
        work_lat = json["result"]["passenger"].doubleValue
        work_lng = json["result"]["passenger"].doubleValue
    }
    
    static func registerUser(body : Parameters, completion : @escaping (_ user : User, _ statusCode : Int) -> Void) {
        Alamofire.request(Constant.api.register, method: HTTPMethod.post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Regist:", json)
                    if json["statusCode "].intValue == Constant.statusCode.success {
                        let user = User()
                        user.id = json["result"]["id"].intValue
                        user.surname = json["result"]["surname"].stringValue
                        user.name = json["result"]["name"].stringValue
                        user.middle_name = json["result"]["middle_name"].stringValue
                        user.phone = json["result"]["phone"].stringValue
                        user.role = json["result"]["role"].intValue
                        user.city_id = json["result"]["city_id"].intValue
                        user.city = json["result"]["city"].stringValue
                        user.lat = json["result"]["lat"].stringValue
                        user.lon = json["result"]["lon"].stringValue
                        user.avatar = json["result"]["avatar"].stringValue
                        user.token = json["result"]["token"].stringValue
                        user.promo_code = json["result"]["promo_code"].stringValue
                        user.balanse = json["result"]["balance"].intValue
                        user.online = json["result"]["online"].intValue
                        user.iin = json["result"]["iin"].stringValue
                        user.id_card = json["result"]["id_card"].stringValue
                        UserDefaults.standard.set(user.token, forKey: "token")
                        UserDefaults.standard.set(user.id, forKey: "user_id")
                        UserDefaults.standard.set(user.city_id, forKey: "city_id")
                        completion(user, Constant.statusCode.success)
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    static func verifyCode(body : Parameters, completion : @escaping (_ user : User, _ statusCode : Int) -> Void) {
        Alamofire.request(Constant.api.verify, method: HTTPMethod.post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Verify:", json)
                    if json["statusCode"].intValue == Constant.statusCode.success {
                        completion(User(), Constant.statusCode.success)
                    }
                }
            case .failure(let error):
                print(error)
                completion(User(), Constant.statusCode.notFound)
            }
        })
    }
    
    static func authUser(body : Parameters, completion : @escaping (_ status: Result<Any>, _ user : User, _ statusCode : Int) -> Void) {
        let user = User()
        Alamofire.request(Constant.api.auth, method: HTTPMethod.post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Auth: \(json)")
                    if json["statusCode "].intValue == Constant.statusCode.success {
                        user.id = json["result"]["id"].intValue
                        user.surname = json["result"]["surname"].stringValue
                        user.name = json["result"]["name"].stringValue
                        user.middle_name = json["result"]["middle_name"].stringValue
                        user.phone = json["result"]["phone"].stringValue
                        user.role = json["result"]["role"].intValue
                        user.city_id = json["result"]["city_id"].intValue
                        user.city = json["result"]["city"].stringValue
                        user.lat = json["result"]["lat"].stringValue
                        user.lon = json["result"]["lon"].stringValue
                        user.avatar = json["result"]["avatar"].stringValue
                        user.token = json["result"]["token"].stringValue
                        user.promo_code = json["result"]["promo_code"].stringValue
                        user.promo_code_access = json["result"]["promo_code_access"].intValue
                        user.balanse = json["result"]["balanse"].intValue
                        user.online = json["result"]["online"].intValue
                        user.iin = json["result"]["iin"].stringValue
                        user.id_card = json["result"]["id_card"].stringValue
                        user.expired_date = json["result"]["expired_date"].stringValue
                        user.tech_passport = json["result"]["tech_passport"].stringValue
                        user.home_address = json["result"]["home_address"].stringValue
                        user.home_lat = json["result"]["home_lat"].doubleValue
                        user.home_lng = json["result"]["home_lng"].doubleValue
                        user.work_address = json["result"]["work_address"].stringValue
                        user.work_lat = json["result"]["work_lat"].doubleValue
                        user.work_lng = json["result"]["work_lng"].doubleValue

                        UserDefaults.standard.set(user.id, forKey: "user_id")
                        
                        if let path = user.avatar {
                            user.avatar = Constant.api.prefixForImage + path
                        }
                        user.driver_was = json["result"]["driver_was"].intValue
                        if user.driver_was == 0 {
                            UserDefaults.standard.set(false, forKey: "driverWas")
                        } else {
                            UserDefaults.standard.set(true, forKey: "driverWas")
                        }
                        let car = Car(json: json)
                        let carMark = CarMark(json: json)
                        car.mark = carMark
                        let carModel = CarModel(json: json)
                        car.model = carModel
                        let color = CarColor(json: json)
                        car.color = color
                        user.taxi_cars = car
                        var specCars = [SpecialEquipment]()
                        for spec in json["result"]["special_cars"].arrayValue {
                            let special_cars = SpecialEquipment(spec: spec)
                            specCars.append(special_cars)
                        }
                        user.special_cars = specCars
                        var toiCars = [VipTaxi]()
                        for toiCar in json["result"]["toy_cars"].arrayValue {
                            let car = VipTaxi(toiCar: toiCar)
                            let color = CarColor()
                            color.id = toiCar["color"]["id"].intValue
                            color.name_kk = toiCar["color"]["name_kk"].stringValue
                            color.name_ru = toiCar["color"]["name_ru"].stringValue
                            color.name_en = toiCar["color"]["name_en"].stringValue
                            car.color = color
                            toiCars.append(car)
                        }
                        user.toi_cars = toiCars
                        if json["result"]["cargo_cars"].arrayValue.count > 0 {
                            user.cargoExist = true
                        } else {
                            user.cargoExist = false
                        }
                        UserDefaults.standard.set(user.token, forKey: "token")
                        UserDefaults.standard.set(user.city_id, forKey: "city_id")
                        completion(response.result, user, Constant.statusCode.success)
                    } else {
                        completion(response.result, User(), Constant.statusCode.notFound)
                    }
                }
            case .failure:
                completion(response.result, User(), Constant.statusCode.notFound)
            }
        })
        print(user)
    }
}
