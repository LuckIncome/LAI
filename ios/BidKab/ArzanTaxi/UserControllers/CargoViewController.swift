//
//  CargoViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/14/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CargoViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CargoViewControllerDelegate {
    
    var navTitle : String?
    
    let orderCargoCellID = "orderCargoCellID"
    let freeAutoCellID = "freeAutoCellID"
    let myCargoOrdersCellID = "myCargoOrdersCellID"
    
//    let backgroundImage : UIImageView = {
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_background"))
//        
//        return imageView
//    }()
    
    lazy var orderBar : OrderBar = {
        let ob = OrderBar()
        ob.cargoController = self
//        ob.layer.shadowOffset = .zero
//        ob.layer.shadowOpacity = 0.6
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
        cv.tag = 1
        
        return cv
    }()
    
    func scrollToItem(at index : Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    func handleOrderButton(aPoint: String, bPoint: String, price: String, document : Bool, bargain : Bool, text : String, images: [UIImage]) {
        indicator.showSuccess(withStatus: "Success")
        if let token = UserDefaults.standard.string(forKey: "token") {
            let indexPath = IndexPath(item: 3, section: 0)
            
            var isDocumentOn = 0
            var isTorgOn = 0
            
            if document {
                isDocumentOn = 1
            }
            
            if bargain {
                isTorgOn = 1
            }
            
            let body : Parameters = [
                "token" : token,
                "from" : aPoint,
                "to" : bPoint,
                "price" : price,
                "type" : "cargo_orders",
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
                
            }, to: Constant.api.create_cargo, method: .post) { (encodingResult) in
                switch encodingResult{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.data {
                            let json = JSON(value)
                            
                            if json["statusCode "].intValue == Constant.statusCode.success {
                                indicator.dismiss(withDelay: 1.5, completion: {
                                    if let slideMenu = self.revealViewController() {
                                        let navController = UINavigationController(rootViewController: CargoViewController())
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

    func setupCollectionView() {
        
    }
    
    func setupViews() {
//        view.addSubview(backgroundImage)
        view.addSubview(orderBar)
        view.addSubview(collectionView)

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
        
        setNavigationBarTransparent(title: String.localizedString(key: "cargo"), shadowImage: false)
//        navigationItem.title =
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        
        collectionView.register(OrderCargoCell.self, forCellWithReuseIdentifier: orderCargoCellID)
        collectionView.register(FreeAutoCell.self, forCellWithReuseIdentifier: freeAutoCellID)
        collectionView.register(MyOrderCell.self, forCellWithReuseIdentifier: myCargoOrdersCellID)
        
        view.backgroundColor = .white
        
        setupViews()
        setupCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if indexPath.item == 0 {
            let orderCargoCell = collectionView.dequeueReusableCell(withReuseIdentifier: orderCargoCellID, for: indexPath) as! OrderCargoCell
            
            orderCargoCell.delegate = self
            orderCargoCell.aPointText = ""
            orderCargoCell.bPointText = ""
            orderCargoCell.priceText = ""
            
            cell = orderCargoCell
        } else if indexPath.item == 1 {
            let myOrderCell = collectionView.dequeueReusableCell(withReuseIdentifier: freeAutoCellID, for: indexPath) as! FreeAutoCell
            cell = myOrderCell
        } else {
            let myOrderCell = collectionView.dequeueReusableCell(withReuseIdentifier: myCargoOrdersCellID, for: indexPath) as! MyOrderCell
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
