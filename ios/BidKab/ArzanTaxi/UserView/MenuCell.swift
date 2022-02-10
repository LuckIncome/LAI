//
//  MenuCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/9/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit

class MenuCell : UITableViewCell {
    
    var delegate : LeftMenuControllerDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let iconImage : UIImageView = {
        let iv = UIImageView()
        
        return iv
    }()
    
    lazy var driverModeSwitcher : UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .blue
        switcher.tintColor = .red
        switcher.backgroundColor = .red
        switcher.layer.cornerRadius = 16
        switcher.addTarget(self, action: #selector(handleDriverMode(sender:)), for: .valueChanged)
        return switcher
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        if UserDefaults.standard.bool(forKey: "driverWas") {
            if UserDefaults.standard.bool(forKey: "isUserInDriverMode") {
                driverModeSwitcher.isOn = true
            } else {
                driverModeSwitcher.isOn = false
            }
        } else {
            driverModeSwitcher.isOn = false
        }
        
        backgroundColor = .clear
        textLabel?.textColor = .darkGray
        detailTextLabel?.textColor = .darkGray
        textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 10)
        selectionStyle = .none
        
        setupViews()
    }
    
    @objc func handleDriverMode(sender : UISwitch) {
        if UserDefaults.standard.bool(forKey: "driverWas") {
            UserDefaults.standard.set(sender.isOn, forKey: "isUserInDriverMode")
        }

        delegate?.switchToDriverMode(isOn: sender.isOn, completion: {isUserExist in
            if !isUserExist {
                driverModeSwitcher.isOn = false
                handleDriverMode(sender: driverModeSwitcher)
            }
        })
    }
    
    func setDriverModeSwitcher() {
        addSubview(driverModeSwitcher)
        
        driverModeSwitcher.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        })
        
        driverModeSwitcher.transform = CGAffineTransform(scaleX: 0.80, y: 0.80)
    }
    
    func setupViews() {
        addSubview(iconImage)
        
        iconImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
