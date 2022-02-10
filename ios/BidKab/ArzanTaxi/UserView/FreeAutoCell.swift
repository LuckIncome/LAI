//
//  FreeAutoCell.swift
//  ArzanTaxi
//
//  Created by MAC on 10.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FreeAutoCell: RefresherCell, UITableViewDelegate, UITableViewDataSource {
    
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
        tv.rowHeight = UITableViewAutomaticDimension
        return tv
    }()
    
    func loadItems() {
        let url = Constant.api.free_auto
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    //if json["statusCode"].intValue == Constant.statusCode.success {
                        for i in json["result"]["orders"].arrayValue {
                            let o = Order()
                            
                            o.created_at = i["created_at"].stringValue
                            o.price =  Int(i["price"].stringValue)
//                            o.phone = i["phone"].stringValue
                            o.phone = i["user"]["phone"].stringValue
                            o.description = i["description"].stringValue
                            
                            for img in i["images"].arrayValue {
                                o.images.append(img["path"].stringValue)
                            }
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.register(FreeAutoWithImageCell.self, forCellReuseIdentifier: cellID)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FreeAutoWithImageCell
        if let a = items[indexPath.row].price {
            cell.price.text = "\(String(describing: a))₸"
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
