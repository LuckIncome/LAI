//
//  SpecialMyOrderCell.swift
//  ArzanTaxi
//
//  Created by MAC on 12.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SpecialMyOrderCell: RefresherCell, UITableViewDelegate, UITableViewDataSource, OptionDelegate {
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
        let url = Constant.api.special_my_order + token
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    //if json["statusCode"].intValue == Constant.statusCode.success {
                    for i in json["result"].arrayValue {
                        let o = Order()
                        
                        o.id = i["id"].intValue
                        o.created_at = i["created_at"].stringValue
                        o.to = i["to"].stringValue
                        o.price =  Int(i["price"].stringValue)!
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
        
        tableView.register(MyOrderToyCell.self, forCellReuseIdentifier: cellID)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MyOrderToyCell
        cell.option = self
        cell.date.removeFromSuperview()
        cell.price.removeFromSuperview()
        cell.status.removeFromSuperview()
        cell.id = items[indexPath.row].id!
        cell.date = Helper.createOrderLabel(image: #imageLiteral(resourceName: "calendar").withRenderingMode(.alwaysTemplate), text: items[indexPath.row].created_at!)
        cell.status = Helper.createOrderLabel(image: #imageLiteral(resourceName: "price").withRenderingMode(.alwaysTemplate), text: "\(String(describing: items[indexPath.row].price!))₸")
        cell.price = Helper.createOrderLabel(image: #imageLiteral(resourceName: "pointb"), text: "\(String(describing: items[indexPath.row].to!))")
        cell.descrip.text = items[indexPath.row].description
        cell.images = items[indexPath.row].images
        cell.setupViews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
}
