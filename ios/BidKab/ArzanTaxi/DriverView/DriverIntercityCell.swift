//
//  DriverIntercityCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/18/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class DriverIntercityCell : UITableViewCell {
    
    var date = createOrderLabel(with: #imageLiteral(resourceName: "calendar").withRenderingMode(.alwaysTemplate), placeholder: "")
    var aPoint = createOrderLabel(with: #imageLiteral(resourceName: "pointa"), placeholder: "")
    var bPoint = createOrderLabel(with: #imageLiteral(resourceName: "pointb"), placeholder: "")
    var price = createOrderLabel(with: #imageLiteral(resourceName: "price").withRenderingMode(.alwaysTemplate), placeholder: "")
    var phone = ""
    
    lazy var phoneButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "phone"), for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCall), for: .touchUpInside)
        return button
    }()
    
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
        l.text = ""
        
        return l
    }()
    
    @objc func handleCall() {
        print(phone)
        phone = phone.contains("+") ? phone : "+\(phone)"
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = false
        
        addSubview(date)
        addSubview(aPoint)
        addSubview(bPoint)
        addSubview(price)
//        addSubview(splitView)
        addSubview(descrip)
        addSubview(phoneButton)
        
        date.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview()
            make.right.equalTo(-50)
            make.height.equalTo(27.5)
        }
        
        aPoint.snp.makeConstraints { (make) in
            make.top.equalTo(date.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.right.equalTo(-50)
            make.height.equalTo(27.5)
        }
        
        bPoint.snp.makeConstraints { (make) in
            make.top.equalTo(aPoint.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.right.equalTo(-50)
            make.height.equalTo(27.5)
        }
        
        price.snp.makeConstraints { (make) in
            make.top.equalTo(bPoint.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.right.equalTo(-50)
            make.height.equalTo(27.5)
        }
        
//        splitView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(8)
//            make.bottom.equalToSuperview().offset(-8)
//            make.width.equalTo(0.5)
//            make.left.equalTo(contentView.snp.centerX).offset(10)
//        }
        
        phoneButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        phoneButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        phoneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        phoneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        descrip.snp.makeConstraints { (make) in
            make.top.equalTo(price.snp.bottom).offset(2)
            make.left.equalTo(price).offset(20)
            make.right.equalTo(phoneButton.snp.left).offset(-4)
            make.bottom.equalTo(-4)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

