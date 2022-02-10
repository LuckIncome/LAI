//
//  DriverOrdersTableCell.swift
//  ArzanTaxi
//
//  Created by MAC on 15.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class DriverOrdersTableCell: UITableViewCell {

    var date = createOrderLabel(with: #imageLiteral(resourceName: "calendar"), placeholder: "")
    var aPoint = createOrderLabel(with: #imageLiteral(resourceName: "pointa"), placeholder: "")
    var bPoint = createOrderLabel(with: #imageLiteral(resourceName: "pointb"), placeholder: "")
    var price = createOrderLabel(with: #imageLiteral(resourceName: "price"), placeholder: "")
    var phone = ""
    let cellID = "cell"
    var images = [String]()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    let descrip: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .blue
        l.numberOfLines = 0
        
        return l
    }()
    
//    lazy var splitView: UIView = {
//        let split = UIView()
//        split.backgroundColor = .lightGray
//
//        return split
//    }()
    
    lazy var phoneButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: "phone"), for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCall), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleCall() {
        print(phone)
        phone = phone.contains("+") ? phone : "+\(phone)"
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: cellID)
        
        addSubview(date)
//        addSubview(aPoint)
//        addSubview(bPoint)
        addSubview(price)
        addSubview(descrip)
        addSubview(collectionView)
        addSubview(phoneButton)
//        addSubview(splitView)
        
        date.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalTo(-50)
            make.height.equalTo(27.5)
        }
        
//        aPoint.snp.makeConstraints { (make) in
//            make.top.equalTo(date.snp.bottom)
//            make.left.equalToSuperview()
//            make.right.equalTo(-50)
//            make.height.equalTo(27.5)
//        }
//
//        bPoint.snp.makeConstraints { (make) in
//            make.top.equalTo(aPoint.snp.bottom)
//            make.left.equalToSuperview()
//            make.right.equalTo(-50)
//            make.height.equalTo(27.5)
//        }
        
        price.snp.makeConstraints { (make) in
            make.top.equalTo(date.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalTo(-50)
            make.height.equalTo(27.5)
        }
        
        phoneButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        phoneButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        phoneButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        phoneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
//        splitView.snp.makeConstraints { (make) in
//            make.top.equalTo(date).offset(2)
//            make.bottom.equalTo(price).offset(-2)
//            make.width.equalTo(0.5)
//            make.left.equalTo(self.snp.centerX).offset(10)
//        }
        
        descrip.snp.makeConstraints { (make) in
            make.top.equalTo(price.snp.bottom).offset(2)
            make.left.equalTo(price).offset(20)
            make.right.equalTo(phoneButton.snp.left).offset(-8)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(descrip.snp.bottom).offset(4)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.size.equalTo(65)
            make.bottom.equalTo(-12)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DriverOrdersTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageCollectionCell
        let url = URL(string: "\(Constant.api.prefixForImage + images[indexPath.row])")
        cell.orderImage.kf.setImage(with: url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
