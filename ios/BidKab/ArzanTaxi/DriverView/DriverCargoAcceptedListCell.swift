//
//  DriverCargoAcceptedListCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 12/18/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DriverCargoAcceptedListCell : UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    let cellID = "driverOrderIntercityID"
    var list = [Cargo]()
    var temp = [Cargo]()
    var idList = [Int]()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        
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
        list.removeAll()
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        Alamofire.request(Constant.api.cargo_active, method: .post, parameters: [ "token" : token ], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    for i in json["result"].arrayValue {
                        let cargo = Cargo()
                        
                        cargo.id = i["id"].intValue
                        cargo.type = i["type"].stringValue
                        cargo.from = i["from"].stringValue
                        cargo.to = i["to"].stringValue
                        cargo.price = i["price"].intValue
                        
                        self.list.append(cargo)
                    }
                    
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        getAllCargoList()
        
        if let idTemp = UserDefaults.standard.object(forKey: "idList") as? [Int] {
            self.idList = idTemp
        }
        
        tableView.register(DriverCargoCell.self, forCellReuseIdentifier: cellID)
        checkCurrentOrder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DriverCargoCell
        
        cell.aPoint.text = list[indexPath.row].from
        cell.bPoint.text = list[indexPath.row].to
        cell.price.text = "\(list[indexPath.row].price!)"
        if let phone = list[indexPath.row].passenger?.phone {
            cell.phone = phone.removingWhitespaces()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82.5
    }
}
