//
//  ToyTaxiViewController.swift
//  ArzanTaxi
//
//  Created by MAC on 12.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ToyTaxiViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ToyTaxiViewControllerDelegate {

    var navTitle : String?
    
    let orderCellID = "orderCellID"
    let freeAutoCellID = "freeAutoCellID"
    let myOrdersCellID = "myOrdersCellID"

//    let backgroundImage : UIImageView = {
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_background"))
//        
//        return imageView
//    }()
    
    lazy var orderBar : OrderBar = {
        let ob = OrderBar()
        
        ob.toyTaxiController = self
        
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
    
    func handleOrderButton(price: String, date : String, text : String) {
        indicator.showSuccess(withStatus: "Success")
        if let token = UserDefaults.standard.string(forKey: "token") {
            let body : Parameters = [
                "token" : token,
                "type": "toy_orders",
                "out_date" : date,
                "price" : price,
                "description" : text,
                ]
            
            Alamofire.request(Constant.api.create_toy, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        if json["statusCode "].intValue == Constant.statusCode.success {
                            indicator.dismiss(withDelay: 1.5, completion: {
                                if let slideMenu = self.revealViewController() {
                                    let navController = UINavigationController(rootViewController: ToyTaxiViewController())
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
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(orderBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = String.localizedString(key: "toi_taxi")
        view.backgroundColor = .white
        
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
        
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        
        collectionView.register(OrderToyCell.self, forCellWithReuseIdentifier: orderCellID)
        collectionView.register(ToyFreeAutoCell.self, forCellWithReuseIdentifier: freeAutoCellID)
        collectionView.register(ToyMyOrderCell.self, forCellWithReuseIdentifier: myOrdersCellID)
        
        setupViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if indexPath.item == 0 {
            let orderCell = collectionView.dequeueReusableCell(withReuseIdentifier: orderCellID, for: indexPath) as! OrderToyCell
            orderCell.priceText = ""
            orderCell.dateText = ""
            orderCell.noteText = ""
            orderCell.delegate = self
            
            cell = orderCell
        } else if indexPath.item == 1 {
            let freeAutoCell = collectionView.dequeueReusableCell(withReuseIdentifier: freeAutoCellID, for: indexPath) as! ToyFreeAutoCell
            cell = freeAutoCell
        } else if indexPath.item == 2 {
            let myOrderCell = collectionView.dequeueReusableCell(withReuseIdentifier: myOrdersCellID, for: indexPath) as! ToyMyOrderCell
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
