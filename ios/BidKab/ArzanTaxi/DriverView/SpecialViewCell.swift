//
//  SpecialViewCell.swift
//  ArzanTaxi
//
//  Created by Mukhamedali Tolegen on 24.02.18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class SpecialViewCell : UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        textLabel?.textColor = .blue
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        
        textLabel?.frame = CGRect(x: 105, y: textLabel!.frame.origin.y, width: textLabel!.frame.width + 50, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 105, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width + 50, height: detailTextLabel!.frame.height)
    }
    
    let profileImage : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_image"))
        
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 11)
        
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        textLabel?.textColor = .blue
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        
        textLabel?.frame = CGRect(x: 105, y: textLabel!.frame.origin.y - 40, width: textLabel!.frame.width + 50, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 105, y: detailTextLabel!.frame.origin.y - 25, width: detailTextLabel!.frame.width + 50, height: detailTextLabel!.frame.height)
        
        addSubview(profileImage)
        addSubview(descriptionLabel)
        
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
