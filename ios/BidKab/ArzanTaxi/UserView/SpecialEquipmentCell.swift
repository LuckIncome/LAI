//
//  SpecialEquipmentCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/14/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class SpecialEquipmentCell : UITableViewCell {
    
    var phoneNumber : String?
    
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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "Тут описание техники, типа 20 тонна или тент еще что то"
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    lazy var phoneButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "phone"), for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(handleCall), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCall() {
        phoneNumber = phoneNumber!.contains("+") ? phoneNumber! : "+\(phoneNumber!)"

        if let url = URL(string: "tel://\(phoneNumber!.removingWhitespaces())"), UIApplication.shared.canOpenURL(url) {
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
        addSubview(descriptionLabel)
        addSubview(phoneButton)
        
        profileImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(detailTextLabel!.snp.bottom).offset(-10)
            make.left.equalTo(detailTextLabel!)
            make.right.equalTo(-60)
            make.bottom.equalToSuperview()
        }
        
        phoneButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
