//
//  DriverCargoOrdersCell.swift
//  ArzanTaxi
//
//  Created by MAC on 14.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DriverCargoOrdersCell: RefresherCell, UITableViewDelegate, UITableViewDataSource {
    let cellID = "orderCellID"
    var items = [Order]()
    
    lazy var tableView : UITableView = {
        let tv = UITableView(frame: .zero, style: UITableViewStyle.plain)
        
        tv.delegate = self
        tv.dataSource = self
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.backgroundColor = .white
        tv.tableFooterView = UIView()
        tv.rowHeight = UITableViewAutomaticDimension
        tv.allowsSelection = false
        
        return tv
    }()
    
    func loadItems() {
        let url = Constant.api.driver_cargo_orders
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    var tempItems = [Order]()
                    for i in json["result"]["orders"].arrayValue {
                        let o = Order()
                        
                        o.created_at = i["created_at"].stringValue
                        o.from = i["from"].stringValue
                        o.to = i["to"].stringValue
                        o.price =  Int(i["price"].stringValue)
                        o.description = i["description"].stringValue
//                        o.phone = i["phone"].stringValue
                        o.phone = i["user"]["phone"].stringValue
                        o.description = i["description"].stringValue
                        
                        for img in i["images"].arrayValue {
                            o.images.append(img["path"].stringValue)
                        }
                        
                        tempItems.append(o)
                    }
                    self.items = tempItems
                    self.refresher.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func refreshData(_ sender: UIRefreshControl) {
        items.removeAll()
        tableView.reloadData()
        loadItems()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.register(DriverOrdersTableCell.self, forCellReuseIdentifier: cellID)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DriverOrdersTableCell
        
//        cell.aPoint.text = items[indexPath.row].from
//        cell.bPoint.text = items[indexPath.row].to
        if let price = items[indexPath.row].price {
            cell.price.text = "\(String(describing: price))"
        } else {
            cell.price.text = ""
        }
        
        cell.date.text = items[indexPath.row].created_at
        cell.phone = items[indexPath.row].phone!
        cell.descrip.text = items[indexPath.row].description
        cell.images = items[indexPath.row].images
        cell.collectionView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
