//
//  CargoOrderCell.swift
//  ArzanTaxi
//
//  Created by MAC on 11.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit

class CargoOrderCell: UITableViewCell {
    var delegate : HistoryViewControllerDelegate?
    var option: OptionDelegate?
    let cellID = "cell"
    var images = [String]()
    var id = Int()
    
    var date = Helper.createOrderLabel(image: #imageLiteral(resourceName: "calendar").withRenderingMode(.alwaysTemplate), text: "")
    var aPoint = Helper.createOrderLabel(image: #imageLiteral(resourceName: "pointa"), text: "")
    var bPoint = Helper.createOrderLabel(image: #imageLiteral(resourceName: "pointb"), text: "")
    var price = Helper.createOrderLabel(image: #imageLiteral(resourceName: "price").withRenderingMode(.alwaysTemplate), text: "")
    
    var from : String?
    var to : String?
    var fromLat : Double?
    var fromLon : Double?
    var toLat : Double?
    var toLon : Double?
    var priceValue : Int?
    var getPassenger : Int?
    var passengersCount : Int?
    var bonus : Int?
    var desc : String?
    
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
        l.numberOfLines = 0
        l.textColor = .blue
        return l
    }()
    
    lazy var optionButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "option"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleOptionButton), for: .touchUpInside)
        return button
    }()
//
//    lazy var splitView: UIView = {
//        let sv = UIView()
//        sv.backgroundColor = .lightGray
//
//        return sv
//    }()
    
    @objc
    func handleOptionButton() {
//        if let from = from, let to = to, let fromLat = fromLat, let fromLon = fromLon, let toLat = toLat, let toLon = toLon, let priceValue = priceValue, let getPassenger = getPassenger, let passengersCount = passengersCount, let bonus = bonus, let description = desc {
//            delegate?.optionButton(from: from, to: to, price: priceValue, fromLat: fromLat, fromLon: fromLon, toLat: toLat, toLon: toLon, getPassenger: getPassenger, passengersCount: passengersCount, bonus: bonus, description: description)
//        }
        option?.optionButton(id: id)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: cellID)
        setupViews()
    }
    
    func setupViews() {
        contentView.isUserInteractionEnabled = false
        
        addSubview(date)
        addSubview(aPoint)
        addSubview(bPoint)
        addSubview(price)
        addSubview(descrip)
//        addSubview(splitView)
        addSubview(collectionView)
        addSubview(optionButton)
        
        date.topAnchor.constraint(equalTo: topAnchor).isActive = true
        date.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        date.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        date.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        
        aPoint.topAnchor.constraint(equalTo: date.bottomAnchor).isActive = true
        aPoint.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        aPoint.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        aPoint.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        
        bPoint.topAnchor.constraint(equalTo: aPoint.bottomAnchor).isActive = true
        bPoint.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bPoint.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bPoint.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        
        price.topAnchor.constraint(equalTo: bPoint.bottomAnchor).isActive = true
        price.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        price.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        price.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        
        optionButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        optionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        optionButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        optionButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(descrip.snp.bottom).offset(2)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.size.equalTo(65)
            make.bottom.equalTo(-10)
        }
        
//        splitView.snp.makeConstraints { (make) in
//            make.left.equalTo(self.snp.centerX).offset(10)
//            make.width.equalTo(0.5)
//            make.top.equalTo(date).offset(4)
//            make.bottom.equalTo(price).offset(-4)
//        }
//
        descrip.snp.makeConstraints { (make) in
            make.top.equalTo(price.snp.bottom).offset(2)
            make.left.equalTo(price).offset(20)
            make.right.equalTo(optionButton.snp.left).offset(-4)
        }

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CargoOrderCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
