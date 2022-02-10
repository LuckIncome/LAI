//
//  DriverIntercityController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/18/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DriverIntercityController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DriverIntercityViewControllerDelegate {
    
    var navTitle : String?
    let ordersCellID = "ordersCellID"
    let createCellID = "createCellID"
    let myOrdersCellID = "myOrdersCellID"
    
//    let backgroundImage : UIImageView = {
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_background"))
//        
//        return imageView
//    }()
    
    lazy var orderBar : OrderBar = {
        let ob = OrderBar()
        ob.driverIntercityController = self
        
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
    
    func handleOrderButton(aPoint: String, bPoint: String, price: String, text : String) {
        indicator.showSuccess(withStatus: "Success")
        if let token = UserDefaults.standard.string(forKey: "token") {
            
            let body : Parameters = [
                "token" : token,
                "type": "intercity_autos",
                "from" : aPoint,
                "to" : bPoint,
                "price" : price,
                "description" : text
            ]
            
            Alamofire.request(Constant.api.driver_create_intercity, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        print("Drive create intercity: \(json)")
                        
                        if json["statusCode "].intValue == Constant.statusCode.success {
                            indicator.dismiss(withDelay: 1.5, completion: {
                                if let slideMenu = self.revealViewController() {
                                    let navController = UINavigationController(rootViewController: DriverIntercityController())
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
            make.top.equalToSuperview().offset(UIViewController.heightNavBar + 35)
            make.left.right.equalToSuperview().offset(4)
            make.height.equalTo(55)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(orderBar.snp.bottom)
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
        setNavigationBarTransparent(title: String.localizedString(key: "intercity"), shadowImage: false)
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        
        collectionView.register(DriverOrdersCell.self, forCellWithReuseIdentifier: ordersCellID)
        collectionView.register(DriverAutoInterCell.self, forCellWithReuseIdentifier: createCellID)
        collectionView.register(DriverMyOrdersCell.self, forCellWithReuseIdentifier: myOrdersCellID)
        
        view.backgroundColor = .white
        
        setupViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        
        if indexPath.item == 0 {
            let ordersCell = collectionView.dequeueReusableCell(withReuseIdentifier: ordersCellID, for: indexPath) as! DriverOrdersCell
            cell = ordersCell
        } else if indexPath.item == 1 {
            let autoCell = collectionView.dequeueReusableCell(withReuseIdentifier: createCellID, for: indexPath) as! DriverAutoInterCell
            autoCell.delegate = self
            
            cell = autoCell
        } else {
            let myAutoCell = collectionView.dequeueReusableCell(withReuseIdentifier: myOrdersCellID, for: indexPath) as! DriverMyOrdersCell
            cell = myAutoCell
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
