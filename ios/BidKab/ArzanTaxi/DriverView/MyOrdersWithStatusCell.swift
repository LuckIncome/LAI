//
//  MyOrdersWithStatusCell.swift
//  ArzanTaxi
//
//  Created by MAC on 01.08.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit

class MyOrdersWithStatusCell: UITableViewCell {

    var delegate : HistoryViewControllerDelegate?
    var option: OptionDelegate?
    var id = Int()
    
    var date = Helper.createOrderLabel(image: #imageLiteral(resourceName: "calendar"), text: "date")
    var aPoint = Helper.createOrderLabel(image: #imageLiteral(resourceName: "pointa"), text: "aPoint")
    var bPoint = Helper.createOrderLabel(image: #imageLiteral(resourceName: "pointb"), text: "bPoint")
    var price = Helper.createOrderLabel(image: #imageLiteral(resourceName: "price"), text: "price")
    var status = Helper.createOrderLabel(image: #imageLiteral(resourceName: "notifications"), text: "status")
    
    var from : String?
    var to : String?
    var fromLat : Double?
    var fromLon : Double?
    var toLat : Double?
    var toLon : Double?
    var priceValue : Int?
    var getPassenger : Int?
    var passengersCount : Int?
    var bonus : Int?
    var desc : String?
    
    let descrip: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .blue
        l.numberOfLines = 0
        
        return l
    }()
    
//    lazy var splitView: UIView = {
//        let split = UIView()
//        split.backgroundColor = .lightGray
//
//        return split
//    }()
    
    lazy var optionButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: "option"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleOptionButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleOptionButton() {
        //        if let from = from, let to = to, let fromLat = fromLat, let fromLon = fromLon, let toLat = toLat, let toLon = toLon, let priceValue = priceValue, let getPassenger = getPassenger, let passengersCount = passengersCount, let bonus = bonus, let description = desc {
        //            delegate?.optionButton(from: from, to: to, price: priceValue, fromLat: fromLat, fromLon: fromLon, toLat: toLat, toLon: toLon, getPassenger: getPassenger, passengersCount: passengersCount, bonus: bonus, description: description)
        //        }
        
        option?.optionButton(id: id)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(date)
        addSubview(aPoint)
        addSubview(bPoint)
        addSubview(price)
        addSubview(status)
        addSubview(descrip)
        addSubview(optionButton)
//        addSubview(splitView)
        
        date.topAnchor.constraint(equalTo: topAnchor).isActive = true
        date.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        date.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        date.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        
        aPoint.topAnchor.constraint(equalTo: date.bottomAnchor).isActive = true
        aPoint.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        aPoint.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        aPoint.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        
        bPoint.topAnchor.constraint(equalTo: aPoint.bottomAnchor).isActive = true
        bPoint.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bPoint.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bPoint.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        
        price.topAnchor.constraint(equalTo: bPoint.bottomAnchor).isActive = true
        price.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        price.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        price.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        
        status.topAnchor.constraint(equalTo: price.bottomAnchor).isActive = true
        status.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        status.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        status.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        status.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2).isActive = true
        
        optionButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        optionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        optionButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        optionButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
//        splitView.snp.makeConstraints { (make) in
//            make.top.equalTo(date).offset(2)
//            make.left.equalTo(self.snp.centerX).offset(10)
//            make.bottom.equalTo(status).offset(-2)
//            make.width.equalTo(0.5)
//        }
//
        descrip.snp.makeConstraints { (make) in
            make.top.equalTo(price.snp.bottom).offset(4)
            make.left.equalTo(price).offset(20)
            make.right.equalTo(optionButton.snp.left).offset(-8)
            make.bottom.equalTo(-8)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
