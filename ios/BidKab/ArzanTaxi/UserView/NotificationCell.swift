//
//  NotificationCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/16/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit

class NotificationCell : UITableViewCell {
    
    let title : UILabel = {
        let label = UILabel()
        
        label.text = "Sed ut perspiciatis, unde omnis iste natus error"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        
        return label
    }()
    
    let dateIcon : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "notification_calendar"))
        
        return imageView
    }()
    
    let date : UILabel = {
        let label = UILabel()
        
        label.text = "12.11.2017"
        label.font = UIFont.systemFont(ofSize: 10)
        
        return label
    }()
    
    let content : UILabel = {
        let label = UILabel()
        
        label.text = "Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit, aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos, qui ratione voluptatem sequi nesciunt, neque porro quisquam est, qui dolorem ipsum, quia dolor sit, amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt, ut labore et dolore magnam aliquam quaerat voluptatem."
        label.numberOfLines = 12
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    func setupViews() {
        addSubview(title)
        addSubview(dateIcon)
        addSubview(date)
        addSubview(content)
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        dateIcon.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.left.equalTo(15)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }
        
        date.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateIcon)
            make.left.equalTo(dateIcon.snp.right).offset(5)
        }
        
        content.snp.makeConstraints { (make) in
            make.top.equalTo(dateIcon.snp.bottom).offset(3)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
