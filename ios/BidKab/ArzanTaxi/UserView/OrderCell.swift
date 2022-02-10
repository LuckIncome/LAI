//
//  OrderCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/14/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit

class OrderCell : UITableViewCell {
    
    var delegate : HistoryViewControllerDelegate?
    var option: OptionDelegate?
    var id = Int()
    
    var date = Helper.createOrderLabel(image: #imageLiteral(resourceName: "calendar").withRenderingMode(.alwaysTemplate), text: "")
    var aPoint = Helper.createOrderLabel(image: #imageLiteral(resourceName: "pointa"), text: "")
    var bPoint = Helper.createOrderLabel(image: #imageLiteral(resourceName: "pointb"), text: "")
    var price = Helper.createOrderLabel(image: #imageLiteral(resourceName: "price").withRenderingMode(.alwaysTemplate), text: "")
    
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
    var cityId: Int?
    
//    lazy var splitView: UIView = {
//        let split = UIView()
//        split.backgroundColor = .lightGray
//
//        return split
//    }()
    
    let descrip: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.numberOfLines = 0
        l.textColor = .blue
        return l
    }()
    
    lazy var optionButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "option"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleOptionButton), for: .touchUpInside)
        return button
    }()
    
    @objc
    func handleOptionButton() {
//        if let from = from, let to = to, let fromLat = fromLat, let fromLon = fromLon, let toLat = toLat, let toLon = toLon, let priceValue = priceValue, let getPassenger = getPassenger, let passengersCount = passengersCount, let bonus = bonus, let description = desc, let cityId = cityId {
//            delegate?.optionButton(from: from, to: to, price: priceValue, fromLat: fromLat, fromLon: fromLon, toLat: toLat, toLon: toLon, getPassenger: getPassenger, passengersCount: passengersCount, bonus: bonus, description: description, cityId: cityId)
//        }
//        print("Repeat Order called")
        option?.optionButton(id: id)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    func setupViews() {
        contentView.isUserInteractionEnabled = false
        date.tintColor = .blue
        price.tintColor = .blue
        descrip.tintColor = .blue
        
        addSubview(date)
        addSubview(aPoint)
        addSubview(bPoint)
        addSubview(price)
//        addSubview(splitView)
        addSubview(descrip)
        addSubview(optionButton)
        
        date.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        date.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        date.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        date.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        aPoint.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 4).isActive = true
        aPoint.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        aPoint.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        aPoint.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        bPoint.topAnchor.constraint(equalTo: aPoint.bottomAnchor, constant: 4).isActive = true
        bPoint.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bPoint.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bPoint.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        price.topAnchor.constraint(equalTo: bPoint.bottomAnchor, constant: 4).isActive = true
        price.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        price.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        price.heightAnchor.constraint(equalToConstant: 28).isActive = true
        price.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        
        optionButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        optionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        optionButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        optionButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
//        splitView.snp.makeConstraints { (make) in
//            make.top.equalTo(date).offset(4)
//            make.bottom.equalTo(price).offset(-4)
//            make.width.equalTo(0.5)
//            make.left.equalTo(self.snp.centerX).offset(10)
//        }
        
        descrip.snp.makeConstraints { (make) in
            make.top.equalTo(price.snp.bottom).offset(2)
            make.left.equalTo(price).offset(20)
            make.right.equalTo(optionButton.snp.left).offset(-4)
            make.bottom.equalTo(-8)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
