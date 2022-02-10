//
//  HelpCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/16/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit

class HelpCell : UITableViewCell {
    
    let title : UILabel = {
        let label = UILabel()
        
        label.text = "Договор №151 между пользователями сервиса мобильного приложения «Arzan Taksi»"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .gray
        
        return label
    }()
    
    let content : UILabel = {
        let label = UILabel()
        
        label.text = """
        sdkjansndk
        """
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(title)
        addSubview(content)
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        content.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
