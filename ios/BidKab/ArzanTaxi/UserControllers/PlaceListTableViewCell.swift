//
//  PlaceListTableViewCell.swift
//  BidKab
//
//  Created by Eldor Makkambayev on 7/29/19.
//  Copyright © 2019 Nursultan Zhiyembay. All rights reserved.
//

import UIKit

class PlaceListTableViewCell: UITableViewCell {
    
    private func setupViews() -> Void {
        
        contentView.addSubview(separateView)
        separateView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        contentView.addSubview(placeIcon)
        placeIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
//        textLabel?.snp.makeConstraints({ (make) in
//            make.right.equalTo(placeIcon.snp.left).offset(-8)
//        })
    }
    
    lazy var separateView: UIView = {
        let sv = UIView()
        sv.backgroundColor = .blue
        return sv
    }()
    
    lazy var placeIcon: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        
        return icon
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
