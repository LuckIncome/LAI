//
//  OrderAlertView.swift
//  BidKab
//
//  Created by Eldor Makkambayev on 8/21/19.
//  Copyright © 2019 Nursultan Zhiyembay. All rights reserved.
//

import Foundation

class OrderAlertView: UIView {
    
    init(title: String) {
        super.init(frame: .zero)
        self.title.text = title
        
        setupView()
    }

    lazy var title: UILabel = {
        let title = UILabel()
        title.text = "Are you shure?"
        title.font = UIFont.systemFont(ofSize: 22)
        title.textColor = .blue
        
        return title
    }()
    
    lazy var okButton: UIButton = {
        let okbtn = UIButton ()
        okbtn.backgroundColor = .blue
        okbtn.layer.cornerRadius = 15
        okbtn.tintColor = .white
        
        return okbtn
    }()
    
    lazy var cancelButton: UIButton = {
        let ccbtn = UIButton()
        ccbtn.tintColor = .red
        ccbtn.layer.cornerRadius = 15
        ccbtn.layer.borderColor = UIColor.red.cgColor
        ccbtn.layer.borderWidth = 1
        
        return ccbtn
    }()
    
    private func setupView() -> Void {
        backgroundColor = .white

        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        
        addSubview(okButton)
        okButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            make.width.equalToSuperview().multipliedBy(0.33)
            make.right.equalTo(snp.centerX).offset(-5)
        }
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            make.width.equalToSuperview().multipliedBy(0.33)
            make.left.equalTo(snp.centerX).offset(5)
        }

    }
    
    func show() -> Void {
        UIView.animate(withDuration: 0.2) {
            self.snp.remakeConstraints { (make) in
                make.top.equalTo(self.superview!.snp.top).offset(66)
                make.height.equalToSuperview().multipliedBy(0.2)
                make.width.equalToSuperview()
            }
            self.superview!.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
