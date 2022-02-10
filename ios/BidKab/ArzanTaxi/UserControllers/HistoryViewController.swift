//
//  HistoryViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/16/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HistoryViewController : RefreshController, HistoryViewControllerDelegate {

    
    let cellID = "historyCellID"
    var navTitle : String?
    
    var historyItems : [History]? {
        didSet {
            
        }
    }
    
    func optionButton(from: String, to: String, price: Int, fromLat: Double, fromLon: Double, toLat: Double, toLon: Double, getPassenger: Int, passengersCount: Int, bonus: Int, description: String, cityId: Int) {
        let alertViewController = UIAlertController(title: String.localizedString(key: "choose_action"), message: nil, preferredStyle: .actionSheet)
        let repeatOrderAction = UIAlertAction(title: String.localizedString(key: "repeat"), style: .default) { (action) in
            
            let orderController = OrderViewController()
            print("from: \(from) price: \(price)")
            
            if let token = UserDefaults.standard.string(forKey: "token") {
                Socket.shared.createOrder(token: token, from: from, fromLat: "\(fromLat)", fromLon: "\(fromLon)", to: to, toLat: "\(toLat)", toLon: "\(toLon)", price: "\(price)", passengersCount: "\(passengersCount)", getPassengers: getPassenger, bonus: bonus, description: description, completion: { (orderID, step) in
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(orderID, forKey: "currentOrderID")
                        orderController.id = orderID
                        orderController.completion = {
                            Socket.shared.client.off("order_create")
                            print("Order is completed")
                        }
                    }

                })
            }
            orderController.cityID = cityId
            orderController.from = from
            orderController.to = to
            orderController.price = "\(price)"
            orderController.fromLat = fromLat
            orderController.fromLon = fromLon
            orderController.toLat = toLat
            orderController.toLon = toLon
            

            
            self.present(orderController, animated: true, completion: nil)
        }
        
        let reverseOrderAction = UIAlertAction(title: String.localizedString(key: "reverse"), style: .default) { (action) in
            let orderController = OrderViewController()
            
            if let token = UserDefaults.standard.string(forKey: "token") {
                Socket.shared.createOrder(token: token, from: to, fromLat: "\(toLat)", fromLon: "\(toLon)", to: from, toLat: "\(fromLat)", toLon: "\(fromLon)", price: "\(price)", passengersCount: "\(passengersCount)", getPassengers: getPassenger, bonus: bonus, description: description, completion: { (orderID, step) in
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(orderID, forKey: "currentOrderID")
                        orderController.id = orderID
                        orderController.completion = {
                            Socket.shared.client.off("order_create")
                            print("Order is completed")
                        }
                    }
                })
            }
            orderController.cityID = cityId
            orderController.from = to
            orderController.to = from
            orderController.price = "\(price)"
            orderController.fromLat = toLat
            orderController.fromLon = toLon
            orderController.toLat = fromLat
            orderController.toLon = fromLon
            

            
            self.present(orderController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: String.localizedString(key: "cancel"), style: .cancel, handler: nil)
        
        alertViewController.addAction(repeatOrderAction)
        alertViewController.addAction(reverseOrderAction)
        alertViewController.addAction(cancelAction)
        
        present(alertViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var langImage = UIImage()
//        if UserDefaults.standard.string(forKey: "language") == "kz" {
//            langImage = UIImage(named: "kazakh")!
//        } else if UserDefaults.standard.string(forKey: "language") == "ru" {
//            langImage = UIImage(named: "russian")!
//        } else if UserDefaults.standard.string(forKey: "language") == "en" {
//            langImage = UIImage(named: "english")!
//        }
//        
//        langImage = langImage.withRenderingMode(.alwaysOriginal)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: langImage, style: .plain, target: self, action: #selector(changeLanguage))
        
        navigationItem.title = String.localizedString(key: "history")
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        tableView.addSubview(refresh)
        tableView.backgroundColor = .white
        tableView.register(OrderCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        
        loadHistory()
    }
    
    override func refreshData(_ sender: UIRefreshControl) {
        self.historyItems?.removeAll()
        self.tableView.reloadData()
        self.loadHistory()
    }
    
    func loadHistory() {
        if let token = UserDefaults.standard.string(forKey: "token") {
            var tempItems = [History]()
            indicator.show(withStatus: "Loading histories...")
            Alamofire.request(Constant.api.order_history, method: .post, parameters: ["token" : token], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                
                        print("Order history: \(json)")
                
                        if json["statusCode "].intValue == Constant.statusCode.success {
                
                            for item in json["result"].arrayValue {
                                let temp = History()
                
                                temp.date = item["created_at"].stringValue
                                temp.from = item["from"].stringValue
                                temp.fromLat = item["from_lat"].doubleValue
                                temp.fromLon = item["from_lon"].doubleValue
                                temp.to = item["to"].stringValue
                                temp.toLat = item["to_lat"].doubleValue
                                temp.toLon = item["to_lon"].doubleValue
                                temp.price = item["price"].intValue
                                temp.count_passenger = item["count_passenger"].intValue
                                temp.get_passenger = item["get_passenger"].intValue
                                temp.bonus = item["bonus"].intValue
                                temp.description = item["description"].stringValue
                                temp.cityId = item["city_id"].intValue
                
                                tempItems.append(temp)
                            }
                            self.historyItems = tempItems
                            self.tableView.reloadData()
                            indicator.dismiss()
                        } else {
                            indicator.showInfo(withStatus: "Empty")
                            indicator.dismiss(withDelay: 1.5)
                        }
                        self.refresh.endRefreshing()
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! OrderCell

        cell.delegate = self
        if let date = historyItems?[indexPath.row].date, let from = historyItems?[indexPath.row].from, let to = historyItems?[indexPath.row].to, let price = historyItems?[indexPath.row].price {
            
            cell.date.removeFromSuperview()
            cell.aPoint.removeFromSuperview()
            cell.bPoint.removeFromSuperview()
            cell.price.removeFromSuperview()
            
            cell.from = historyItems?[indexPath.row].from
            cell.to = historyItems?[indexPath.row].to
            cell.fromLat = historyItems?[indexPath.row].fromLat
            cell.fromLon = historyItems?[indexPath.row].fromLon
            cell.toLat = historyItems?[indexPath.row].toLat
            cell.toLon = historyItems?[indexPath.row].toLon
            cell.priceValue = historyItems?[indexPath.row].price
            cell.getPassenger = historyItems?[indexPath.row].get_passenger
            cell.passengersCount = historyItems?[indexPath.row].count_passenger
            cell.bonus = historyItems?[indexPath.row].bonus
            cell.desc = historyItems?[indexPath.row].description
            cell.cityId = historyItems?[indexPath.row].cityId
            
            cell.date = Helper.createOrderLabel(image: #imageLiteral(resourceName: "calendar"), text: date)
            cell.aPoint = Helper.createOrderLabel(image: #imageLiteral(resourceName: "pointa"), text: from)
            cell.bPoint = Helper.createOrderLabel(image: #imageLiteral(resourceName: "pointb"), text: to)
            cell.price = Helper.createOrderLabel(image: #imageLiteral(resourceName: "price"), text: "\(price)₸")
            
            cell.setupViews()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = historyItems {
            return items.count
        }
        
        return 0
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 110
//    }
}
