//
//  IntercityMyOrderCell.swift
//  ArzanTaxi
//
//  Created by MAC on 10.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class IntercityMyOrderCell: RefresherCell, UITableViewDelegate, UITableViewDataSource, OptionDelegate {
    
    let cellID = "orderCellID"
    var items = [Order]()
    
    lazy var tableView : UITableView = {
        let tv = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.backgroundColor = .white
        tv.tableFooterView = UIView()
        tv.allowsSelection = false
        return tv
    }()
    
    func loadItems() {
        let token = UserDefaults.standard.string(forKey: "token")!
        let url = Constant.api.intercity_my_order + token
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    //if json["statusCode"].intValue == Constant.statusCode.success {
                        for i in json["result"].arrayValue {
                            let o = Order()
                            
                            o.id = i["id"].intValue
                            o.created_at = i["created_at"].stringValue
                            o.from = i["from"].stringValue
                            o.to = i["to"].stringValue
                            o.price =  Int(i["price"].stringValue)!
                            o.description = i["description"].stringValue
                            o.from_lat = i["from_lat"].stringValue
                            o.from_lon = i["from_lon"].stringValue
                            o.to_lat = i["to_lat"].stringValue
                            o.to_lon = i["to_lon"].stringValue
                            
                            self.items.append(o)
                        }
                        self.refresher.endRefreshing()
                        self.tableView.reloadData()
                    //}
                }
            }
        })
    }
    
    override func refreshData(_ sender: UIRefreshControl) {
        self.items.removeAll()
        self.tableView.reloadData()
        self.loadItems()
    }
    
    func sendParams(url: String, body: Parameters) {
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if json["statusCode "].intValue == Constant.statusCode.success {
                        self.items.removeAll()
                        self.loadItems()
                    }
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.register(OrderCell.self, forCellReuseIdentifier: cellID)
        tableView.addSubview(refresher)
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        loadItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func optionButton(id: Int) {
        let token = UserDefaults.standard.string(forKey: "token")!
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            let body : Parameters = [
                "token" : token,
                "order_id" : "\(id)"
            ]
            self.sendParams(url: Constant.api.order_remove, body: body)
        }
        
        let cancelAction = UIAlertAction(title: String.localizedString(key: "cancel"), style: .cancel, handler: nil)
        
        alertController.addAction(delete)
        alertController.addAction(cancelAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! OrderCell
        cell.option = self

        cell.date.removeFromSuperview()
        cell.aPoint.removeFromSuperview()
        cell.bPoint.removeFromSuperview()
        cell.price.removeFromSuperview()

        cell.id = items[indexPath.row].id!
        cell.date = Helper.createOrderLabel(image: #imageLiteral(resourceName: "calendar").withRenderingMode(.alwaysTemplate), text: items[indexPath.row].created_at!)
        cell.aPoint = Helper.createOrderLabel(image: #imageLiteral(resourceName: "pointa"), text: items[indexPath.row].from!)
        cell.bPoint = Helper.createOrderLabel(image: #imageLiteral(resourceName: "pointb"), text:  items[indexPath.row].to!)
        cell.price = Helper.createOrderLabel(image: #imageLiteral(resourceName: "price").withRenderingMode(.alwaysTemplate), text: "\(String(describing: items[indexPath.row].price!))₸")
        cell.descrip.text = items[indexPath.row].description
        
        cell.from = items[indexPath.row].from
        cell.to = items[indexPath.row].to
        if let fromLat = items[indexPath.row].from_lat { cell.fromLat = Double(fromLat) }
        if let fromLon = items[indexPath.row].from_lon { cell.fromLon = Double(fromLon) }
        if let toLat = items[indexPath.row].to_lat { cell.toLat = Double(toLat) }
        if let toLon = items[indexPath.row].to_lon { cell.toLon = Double(toLon) }
        cell.priceValue = items[indexPath.row].price
        cell.getPassenger = items[indexPath.row].get_passenger
        cell.passengersCount = items[indexPath.row].count_passenger
        cell.bonus = items[indexPath.row].bonus
        cell.desc = items[indexPath.row].description
        cell.cityId = items[indexPath.row].city_id
        
        cell.setupViews()
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
