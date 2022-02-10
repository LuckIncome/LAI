//
//  DriverIntercityAcceptedListCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 12/18/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DriverIntercityAcceptedListCell : UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    let cellID = "driverOrderIntercityID"
    var list = [Intercity]()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        
        return tableView
    }()
    
    let refresh = UIRefreshControl()
    
    func setupViews() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        refresh.addTarget(self, action: #selector(checkCurrentOrder), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    @objc func checkCurrentOrder() {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        Alamofire.request(Constant.api.active, method: .post, parameters: [ "token" : token ], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    self.list.removeAll()
                    
                    for i in json["result"].arrayValue {
                        let intercity = Intercity()
                        
                        intercity.id = i["id"].intValue
                        intercity.type = i["type"].stringValue
                        intercity.from = i["from"].stringValue
                        intercity.to = i["to"].stringValue
                        intercity.price = i["price"].intValue
                        intercity.date = i["date"].stringValue
                        intercity.phone = i["passenger"]["phone"].stringValue.removingWhitespaces()
                        
                        self.list.append(intercity)
                        self.tableView.reloadData()
                    }
                    
                    self.refresh.endRefreshing()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
        tableView.register(DriverIntercityCell.self, forCellReuseIdentifier: cellID)
        checkCurrentOrder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DriverIntercityCell
        
        if let date = list[indexPath.row].date, let from = list[indexPath.row].from, let to = list[indexPath.row].to {
            cell.date.text = date
            cell.aPoint.text = from
            cell.bPoint.text = to
            if let price = list[indexPath.row].price, let phone = list[indexPath.row].phone {
                cell.price.text = "\(price)₸"
                cell.phone = phone
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
