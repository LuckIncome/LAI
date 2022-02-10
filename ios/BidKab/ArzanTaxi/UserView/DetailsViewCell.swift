//
//  DetailsViewCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/15/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

protocol DetailsViewCellDelegate {
    func changeCancelButton()
}

class DetailsViewCell : UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, DetailsViewCellDelegate {
    
    let cellID = "sugCellID"
    var cargoDelegate : CargoViewControllerDelegate?
    var intercityDelegate : IntercityViewControllerDelegate?
    
    var isCargoController = true
    var isDiscarded = false
    
    var orderID : Int? {
        didSet {
            loadOffers()
        }
    }
    
    var offers = [Offer]()
    
    let orderDetails : OrderDetailsView = {
        let view = OrderDetailsView()
        
        return view
    }()
    
    let suggestionView : UIView = {
        let view = UIView()
        let label = UILabel()
        let underline = UIView()
        
        label.text = .localizedString(key: "offers")
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        underline.backgroundColor = .gray
        
        view.addSubview(label)
        view.addSubview(underline)
        
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        
        underline.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        underline.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 1).isActive = true
        underline.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        return view
    }()
    
    lazy var suggestionTableView : UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        
        tv.delegate = self
        tv.dataSource = self
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.tableFooterView = UIView()
        
        return tv
    }()
    
    lazy var discardView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = .zero
        
        return view
    }()
    
    lazy var discardButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(String.localizedString(key: "cancel_order"), for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDiscard), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let refresh = UIRefreshControl()
    
    @objc func handleDiscard() {
        isDiscarded = true
        if isCargoController {
            print("rrrrrr")
        } else {
//            intercityDelegate?.
            print("tttttt")
        }
        suggestionTableView.reloadData()
    }
    
    func changeCancelButton() {
        discardButton.setTitle(.localizedString(key: "end_order"), for: .normal)
        discardButton.addTarget(self, action: #selector(endOrder), for: .touchUpInside)
    }
    
    @objc func endOrder() {
        if isCargoController {
        } else {
            //intercityDelegate?.handleEndButton()
        }
        suggestionTableView.reloadData()
    }
    
    @objc func loadOffers() {
        if let id = orderID {
            if isCargoController {
                Alamofire.request(Constant.api.get_cargo_order + "\(id)").responseJSON(completionHandler: { (response) in
                    if response.result.isSuccess {
                        if let value = response.result.value {
                            let json = JSON(value)
                            
                            print("Get cargo order: \(json)")
                            
                            if json["statusCode"].intValue == Constant.statusCode.success {
                                self.offers.removeAll()
                                for o in json["result"]["offers"].arrayValue {
                                    let id = json["result"]["id"].intValue
                                    let type = json["result"]["type"].stringValue
                                    let offer = Offer(parentID: id, type: type, offer: o)
                                    
                                    self.offers.append(offer)
                                    
                                    self.suggestionTableView.reloadData()
                                    self.refresh.endRefreshing()
                                }
                            }
                        }
                    }
                })
            } else {
                Alamofire.request(Constant.api.get_intercity_order + "\(id)").responseJSON(completionHandler: { (response) in
                    if response.result.isSuccess {
                        if let value = response.result.value {
                            let json = JSON(value)
                            
                            if json["statusCode"].intValue == Constant.statusCode.success {
                                self.offers.removeAll()
                                for o in json["result"]["offers"].arrayValue {
                                    let id = json["result"]["id"].intValue
                                    let type = json["result"]["type"].stringValue
                                    let offer = Offer(parentID: id, type: type, offer: o)
                                    
                                    self.offers.append(offer)
                                    
                                    self.suggestionTableView.reloadData()
                                    self.refresh.endRefreshing()
                                }
                            }
                        }
                    }
                })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        suggestionTableView.register(OrderSuggestionCell.self, forCellReuseIdentifier: cellID)
        suggestionTableView.allowsSelection = false
        
        addSubview(orderDetails)
        addSubview(suggestionView)
        addSubview(suggestionTableView)
        addSubview(discardView)
        discardView.addSubview(discardButton)
        
        orderDetails.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(90)
        }
        
        suggestionView.snp.makeConstraints { (make) in
            make.top.equalTo(orderDetails.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        suggestionTableView.snp.makeConstraints { (make) in
            make.top.equalTo(suggestionView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-60)
        }
        
        discardView.snp.makeConstraints { (make) in
            make.top.equalTo(suggestionTableView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        discardButton.snp.makeConstraints { (make) in
            make.top.equalTo(7)
            make.bottom.equalTo(-7)
            make.left.equalTo(50)
            make.right.equalTo(-50)
        }
        
        refresh.addTarget(self, action: #selector(loadOffers), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            suggestionTableView.refreshControl = refresh
        } else {
            suggestionTableView.addSubview(refresh)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = suggestionTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! OrderSuggestionCell
        
        cell.selectionStyle = .none
        cell.textLabel?.text = offers[indexPath.row].name
        if isCargoController {
            cell.detailTextLabel?.text = offers[indexPath.row].cargo_car?.info
        } else {
            if let mark = offers[indexPath.row].taxi_car?.mark?.name, let model = offers[indexPath.row].taxi_car?.model?.name {
                cell.detailTextLabel?.text = mark + " " + model
            }
        }
        cell.phone = offers[indexPath.row].phone
        cell.driverID = offers[indexPath.row].id
        cell.orderID = offers[indexPath.row].parentID
        cell.orderType = offers[indexPath.row].type
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
