//
//  DriverToyOrdersCell.swift
//  ArzanTaxi
//
//  Created by MAC on 15.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DriverToyOrdersCell: RefresherCell, UITableViewDelegate, UITableViewDataSource {
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
        let url = Constant.api.driver_toy_orders
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Driver toy orders: \(json)")
                    
                    var tempItems = [Order]()
                    for i in json["result"]["orders"].arrayValue {
                        let o = Order()
                        
                        o.created_at = i["created_at"].stringValue
                        o.price =  Int(i["price"].stringValue)
                        o.phone = i["user"]["phone"].stringValue
                        o.description = i["description"].stringValue
                        
                        tempItems.append(o)
                    }
                    self.items = tempItems
                    self.refresher.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    @objc override func refreshData(_ sender: UIRefreshControl) {
        items.removeAll()
        tableView.reloadData()
        loadItems()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.register(DriverToyCell.self, forCellReuseIdentifier: cellID)
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DriverToyCell
        cell.price.text = "\(items[indexPath.row].price ?? 0)"
        cell.date.text = items[indexPath.row].created_at
        let phone = items[indexPath.row].phone!
        print(phone)
        cell.phone = phone
        cell.descrip.text = items[indexPath.row].description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
