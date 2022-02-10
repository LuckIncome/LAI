//
//  OrderBarCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/14/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit

class OrderBarCell : UICollectionViewCell {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Заказать"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    lazy var backView: UIView = {
        let bv = UIView()
    
        return bv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 242)
        
        addSubview(backView)
        backView.addSubview(titleLabel)

        backView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-20)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.blue.cgColor
        backView.layer.cornerRadius = 15
        
        backView.layer.shadowColor = UIColor.gray.cgColor
        backView.backgroundColor = .white
        backView.layer.shadowOpacity = 0.3
//        backView.contentMode = .center
//        backView.layer.shadowPath = C
        backView.layer.shadowOffset = .init(width: 0, height: 10)
//        backView.layer.shadowRadius = 2
        


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
