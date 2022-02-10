//
//  DriverCityTitleView.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 8/13/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class DriverCityTitleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        addSubview(timerLabel)
        addSubview(statusLabel)
        addSubview(statusSwitch)
        
        timerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.bottom.equalTo(snp.bottom)
            make.width.equalTo(100)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timerLabel.snp.right).offset(10)
            make.top.equalTo(snp.top)
            make.bottom.equalTo(snp.bottom)
            make.width.equalTo(80)
        }
        statusSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        statusSwitch.snp.makeConstraints { (make) in
            make.centerY.equalTo(snp.centerY)
            make.left.equalTo(statusLabel.snp.right).offset(5)
            make.right.equalTo(snp.right)
        }
    }
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        
        
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    lazy var statusSwitch: UISwitch = {
        let ss = UISwitch()
        ss.isOn = true
        
        return ss
    }()
}
