//
//  IntercityFreeAutoCell.swift
//  ArzanTaxi
//
//  Created by MAC on 10.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class IntercityFreeAutoCell: RefresherCell, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let cellID = "orderCellID"

    var cityId: Int?

    var items = [Order]()
    var filteredItems = [Order]() {
        didSet {
            tableView.reloadData()
        }
    }
    var cities = [String]()
    var filtered = [String]()
    var fromDropDown = DropDown()
    var toDropDown = DropDown()
    var isSearching = false
    var aPointText = "" {
        didSet {
            if bPointText == "" {
                filteredItems = items.filter { $0.from!.range(of: aPointText, options: .caseInsensitive, range: nil, locale: nil) != nil }
            } else {
                filteredItems = items.filter { $0.from!.range(of: aPointText, options: .caseInsensitive, range: nil, locale: nil) != nil &&  $0.to!.range(of: bPointText, options: .caseInsensitive, range: nil, locale: nil) != nil }
            }
        }
    }
    var bPointText = "" {
        didSet {
            if aPointText == "" {
                filteredItems = items.filter { $0.to!.range(of: bPointText, options: .caseInsensitive, range: nil, locale: nil) != nil }
            } else {
                filteredItems = items.filter { $0.from!.range(of: aPointText, options: .caseInsensitive, range: nil, locale: nil) != nil &&  $0.to!.range(of: bPointText, options: .caseInsensitive, range: nil, locale: nil) != nil }
            }
        }
    }
    
    lazy var fromTextField = Helper.createAutoTextFieldForIntercity(image: #imageLiteral(resourceName: "pointa"), placeholder: .localizedString(key: "from"), tag: 1, delegate: self)
    lazy var toTextField = Helper.createAutoTextFieldForIntercity(image: #imageLiteral(resourceName: "pointb"), placeholder: .localizedString(key: "to"), tag: 2, delegate: self)
    
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
        let url = Constant.api.intercity_free_auto
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    var tempItems = [Order]()
                    //if json["statusCode"].intValue == Constant.statusCode.success {
                        for i in json["result"]["orders"].arrayValue {
                            let o = Order()
                            o.created_at = i["created_at"].stringValue
                            o.from = i["from"].stringValue
                            o.to = i["to"].stringValue
                            o.price =  Int(i["price"].stringValue)
//                            o.phone = i["phone"].stringValue
                            o.phone = i["user"]["phone"].stringValue
                            o.description = i["description"].stringValue
                            tempItems.append(o)
                        }
                    self.items = tempItems
                    self.filteredItems = self.items
                    self.refresher.endRefreshing()
                    self.tableView.reloadData()
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
        setCities()
        
        toDropDown.dismissMode = .manual
        toDropDown.direction = .bottom
        toDropDown.anchorView = toTextField
        toDropDown.width = self.contentView.bounds.size.width - 70
        toDropDown.bottomOffset = CGPoint(x: 35, y: toTextField.bounds.height+45)
        
        fromDropDown.dismissMode = .manual
        fromDropDown.direction = .bottom
        fromDropDown.anchorView = fromTextField
        fromDropDown.width = self.contentView.bounds.size.width - 70
        fromDropDown.bottomOffset = CGPoint(x: 35, y: fromTextField.bounds.height+45)
        tableView.register(DriverIntercityCell.self, forCellReuseIdentifier: cellID)
        tableView.addSubview(refresher)
        addSubview(fromTextField)
        addSubview(toTextField)
        addSubview(tableView)
        
        fromTextField.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        toTextField.snp.makeConstraints { (make) in
            make.top.equalTo(fromTextField.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(toTextField.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        loadItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        toDropDown.dataSource = !isSearching ? cities : filtered
        fromDropDown.dataSource = !isSearching ? cities : filtered
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            fromDropDown.selectionAction = { [unowned self] (index, item) in
                textField.text = item
                self.aPointText = item
            }
            
            if textField.text == nil || textField.text == "" {
                isSearching = false
                contentView.endEditing(true)
                fromDropDown.reloadAllComponents()
                fromDropDown.hide()
            } else {
                isSearching = true
                filtered = cities.filter({($0.lowercased().contains(textField.text!.lowercased()))})
                reloadData()
                fromDropDown.reloadAllComponents()
                fromDropDown.show()
            }
            
            if (textField.text?.count)! < 1 {
                isSearching = false
                fromDropDown.reloadAllComponents()
                fromDropDown.hide()
            }
            break
        case 2:
            toDropDown.selectionAction = { [unowned self] (index, item) in
                textField.text = item
                self.bPointText = item
            }
            
            if textField.text == nil || textField.text == "" {
                isSearching = false
                contentView.endEditing(true)
                toDropDown.reloadAllComponents()
                toDropDown.hide()
            } else {
                isSearching = true
                filtered = cities.filter({($0.lowercased().contains(textField.text!.lowercased()))})
                reloadData()
                toDropDown.reloadAllComponents()
                toDropDown.show()
            }
            
            if (textField.text?.count)! < 1 {
                isSearching = false
                toDropDown.reloadAllComponents()
                toDropDown.hide()
            }
            break
        default:
            break
        }
        
        print("asan")
        print(textField.text!)
    }
    
    func setCities() {
        Alamofire.request(Constant.api.cities, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    for i in json["result"].arrayValue {
                        self.cities.append(i["name"].stringValue)
                    }
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DriverIntercityCell
        let order = filteredItems[indexPath.row]
        cell.aPoint.text = order.from
        cell.bPoint.text = order.to
        if let a = order.price {
            cell.price.text = "\(String(describing: a))₸"
        } else {
            cell.price.text = ""
        }
        cell.date.text = order.created_at
        cell.phone = order.phone!
//        cell.descrip.text = order.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 140
//    }
}
