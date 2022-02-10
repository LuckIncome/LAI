//
//  DriverCargoCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 12/18/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class DriverCargoCell : UITableViewCell {
    
    var aPoint = createOrderLabel(with: #imageLiteral(resourceName: "pointa"), placeholder: "")
    var bPoint = createOrderLabel(with: #imageLiteral(resourceName: "pointb"), placeholder: "")
    var price = createOrderLabel(with: #imageLiteral(resourceName: "tenge"), placeholder: "")
    var document = createOrderLabel(with: #imageLiteral(resourceName: "tenge"), placeholder: "")
    var torg = createOrderLabel(with: #imageLiteral(resourceName: "tenge"), placeholder: "")
    var phone = ""
    
    lazy var phoneButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: "phone"), for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCall), for: .touchUpInside)
        
        return button
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
        
        addSubview(aPoint)
        addSubview(bPoint)
        addSubview(price)
        addSubview(document)
        addSubview(torg)
        addSubview(phoneButton)
        
        aPoint.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalTo(-50)
            make.height.equalTo(27.5)
        }
        
        bPoint.snp.makeConstraints { (make) in
            make.top.equalTo(aPoint.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalTo(-50)
            make.height.equalTo(27.5)
        }
        
        price.snp.makeConstraints { (make) in
            make.top.equalTo(bPoint.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalTo(-50)
            make.height.equalTo(27.5)
        }
        
        document.snp.makeConstraints { (make) in
            make.top.equalTo(price.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalTo(-50)
            make.height.equalTo(27.5)
        }
        
        torg.snp.makeConstraints { (make) in
            make.top.equalTo(document.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalTo(-50)
            make.height.equalTo(27.5)
        }
        
        phoneButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        phoneButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        phoneButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        phoneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

