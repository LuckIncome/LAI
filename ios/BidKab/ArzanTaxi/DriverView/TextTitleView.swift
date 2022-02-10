//
//  TextTitleView.swift
//  BidKab
//
//  Created by Eldor Makkambayev on 8/14/19.
//  Copyright © 2019 Nursultan Zhiyembay. All rights reserved.
//

import Foundation
import UIKit
class TextTitleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.width.height.centerX.centerY.equalToSuperview()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = .black
        tl.font = UIFont.boldSystemFont(ofSize: 20)
        return tl
    }()
}
