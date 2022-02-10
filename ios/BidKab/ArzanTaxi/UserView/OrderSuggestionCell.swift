//
//  OrderSuggestionCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/15/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OrderSuggestionCell : UITableViewCell {
    var isAccepted = false
    var phone : String?
    var driverID : Int?
    var orderType : String?
    var orderID : Int?
    var delegate : DetailsViewCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        textLabel?.textColor = .blue
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        
        textLabel?.frame = CGRect(x: 105, y: textLabel!.frame.origin.y - 15, width: textLabel!.frame.width + 50, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 105, y: detailTextLabel!.frame.origin.y - 20, width: detailTextLabel!.frame.width + 50, height: detailTextLabel!.frame.height)
    }
    
    let profileImage : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_image"))
        
        imageView.layer.cornerRadius = 35
        
        return imageView
    }()
    
    lazy var acceptButton : UIButton = {
        let button = UIButton()
        
        button.setTitle("Принять", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        
        return button
    }()
    
    lazy var phoneButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: "phone"), for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(handleCall), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleAccept() {
        if let token = UserDefaults.standard.string(forKey: "token"), let id = driverID, let type = orderType, let orderID = orderID {
            UIView.animate(withDuration: 0.3, animations: {
                self.acceptButton.backgroundColor = .blue
                self.acceptButton.setTitleColor(.white, for: .normal)
                self.acceptButton.setTitle("Принято", for: .normal)
            })
            isAccepted = true
            acceptButton.isEnabled = false
            
            let body : Parameters = [
                "token" : token,
                "driver_id" : id,
                "parent_type" : type,
                "parent_id" : orderID
            ]
            
            Alamofire.request(Constant.api.user_accept, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        print("User accept: \(json)")
                        
                        if json["statusCode "].intValue == Constant.statusCode.success {
                            self.delegate?.changeCancelButton()
                        }
                    }
                }
            })
        }
    }
    
    @objc func handleCall() {
        phone = phone!.contains("+") ? phone : "+\(phone!)"
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        textLabel?.textColor = .blue
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        
        textLabel?.frame = CGRect(x: 105, y: textLabel!.frame.origin.y - 40, width: textLabel!.frame.width + 50, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 105, y: detailTextLabel!.frame.origin.y - 25, width: detailTextLabel!.frame.width + 50, height: detailTextLabel!.frame.height)
        
        addSubview(profileImage)
        addSubview(acceptButton)
        addSubview(phoneButton)
        
        profileImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        
        acceptButton.snp.makeConstraints { (make) in
            make.top.equalTo(detailTextLabel!.snp.bottom).offset(5)
            make.left.equalTo(detailTextLabel!)
            make.right.equalTo(-80)
            make.height.equalTo(25)
        }
        
        phoneButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        if isAccepted {
            self.acceptButton.backgroundColor = .white
            self.acceptButton.setTitleColor(.blue, for: .normal)
            self.acceptButton.setTitle("Принять", for: .normal)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
