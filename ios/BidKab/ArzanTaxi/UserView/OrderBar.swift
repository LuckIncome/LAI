//
//  OrderBar.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/14/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class OrderBar : UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellID = "orderBarCellID"
    let orderTitles = [String.localizedString(key: "user_orders"), String.localizedString(key: "free_auto"), String.localizedString(key: "user_my_orders")]
    let driverOrderTitles = [String.localizedString(key: "orders"), String.localizedString(key: "new_tex"), String.localizedString(key: "my_tex")]
    let motoTitles = [String.localizedString(key: "orders"), String.localizedString(key: "free_moto"), String.localizedString(key: "user_my_orders")]
    let techTitles = [String.localizedString(key: "orders"), String.localizedString(key: "free_tech"), String.localizedString(key: "user_my_orders")]
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.isScrollEnabled = false
        return cv
    }()
    
    var barLeftAnchor : NSLayoutConstraint?
    var cargoController : CargoViewController?
    var motoViewController : MotoViewController?
    var intercityController : IntercityViewController?
    var specialController : SpecialViewController?
    
    var driverIntercityController : DriverIntercityController?
    var driverCargoController : DriverCargoViewController?
    var driverMotoController : DriverMotoViewController?
    var driverToyController : DriverToyTaxiViewController?
    var driverSpecialController : DriverSpecialViewController?
    var toyTaxiController : ToyTaxiViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.layer.shadowOpacity = 0.6
//        self.layer.shadowOffset = .zero
        
        collectionView.register(OrderBarCell.self, forCellWithReuseIdentifier: cellID)
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
//        let orderBarView = UIView()
//        orderBarView.backgroundColor = .blue
//        orderBarView.translatesAutoresizingMaskIntoConstraints = false
        
//        addSubview(orderBarView)
//
//        barLeftAnchor = orderBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
//        barLeftAnchor?.isActive = true
//
//        orderBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        orderBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
//        orderBarView.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    func scrollToItem(at index : Int) {
        let x = CGFloat(index) * frame.width / 3
        barLeftAnchor?.constant = x
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func selectToCell(at index: IndexPath) -> Void {
        let currentCell = collectionView.cellForItem(at: index) as! OrderBarCell
        for i in 0..<3 {
            let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as! OrderBarCell
            cell.backView.backgroundColor = .white
            cell.titleLabel.textColor = .blue
        }
        currentCell.backView.backgroundColor = .blue
        currentCell.titleLabel.textColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        scrollToItem(at: indexPath.item)
        selectToCell(at: indexPath)

        if cargoController != nil {
            cargoController?.scrollToItem(at: indexPath.item)
        } else if motoViewController != nil {
            motoViewController?.scrollToItem(at: indexPath.item)
        } else if specialController != nil {
            specialController?.scrollToItem(at: indexPath.item)
        } else if toyTaxiController != nil {
            toyTaxiController?.scrollToItem(at: indexPath.item)
        } else if intercityController != nil {
            intercityController?.scrollToItem(at: indexPath.item)
        } else if driverIntercityController != nil {
            driverIntercityController?.scrollToItem(at: indexPath.item)
        } else if driverToyController != nil {
            driverToyController?.scrollToItem(at: indexPath.item)
        } else if driverSpecialController != nil {
            driverSpecialController?.scrollToItem(at: indexPath.item)
        } else if driverMotoController != nil {
            driverMotoController?.scrollToItem(at: indexPath.item)
        } else {
            driverCargoController?.scrollToItem(at: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! OrderBarCell
        
        if indexPath.item == 0 {
            cell.backView.backgroundColor = .blue
            cell.titleLabel.textColor = .white
        }
        
        if driverIntercityController == nil && driverCargoController == nil && driverMotoController == nil && driverToyController == nil && driverSpecialController == nil {
            cell.titleLabel.text = orderTitles[indexPath.item]
        } else if driverSpecialController != nil {
            cell.titleLabel.text = techTitles[indexPath.item]
        } else if driverMotoController != nil {
            cell.titleLabel.text = motoTitles[indexPath.item]
        } else {
            cell.titleLabel.text = driverOrderTitles[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let currentCell = collectionView.cellForItem(at: indexPath) as! OrderBarCell
//
//        currentCell.backView.backgroundColor = .white
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (frame.width / 3) - 1, height: frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
