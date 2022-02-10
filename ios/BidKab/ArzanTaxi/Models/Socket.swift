//
//  SocketManager.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 12/19/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SocketIO
import SVProgressHUD
import SwiftyJSON

class Socket {
    init() {}
    static let shared = Socket()
    
    static let sharedInstance = SocketClientManager()
    var client : SocketIOClient = SocketIOClient(socketURL: URL(string: Constant.api.socketApi)!, config: [.log(false), .compress, .reconnects(true), .reconnectAttempts(500), .reconnectWait(3),  .forceNew(true), .forcePolling(false), .forceWebsockets(true), .selfSigned(true)])
    
    func sendLocation(lat : String, lon : String) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let json = "{\"token\":\"\(token)\", \"lat\":\"\(lat)\", \"lon\":\"\(lon)\"}"
            let dict = [
                "token": token,
                "lat": lat,
                "lon": lon
            ]
            
            self.client.emit("geo", json)
        }

    }
    
    func sendDriverLocation(orderId: Int, lat: String, lon: String) {
        let dict: [String: Any] = [
            "order_id": orderId,
            "lat": lat,
            "lon": lon
        ]
//        client.emit("driver_positin", dict)
        do {
            let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            self.client.emit("driver_position", json)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getAllDrivers(completion : @escaping (_ drivers : [User], _ statusCode : Int) -> Void) {
        var drivers = [User]()
//            self.client.emit("geopositions", "asd")
            self.client.on("geopositions", callback: { (value, ack) in
                let dataArray = value as NSArray
                print(dataArray)
                guard dataArray.count != 0 else {
                    completion([], Constant.statusCode.notFound)
                    return
                }
//                print("Getalldrivers: \(value)")
                if let dataString = dataArray[0] as? String {
                    let encodedData = dataString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                    
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: encodedData, options: []) as! [String : AnyObject]
                        let json = JSON(jsonObject)
                        
                        drivers.removeAll()
                        
                        if json["statusCode "].intValue == Constant.statusCode.success {
                            for driver in json["result"].arrayValue {
                                let user = User()
                                
                                user.id = driver["id"].intValue
                                user.surname = driver["surname"].stringValue
                                user.name = driver["name"].stringValue
                                user.middle_name = driver["middle_name"].stringValue
                                user.phone = driver["phone"].stringValue
                                user.role = driver["role"].intValue
                                user.city_id = driver["city_id"].intValue
                                user.city = driver["city"].stringValue
                                user.lat = driver["lat"].stringValue
                                user.lon = driver["lon"].stringValue
                                user.avatar = driver["avatar"].stringValue
                                user.token = driver["token"].stringValue
                                user.promo_code = driver["promo_code"].stringValue
                                user.balanse = driver["balance"].intValue
                                user.online = driver["online"].intValue
                                user.iin = driver["iin"].stringValue
                                user.id_card = driver["id_card"].stringValue
                                user.rating = driver["rating"].stringValue
                                
                                let car = Car()
                                car.id = driver["taxi_cars"]["id"].intValue
                                
                                let carMark = CarMark()
                                carMark.id = driver["taxi_cars"]["car_mark_id"].intValue
                                carMark.name = driver["taxi_cars"]["car_mark"].stringValue
                                
                                car.mark = carMark
                                
                                let carModel = CarModel()
                                carModel.car_mark_id = car.mark?.id
                                carModel.id = driver["taxi_cars"]["car_model_id"].intValue
                                carModel.name = driver["taxi_cars"]["car_model"].stringValue
                                
                                car.model = carModel
                                
                                let carColor = CarColor()
                                carColor.id = driver["taxi_cars"]["color"]["id"].intValue
                                carColor.name_ru = driver["taxi_cars"]["color"]["name_ru"].stringValue
                                carColor.name_kk = driver["taxi_cars"]["color"]["name_kk"].stringValue
                                carColor.name_en = driver["taxi_cars"]["color"]["name_en"].stringValue
                                
                                car.color = carColor
                                
                                user.taxi_cars = car
                                
                                drivers.append(user)
                            }
                            
                            completion(drivers, Constant.statusCode.success)
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            })
    }
    
    func createOrder(token : String, from : String, fromLat : String, fromLon: String, to : String, toLat : String, toLon : String, price : String, passengersCount : String, getPassengers : Int, bonus : Int, description : String, isWoman: Bool = false, isInvalid: Bool = false, completion : @escaping (_ id : Int, _ step : Int) -> Void) {
        let isWomanTemp = isWoman ? 1 : 0
        let isInvalidTemp = isInvalid ? 1 : 0
        let dict: [String: Any] = [
            "token": token,
            "from": from,
            "from_lat": fromLat,
            "from_lon": fromLon,
            "to": to,
            "to_lat": toLat,
            "to_lon": toLon,
            "price": price,
            "count_passenger": passengersCount,
            "get_passenger": getPassengers,
            "bonus": bonus,
            "description": description,
            "woman_driver": isWomanTemp,
            "invalid": isInvalidTemp
        ]

        do {
            let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            self.client.emit("order_create", json)
            self.client.on("order_create", callback: { (value, ack) in
                let json = JSON(value)
//                print("Create order: \(json)")
                if json[0]["statusCode "].intValue == Constant.statusCode.success {
                    let id = json[0]["result"]["id"].intValue
                    let step = json[0]["result"]["step"].intValue

                    indicator.showSuccess(withStatus: "Please, wait for driver...")
                    indicator.dismiss(withDelay: 1.2)

                    completion(id, step)
                    self.client.off("order_create")
                } else {
                    indicator.showError(withStatus: "Error")
                    indicator.dismiss(withDelay: 1.2)
                    completion(0, 0)
                }
            })
        } catch {
            indicator.showError(withStatus: "Error")
            indicator.dismiss(withDelay: 1.2)
            self.client.off("order_create")
            completion(0, 0)
            print(error.localizedDescription)
        }
    }
    
    func orderList(cityID : Int, completion : @escaping (_ orderList : [Order], _ statusCode : Int) -> Void) {
        var orders = [Order]()
//        self.client.off("order_list_\(cityID)")
        self.client.emit("order_list", cityID)
        self.client.on("order_list_\(cityID)") { (data, ack) in

            let json = JSON(data)
            print("Order list: \(json)")

            if json[0]["statusCode "].intValue == Constant.statusCode.success {
                let orderList = json[0]["result"].arrayValue
                print("Orderlist: \(orderList)")
                orders.removeAll()

                for obj in orderList {
                    let temp = Order()

                    temp.id = obj["id"].intValue
                    temp.type = obj["type"].stringValue
                    temp.passenger_id = obj["passenger_id"].intValue
                    temp.step = obj["step"].intValue
                    let isWoman = obj["woman_driver"].intValue
                    temp.isWoman = isWoman == 1 ? true : false
                    let isInvalid = obj["invalid"].intValue
                    temp.isInvalid = isInvalid == 1 ? true : false
                    let user = User()

                    user.id = obj["passenger"]["id"].intValue
                    user.surname = obj["passenger"]["surname"].stringValue
                    user.name = obj["passenger"]["name"].stringValue
                    user.middle_name = obj["passenger"]["middle_name"].stringValue
                    user.phone = obj["passenger"]["phone"].stringValue
                    user.role = obj["passenger"]["role"].intValue
                    user.city_id = obj["passenger"]["city_id"].intValue
                    user.city = obj["passenger"]["city"].stringValue
                    user.lat = obj["passenger"]["lat"].stringValue
                    user.lon = obj["passenger"]["lon"].stringValue
                    user.avatar = obj["passenger"]["avatar"].stringValue
                    user.token = obj["passenger"]["token"].stringValue
                    user.promo_code = obj["passenger"]["promo_code"].stringValue
                    user.balanse = obj["passenger"]["balance"].intValue
                    user.online = obj["passenger"]["online"].intValue
                    user.iin = obj["passenger"]["iin"].stringValue
                    user.id_card = obj["passenger"]["id_card"].stringValue

                    temp.passenger = user
                    temp.driver_id = obj["driver_id"].intValue
                    temp.driver = nil
                    temp.from = obj["from"].stringValue
                    temp.from_lat = obj["from_lat"].stringValue
                    temp.from_lon = obj["from_lon"].stringValue
                    temp.to = obj["to"].stringValue
                    temp.to_lat = obj["to_lat"].stringValue
                    temp.to_lon = obj["to_lon"].stringValue
                    temp.price = obj["price"].intValue
                    temp.city_id = obj["city_id"].intValue
                    temp.count_passenger = obj["count_passenger"].intValue
//                    let getPassenger = obj["get_passenger"].intValue
//                    print("Get passenger: \(getPassenger)")
                    temp.get_passenger = obj["get_passenger"].intValue
                    temp.bonus = obj["bonus"].intValue
                    temp.status = obj["status"].intValue
                    temp.step = obj["step"].intValue
                    temp.created_at = obj["created_at"].stringValue
                    temp.description = obj["description"].stringValue

                    orders.append(temp)
                }
                completion(orders, Constant.statusCode.success)
            } else {
                completion(orders, Constant.statusCode.notFound)
            }
        }
    }
    
    func friendPosition(id : Int, completion : @escaping (_ lat : Double, _ lon : Double) -> Void) {
        client.on("user_position_" + "\(id)") { (data, ack) in
            let json = JSON(data)
            
            if json[0]["statusCode "].intValue == Constant.statusCode.success {
                let lat = json[0]["result"]["lat"].doubleValue
                let lon = json[0]["result"]["lon"].doubleValue
                
                completion(lat, lon)
            }
        }
    }
    
    func endOrder(id : Int) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let json = "{\"token\":\"\(token)\", \"order_id\":\"\(id)\"}"
            
            client.emit("order_end", json)
        }
    }
    
    func cancelOrder(id : Int, city_id : Int, completion: @escaping (Bool) -> ()) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let dict: [String: Any] = [
                "token": token,
                "order_id": id,
                "city_id": city_id
            ]
            do {
               let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let json = JSON(dict)
                print("Cancel order json: \(json)")
                self.client.emit("order_cancel", jsonData)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

    func sendOrderTrade(order_id: Int, driver_id: Int, price: Int, completion: @escaping (Bool) -> () ){
        let dict: [String : Any] = [
            "order_id": order_id,
            "driver_id": driver_id,
            "price": price
        ]


        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            self.client.emit("order_trade", jsonData)
            completion(true)
        } catch {
            print("OrderTradeError: \(error.localizedDescription)")
            completion(false)
        }
    }

    func getOrderTrade(orderId: Int, completion: @escaping ([User]) -> () ){
        print("OrderTradeGet")
        client.on("order_trade") { (data, ack) in
            var drivers: [User] = []

            let dataArray = data as NSArray
            guard dataArray.count != 0 else {
                print("Empty")
                return
            }

            for data in dataArray {

                let dataString = data as! String
                let encodedData = dataString.data(using: String.Encoding.utf8, allowLossyConversion: false)!

                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: encodedData, options: []) as! [String : AnyObject]
                    let json = JSON(jsonObject)
                    print("Order trade: \(json)")
                    let user = User()
                    let car = Car()
                    let carMark = CarMark()
                    let carModel = CarModel()
                    let carColor = CarColor()
                    user.price = json["price"].stringValue

                    let orderJson = json["order"]["result"]
                    user.orderId = orderJson["id"].intValue

                    let driverJson = JSON(json["driver"])
                    print("driver: \(driverJson)")

                    let resultJson = JSON(driverJson["result"])
                    user.avatar = resultJson["avatar"].stringValue
                    user.name = resultJson["name"].stringValue
                    user.surname = resultJson["surname"].stringValue
                    user.id = resultJson["id"].intValue
                    user.lat = resultJson["lat"].stringValue
                    user.lon = resultJson["lon"].stringValue
                    user.rating = resultJson["rating"].stringValue
                    carMark.name = resultJson["taxi_cars"]["car_mark"].stringValue
                    carModel.name = resultJson["taxi_cars"]["car_model"].stringValue
                    carColor.name_en = resultJson["taxi_cars"]["color"]["name_en"].stringValue
                    car.mark = carMark
                    car.model = carModel
                    car.color = carColor
                    car.number = resultJson["taxi_cars"]["number"].stringValue
                    user.taxi_cars = car

                    if user.orderId == orderId {
                        drivers.append(user)
                    }
                } catch {
                    print("Not parsed")
                }

            }
            completion(drivers)
        }
    }

    func acceptOrderTrade(order_id: Int, driver_id: Int, price: Int, completion: @escaping (Bool) -> () ){
        let dict: [String : Any] = [
            "order_id": order_id,
            "driver_id": driver_id,
            "price": price
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            self.client.emit("order_trade_accept", jsonData)
            completion(true)
        } catch {
            print("OrderTradeAcceptError: \(error.localizedDescription)")
            completion(false)
        }
    }

    func getAcceptOrderTrade(orderId: Int, completion: @escaping (Order, Bool) -> () ){
        client.on("order_trade_accept") { (data, ack) in
            let jsonArray = JSON(data).arrayValue

            for json in jsonArray {
                print("Order trade accept: \(json)")
                let resultJson = json["result"]
                let temp = Order()
                temp.id = resultJson["id"].intValue
                temp.type = resultJson["type"].stringValue
                temp.count_passenger = resultJson["count_passenger"].intValue
                temp.get_passenger = resultJson["get_passenger"].intValue
                temp.from = resultJson["from"].stringValue
                temp.to = resultJson["to"].stringValue
                temp.passenger_id = resultJson["passenger_id"].intValue
                temp.price = resultJson["price"].intValue
                temp.city_id = resultJson["city_id"].intValue
                temp.driver_id = resultJson["driver_id"].intValue
                temp.from_lat = resultJson["from_lat"].stringValue
                temp.from_lon = resultJson["from_lon"].stringValue
                temp.to_lat = resultJson["to_lat"].stringValue
                temp.to_lon = resultJson["to_lon"].stringValue
                temp.bonus = resultJson["bonus"].intValue
                temp.description = resultJson["description"].stringValue
                temp.status = resultJson["status"].intValue
                temp.step = resultJson["step"].intValue
                temp.created_at = resultJson["created_at"].stringValue

                let user = User()
                let passengerJson = resultJson["passenger"]
                user.id = passengerJson["id"].intValue
                user.name = passengerJson["name"].stringValue
                user.surname = passengerJson["surname"].stringValue
                user.avatar = passengerJson["avatar"].stringValue
                user.city = passengerJson["city"].stringValue
                user.city_id = passengerJson["city_id"].intValue
                user.balanse = passengerJson["balanse"].intValue
                user.token = passengerJson["token"].stringValue
                user.middle_name = passengerJson["middle_name"].stringValue
                user.lat = passengerJson["lat"].stringValue
                user.lon = passengerJson["lon"].stringValue
                user.rating = passengerJson["rating"].stringValue
                user.phone = passengerJson["phone"].stringValue
                user.online = passengerJson["online"].intValue

                temp.passenger = user

                print("OrderID: \(orderId) \(resultJson["id"])")

                if temp.id! == orderId {
                    print("Order: \(temp.get_passenger)")
                    completion(temp, true)
                    self.client.off("order_trade_accept")
                } else {
                    print("Another id")
                }
            }
        }
    }
    
    func acceptOrder(id : Int) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let json = "{\"token\":\"\(token)\", \"order_id\":\"\(id)\"}"
            
            client.emit("order_accept", json)
        }
    }
    
    func pushLocation(lat : Double, lon: Double) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let json = "{\"token\":\"\(token)\", \"lat\":\"\(lat)\", \"lon\":\"\(lon)\"}"
            
            client.emit("user_position", json)
        }
    }
    
    func loadLocation(id: Int, completion : @escaping (_ lat : Double, _ lon : Double) -> Void) {
        client.on("user_position_" + "\(id)") { (data, ack) in
            let json = JSON(data)
            
//            print("Location: \(json)")
            
            let lat = json[0]["result"]["lat"].doubleValue
            let lon = json[0]["result"]["lon"].doubleValue
            
            completion(lat, lon)
        }
    }
    
    func order(completion : @escaping (_ id: Int, _ step : Int, _ carMark : String, _ carModel : String, _ carColor : String, _ carNumber : String, _ name : String, _ phone : String, _ surname : String, _ middleName : String, _ rating : Double, _ avatar : String, _ driverID : Int, _ driverLat : Double, _ driverLon : Double) -> Void) {
            self.client.on("order", callback: { (data, ack) in
                let json = JSON(data)
                print("Order step: \(json)")

                if json[0]["statusCode "].intValue == Constant.statusCode.success {

                    let id = json[0]["result"]["id"].intValue
                    let step = json[0]["result"]["step"].intValue
                    
                    let carMark = json[0]["result"]["driver"]["taxi_cars"]["car_mark"].stringValue
                    let carModel = json[0]["result"]["driver"]["taxi_cars"]["car_model"].stringValue
                    let carColor = json[0]["result"]["driver"]["taxi_cars"]["color"]["name_ru"].stringValue
                    let carNumber = json[0]["result"]["driver"]["taxi_cars"]["number"].stringValue
                    let driverName = json[0]["result"]["driver"]["name"].stringValue
                    let driverPhone = json[0]["result"]["driver"]["phone"].stringValue.removingWhitespaces()
                    let surname = json[0]["result"]["driver"]["surname"].stringValue
                    let middleName = json[0]["result"]["driver"]["middle_name"].stringValue
                    let rating = json[0]["result"]["driver"]["rating"].doubleValue
                    let driverID = json[0]["result"]["driver"]["id"].intValue
                    let driverLat = json[0]["result"]["driver"]["lat"].doubleValue
                    let driverLon = json[0]["result"]["driver"]["lon"].doubleValue
                    
                    let path = json[0]["result"]["driver"]["avatar"].stringValue
                    let avatar = Constant.api.prefixForImage + path

                    
                    completion(id, step, carMark, carModel, carColor, carNumber, driverName, driverPhone, surname, middleName, rating, avatar, driverID, driverLat, driverLon)
                } else if json[0]["statusCode"].intValue == Constant.statusCode.success {
                    let id = json[0]["result"]["id"].intValue
                    let step = json[0]["result"]["step"].intValue
                    
                    let carMark = json[0]["result"]["driver"]["taxi_cars"]["car_mark"].stringValue
                    let carModel = json[0]["result"]["driver"]["taxi_cars"]["car_model"].stringValue
                    let carColor = json[0]["result"]["driver"]["taxi_cars"]["color"]["name_ru"].stringValue
                    let carNumber = json[0]["result"]["driver"]["taxi_cars"]["number"].stringValue
                    let driverName = json[0]["result"]["driver"]["name"].stringValue
                    let driverPhone = json[0]["result"]["driver"]["phone"].stringValue.removingWhitespaces()
                    let surname = json[0]["result"]["driver"]["surname"].stringValue
                    let middleName = json[0]["result"]["driver"]["middle_name"].stringValue
                    let rating = json[0]["result"]["driver"]["rating"].doubleValue
                    let driverID = json[0]["result"]["driver"]["id"].intValue
                    let driverLat = json[0]["result"]["driver"]["lat"].doubleValue
                    let driverLon = json[0]["result"]["driver"]["lon"].doubleValue
                    
                    let path = json[0]["result"]["driver"]["avatar"].stringValue
                    var avatar = ""
                    if path.contains("public") {
                        let startIndex = path.index(path.startIndex, offsetBy: 14)
                        let url = path[startIndex...]
                        
                        avatar = Constant.api.images + url
                    }
                    
                    completion(id, step, carMark, carModel, carColor, carNumber, driverName, driverPhone, surname, middleName, rating, avatar, driverID, driverLat, driverLon)
                } else {
                    print("error!!!")
                }
            })
    }
    
    func out(id : Int) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let dict: [String: Any] = [
                "token": token,
                "order_id": id
            ]
