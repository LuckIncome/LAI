//
//  MotoViewController.swift
//  ArzanTaxi
//
//  Created by MAC on 11.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MotoViewControllerDelegate {

    var navTitle : String?
    let orderIntercityCellID = "orderIntercityCellID"
    let freeAutoCellID = "freeAutoCellID"
    let myIntercityOrdersCellID = "myIntercityOrdersCellID"
    
//    let backgroundImage : UIImageView = {
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_background"))
//        
//        return imageView
//    }()
    
    lazy var orderBar : OrderBar = {
        let ob = OrderBar()
        ob.motoViewController = self
        return ob
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        return cv
    }()
    
    func scrollToItem(at index : Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    func handleOrderButton(aPoint: String, bPoint: String, price: String, date : String, text : String) {
        indicator.showSuccess(withStatus: "Success")
        if let token = UserDefaults.standard.string(forKey: "token") {
            
            let body : Parameters = [
                "token" : token,
                "from" : aPoint,
                "to" : bPoint,
                "price" : price,
                "description" : text,
                "type" : "moto_orders"
            ]
            
            let indexPath = IndexPath(item: 3, section: 0)
            
            Alamofire.request(Constant.api.create_moto, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        print("Create moto: \(json)")
                        
                        if json["statusCode "].intValue == Constant.statusCode.success {
                            indicator.dismiss(withDelay: 1.5, completion: {
                                if let slideMenu = self.revealViewController() {
                                    let navController = UINavigationController(rootViewController: MotoViewController())
                                    slideMenu.pushFrontViewController(navController, animated: true)
                                }
                            })
                        }
                    }
                case .failure(let error):
                    print(error)
                    return
                }
            }
        }
    }
    
    func setupViews() {
//        view.addSubview(backgroundImage)
        view.addSubview(orderBar)
        view.addSubview(collectionView)
        
//        backgroundImage.snp.makeConstraints { (make) in
//            make.top.left.right.bottom.equalToSuperview()
//        }
        
        orderBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIViewController.heightNavBar + 55)
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(orderBar.snp.bottom).offset(4)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var langImage = UIImage()
//        if UserDefaults.standard.string(forKey: "language") == "kz" {
//            langImage = UIImage(named: "kazakh")!
//        } else if UserDefaults.standard.string(forKey: "language") == "ru" {
//            langImage = UIImage(named: "russian")!
//        } else if UserDefaults.standard.string(forKey: "language") == "en" {
//            langImage = UIImage(named: "english")!
//        }
//        
//        langImage = langImage.withRenderingMode(.alwaysOriginal)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: langImage, style: .plain, target: self, action: #selector(changeLanguage))
        
        setNavigationBarTransparent(title: String.localizedString(key: "moto"), shadowImage: false)
//        navigationItem.title =
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        
        collectionView.register(OrderMotoCell.self, forCellWithReuseIdentifier: orderIntercityCellID)
        collectionView.register(MotoFreeAutoCell.self, forCellWithReuseIdentifier: freeAutoCellID)
        collectionView.register(MotoMyOrderCell.self, forCellWithReuseIdentifier: myIntercityOrdersCellID)
        
        view.backgroundColor = .white
        
        setupViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if indexPath.item == 0 {
            let orderIntercityCell = collectionView.dequeueReusableCell(withReuseIdentifier: orderIntercityCellID, for: indexPath) as! OrderMotoCell
            
            orderIntercityCell.delegate = self
            orderIntercityCell.aPointText = ""
            orderIntercityCell.bPointText = ""
            //orderIntercityCell.dateText = ""
            orderIntercityCell.priceText = ""
            //orderIntercityCell.noteText = ""
            
            cell = orderIntercityCell
        } else if indexPath.item == 1 {
            let myOrderCell = collectionView.dequeueReusableCell(withReuseIdentifier: freeAutoCellID, for: indexPath) as! MotoFreeAutoCell
            cell = myOrderCell
        } else {
            let myOrderCell = collectionView.dequeueReusableCell(withReuseIdentifier: myIntercityOrdersCellID, for: indexPath) as! MotoMyOrderCell
            cell = myOrderCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
