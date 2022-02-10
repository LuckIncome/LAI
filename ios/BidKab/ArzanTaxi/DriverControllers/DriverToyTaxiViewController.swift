//
//  DriverToyTaxiViewController.swift
//  ArzanTaxi
//
//  Created by MAC on 15.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DriverToyTaxiViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DriverCargoControllerDelegate  {

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
        
        ob.driverToyController = self
        
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
    
    func handleOrderButton(price: String, text : String, images: [UIImage]) {
        indicator.showSuccess(withStatus: "Success")
        if let token = UserDefaults.standard.string(forKey: "token") {
            
            let body : Parameters = [
                "token" : token,
                "type": "toy_autos",
                "price" : price,
                "description" : text
            ]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (index, img) in images.enumerated() {
                    let imageData = UIImageJPEGRepresentation(img, 1)
                    multipartFormData.append(imageData!, withName: "images[\(index)]", fileName: "images[\(index)].jpg", mimeType: "image/jpeg")
                }
                
                for (key, value) in body {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, to: Constant.api.driver_create_intercity, method: .post) { (encodingResult) in
                switch encodingResult{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.data {
                            let json = JSON(value)
                            
                            if json["statusCode "].intValue == Constant.statusCode.success {
                                indicator.dismiss(withDelay: 1.5, completion: {
                                    if let slideMenu = self.revealViewController() {
                                        let navController = UINavigationController(rootViewController: DriverToyTaxiViewController())
                                        slideMenu.pushFrontViewController(navController, animated: true)
                                    }
                                })
                            }
                        } else {
                            let error = (response.result.value  as? [[String : AnyObject]])
                            print(error as Any)
                        }
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
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
        
        setNavigationBarTransparent(title: .localizedString(key: "toi_taxi"), shadowImage: false)
//        navigationItem.title = String.
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        
        collectionView.register(DriverToyOrdersCell.self, forCellWithReuseIdentifier: ordersCellID)
        collectionView.register(DriverToyCreateCell.self, forCellWithReuseIdentifier: createCellID)
        collectionView.register(DriverToyMyAutoCell.self, forCellWithReuseIdentifier: myOrdersCellID)
        
        view.backgroundColor = .white
        
        setupViews()
    }
    
    /*
     
     let orderTitles = [String.localizedString(key: "user_orders"), String.localizedString(key: "free_auto"), String.localizedString(key: "user_my_orders")]
     let motoTitles = [String.localizedString(key: "user_orders"), String.localizedString(key: "free_moto"), String.localizedString(key: "user_my_orders")]
     let techTitles = [String.localizedString(key: "user_orders"), String.localizedString(key: "free_tech"), String.localizedString(key: "user_my_orders")]
     let driverOrderTitles = [String.localizedString(key: "orders"), String.localizedString(key: "myAuto"), String.localizedString(key: "myOrders")]
     */
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if indexPath.item == 0 {
            let ordersCell = collectionView.dequeueReusableCell(withReuseIdentifier: ordersCellID, for: indexPath) as! DriverToyOrdersCell
            
            cell = ordersCell
        } else if indexPath.item == 1 {
            let autoCell = collectionView.dequeueReusableCell(withReuseIdentifier: createCellID, for: indexPath) as! DriverToyCreateCell
            autoCell.delegate = self
            
            cell = autoCell
        } else if indexPath.item == 2 {
            let myAutoCell = collectionView.dequeueReusableCell(withReuseIdentifier: myOrdersCellID, for: indexPath) as! DriverToyMyAutoCell
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
