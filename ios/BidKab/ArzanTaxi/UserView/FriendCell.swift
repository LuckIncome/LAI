//
//  FriendCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/13/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit

class FriendCell : UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.font = UIFont.systemFont(ofSize: 20)
        textLabel?.textColor = .blue
        detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        
        textLabel?.frame = CGRect(x: 105, y: textLabel!.frame.origin.y - 2.5, width: textLabel!.frame.width + 50, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 105, y: detailTextLabel!.frame.origin.y + 2.5, width: detailTextLabel!.frame.width + 50, height: detailTextLabel!.frame.height)
    }
    
    let profileImage : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_image"))
        
        imageView.layer.cornerRadius = 35
        
        return imageView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "delete").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont.systemFont(ofSize: 20)
        textLabel?.textColor = .blue
        detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        
        textLabel?.frame = CGRect(x: 105, y: textLabel!.frame.origin.y - 2.5, width: textLabel!.frame.width + 50, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 105, y: detailTextLabel!.frame.origin.y + 2.5, width: detailTextLabel!.frame.width + 50, height: detailTextLabel!.frame.height)
        
        addSubview(profileImage)
        addSubview(deleteButton)
        
        profileImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(33)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
