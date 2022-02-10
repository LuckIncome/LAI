//
//  DriverToyMyAutoCell.swift
//  ArzanTaxi
//
//  Created by MAC on 15.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DriverToyMyAutoCell: RefresherCell, UITableViewDelegate, UITableViewDataSource, OptionDelegate {
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
        let token = UserDefaults.standard.string(forKey: "token")!
        let url = Constant.api.driver_toy_my_order + token
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    var tempItems = [Order]()
                    for i in json["result"].arrayValue {
                        let o = Order()
                        
                        o.id = i["id"].intValue
                        o.created_at = i["created_at"].stringValue
                        o.price =  Int(i["price"].stringValue)
                        o.description = i["description"].stringValue
                        o.status = i["status"].intValue
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
    
    @objc override func refreshData(_ sender: UIRefreshControl) {
        items.removeAll()
        tableView.reloadData()
        loadItems()
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
        
        tableView.register(DriverVipMyOrdersCell.self, forCellReuseIdentifier: cellID)
        
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
                "auto_id" : "\(id)"
            ]
            self.sendParams(url: Constant.api.remove, body: body)
        }
        let activate = UIAlertAction(title: "Activate", style: .default) { (action) in
            let body : Parameters = [
                "token" : token,
                "id" : "\(id)"
            ]
            self.sendParams(url: Constant.api.activate, body: body)
        }
        let deactivate = UIAlertAction(title: "Deactivate", style: .default) { (action) in
            let body : Parameters = [
                "token" : token,
                "id" : "\(id)"
            ]
            self.sendParams(url: Constant.api.deactivate, body: body)
        }
        
        let cancelAction = UIAlertAction(title: String.localizedString(key: "cancel"), style: .cancel, handler: nil)
        
        alertController.addAction(delete)
        alertController.addAction(activate)
        alertController.addAction(deactivate)
        alertController.addAction(cancelAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DriverVipMyOrdersCell
        cell.option = self
        cell.date.removeFromSuperview()
        cell.price.removeFromSuperview()
        cell.status.removeFromSuperview()
        cell.images = items[indexPath.row].images
        cell.collectionView.reloadData()
        
        cell.id = items[indexPath.row].id!
        cell.price = Helper.createOrderLabel(image: #imageLiteral(resourceName: "tenge"), text: "\(String(describing: items[indexPath.row].price!))")
        cell.date = Helper.createOrderLabel(image: #imageLiteral(resourceName: "calendar"), text: items[indexPath.row].created_at!)
        cell.descrip.text = items[indexPath.row].description
        
        if items[indexPath.row].status! == 0 {
            cell.status = Helper.createOrderLabel(image: #imageLiteral(resourceName: "notifications"), text: "Not Active", color: .red)
        } else {
            cell.status = Helper.createOrderLabel(image: #imageLiteral(resourceName: "notifications"), text: "Active", color: .blue)
        }
        
        cell.setupViews()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