//            client.emit("order_out", dict)
            do {
                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                client.emit("order_out", json)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func orderArrived(id : Int) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let json = "{\"token\":\"\(token)\", \"order_id\":\"\(id)\"}"
            
            client.emit("order_arrived", json)
        }
    }
    
    func sendOnlineStatus() {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let json = "{\"token\":\"\(token)\"}"
//                SVProgressHUD.show(withStatus: "Connecting to the server...")
                print("Emit online")
                self.client.emit("online", json)
                self.client.on("online", callback: { (data, ack) in
                    UserDefaults.standard.set(true, forKey: "socketIsConnected")
//                    SVProgressHUD.showSuccess(withStatus: "Connected")
                    print("Connected")
                })
        }
    }
    
    func connect() {
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            client.on(clientEvent: .connect) { (data, ack) in
                print("Connect on: \(data)")
                self.sendOnlineStatus()
            }
            client.on(clientEvent: .disconnect) { (data, ack) in
                print("Disconnected: \(data)")
            }
            client.on(clientEvent: .error) { (data, ack) in
                print("Error ocured: \(data)")
            }
            client.on(clientEvent: .reconnect) { (data, ack) in
                print("Reconnect: \(data)")
            }
            client.on(clientEvent: .reconnectAttempt) { (data, ack) in
                print("Reconnect attempt: \(data)")
            }
            client.on(clientEvent: .statusChange) { (data, ack) in
                print("Status change: \(data)")
            }
            client.reconnects = true
            client.connect()
        }
    }
    
    func disconnect() {
        client.disconnect()
        UserDefaults.standard.set(false, forKey: "socketIsConnected")
    }
}
