//
//  CostView.swift
//  BidKab
//
//  Created by Eldor Makkambayev on 8/16/19.
//  Copyright © 2019 Nursultan Zhiyembay. All rights reserved.
//

import UIKit

class CostView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(costLabel)
        costLabel.snp.makeConstraints { (make) in
            make.center.height.width.equalToSuperview()
        }
        
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.masksToBounds = false
    }
    
    lazy var costLabel: UILabel = {
        let cl = UILabel()
        cl.textColor = .blue
        cl.textAlignment = .center
        cl.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cl
    }()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
