//
//  HomeCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/18/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMaps
import Kingfisher

protocol MovableToMap {
    func moveToMap(_ pointA: CLLocation, _ pointB: CLLocation)
}

class HomeCell : UITableViewCell {
    
    var priceLabelTopConstraint: Constraint?
    var disabledIconTopConstraint: Constraint?
    var delegate: MovableToMap!
    
    var order = Order() {
        didSet {
            passengersCountLabel.text = "\(String(describing: order.count_passenger!))"
            nameLabel.text = order.passenger!.name!
            if order.passenger!.avatar != "no image" {// URL(string: avatar)
                profileImage.kf.setImage(with: order.passenger!.avatar?.serverUrlString.url, placeholder: UIImage(named: "profile_image-1"), options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                profileImage.image = UIImage(named: "profile_image-1")
            }
            var genderLabelText = ""
            var stateLabelText = ""
            var offset: CGFloat = 0
            var disabledOffset: CGFloat = 0
            disabledIcon.isHidden = !order.isInvalid!
            if order.isWoman! {
                genderLabelText = String.localizedString(key: "woman")
                offset += 20
                disabledOffset += 20
            }
            if order.isInvalid! {
                stateLabelText = String.localizedString(key: "invalid")
                offset += 20
            }
            if let getPassenger = order.get_passenger {
                let color: UIColor = getPassenger == 0 ? .red : .blue
                view.backgroundColor = color
            }
            aPointLabel.text = order.from!
            bPointLabel.text = order.to!
            var price = ""
            if order.bonus! == 1 {
                let doublePrice = Double(order.price!)
                price = "\(doublePrice.getRemainder()) ₸ + \(doublePrice.getBonus()) ₸ bonus"
            } else {
                price = "\(order.price!) ₸"
            }
            genderLabel.text = genderLabelText
            stateLabel.text = stateLabelText
            disabledIconTopConstraint?.update(offset: disabledOffset)
            priceLabelTopConstraint?.update(offset: offset)
            priceLabel.text = price
        }
    }
    
    let separateView: UIView = {
        let separate = UIView()
        separate.backgroundColor = .gray
        return separate
    }()
    
    let view : UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 30
        return view
    }()
    
    let profileImage : UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "profile_image-1")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()
    
    let passengersCountLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 29, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var disabledIcon: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "product"))
        return iv
    }()
    
//    lazy var womanIcon: UIImageView = {
//        let iv = UIImageView(image: #imageLiteral(resourceName: "woman"))
//        return iv
//    }()

    lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let orderTimeLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let aPointLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let bPointLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let compassImage : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "compass"))
        imageView.isHidden = true
        return imageView
    }()
    
    let distanceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()

    lazy var clientInMapButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "pointb").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .blue
        button.addTarget(self, action: #selector(clientInMapButtonPressed), for: .touchUpInside)
        return button
    }()

    @objc func clientInMapButtonPressed(){
        let pointA = CLLocation(latitude: Double(order.from_lat!)!, longitude: Double(order.from_lon!)!)
        let pointB = CLLocation(latitude: Double(order.to_lat!)!, longitude: Double(order.to_lon!)!)
        delegate.moveToMap(pointA, pointB)
    }
    
    func setupViews() {
        addSubview(view)
        view.addSubview(passengersCountLabel)
        view.addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(genderLabel)
        addSubview(stateLabel)
        addSubview(orderTimeLabel)
        addSubview(aPointLabel)
        addSubview(bPointLabel)
        addSubview(priceLabel)
        addSubview(compassImage)
        addSubview(distanceLabel)
        addSubview(disabledIcon)
//        addSubview(womanIcon)
        addSubview(clientInMapButton)
        addSubview(separateView)

        view.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        passengersCountLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(5)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        
//        womanIcon.snp.makeConstraints { (make) in
//            make.top.equalTo(bPointLabel.snp.bottom).offset(3)
//            make.left.equalTo(aPointLabel.snp.left)
//            make.width.height.equalTo(15)
//        }

        genderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bPointLabel.snp.bottom).offset(3)
            make.left.equalTo(aPointLabel.snp.left)
            make.right.equalTo(aPointLabel.snp.right)
        }
        
        disabledIcon.snp.makeConstraints { (make) in
            disabledIconTopConstraint =     make.top.equalTo(bPointLabel.snp.bottom).offset(3).constraint
            make.left.equalTo(genderLabel.snp.left)
            make.height.width.equalTo(15)
        }
        
        stateLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(disabledIcon.snp.centerY)
            make.left.equalTo(disabledIcon.snp.right).offset(3)
            make.right.equalTo(genderLabel.snp.right)
        }
        
        orderTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        
        aPointLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.right).offset(20)
            make.centerY.equalTo(view).offset(-9)
            make.right.equalTo(-15)
        }
        
        bPointLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.right).offset(20)
            make.centerY.equalTo(view).offset(9)
            make.right.equalTo(-15)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            priceLabelTopConstraint = make.top.equalTo(nameLabel).constraint
            make.left.equalTo(view.snp.right).offset(20)
        }
        
        compassImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceLabel)
            make.left.equalTo(priceLabel.snp.right).offset(10)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }
        
        distanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel)
            make.left.equalTo(contentView.snp.centerX)
        }

        clientInMapButton.snp.makeConstraints { (clientInMapButton) in
            clientInMapButton.right.equalToSuperview().offset(-15)
            clientInMapButton.centerY.equalTo(nameLabel)
            clientInMapButton.width.height.equalTo(50)
        }
        
        separateView.snp.makeConstraints { (separate) in
            separate.left.right.bottom.equalToSuperview()
            separate.height.equalTo(1)
        }
        
        profileImage.snp.makeConstraints { (image) in
            image.left.right.top.bottom.equalToSuperview()
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
