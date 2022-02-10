//
//  OrderViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 12/25/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import AVFoundation

protocol Orderable {
    func getOrderInformation(order: User)
}

class OrderViewController : UIViewController, Orderable {

    var mapsView : GMSMapView?
    var phone = ""
    var delegate : HomeViewControllerDelegate?
    var cityID : Int?
    var completion: (() -> Void)?
    var polyline: GMSPolyline?
    var id : Int?
    var from : String? {
        didSet {
            pointALabel.text = from
        }
    }
    var to : String? {
        didSet {
            pointBLabel.text = to
        }
    }
    var price : String? {
        didSet {
            print("this is priceeee!", (price ?? ""))
            priceLabel.text = price! + " ₸"
            driverAcceptedOrderLabel.text = "Водитель в пути"
        }
    }
    var step : Int?
    var fromLat : Double?
    var fromLon : Double?
    var toLat : Double?
    var toLon : Double?
    var driverCoordinate : CLLocationCoordinate2D? {
        didSet {
            loadDriverLocation()
            getDriverLocation()
        }
    }
    var driverID : Int?
    var carMark : String?
    var carModel : String?
    var carColor : String?
    var carNumber : String?
    var name : String?
    var surname: String?
    var middleName: String?
    var rating: Double?
    var avatar: String?
    var car: Car?
    var driverPhone: String?
    
    let orderView : UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .white
        return view
    }()
    
    let orderViewLine : UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    let pointAimageView = Helper.setupOrderViewImage(with: #imageLiteral(resourceName: "pointa"))
    let pointBimageView = Helper.setupOrderViewImage(with: #imageLiteral(resourceName: "pointb"))
    let priceImageView = Helper.setupOrderViewImage(with: #imageLiteral(resourceName: "tenge").withRenderingMode(.alwaysTemplate))
    
    let pointALabel = createLabel(text: "")
    let pointBLabel = createLabel(text: "")
    let priceLabel = createLabel(text: "")

    lazy var orderButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.localizedString(key: "cancel_order"), for: .normal)
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDiscardButton(_:)), for: .touchUpInside)
        return button
    }()
    
    let driverAcceptedOrderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var callButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Позвонить", for: .normal)
//        button.setImage(UIImage(named: "call")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleCall), for: .touchUpInside)
        return button
    }()
    
    lazy var iamOutButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выхожу", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        //        button.setImage(UIImage(named: "out")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.tintColor = .blue
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleOutButton), for: .touchUpInside)
        return button
    }()
    
    let driverArrived : UILabel = {
        let label = UILabel()
        label.text = "Водитель ждет Вас"
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let infoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var navImageView: UIImageView = {
        let navImageView = UIImageView()
        navImageView.image = #imageLiteral(resourceName: "Лого")
        navImageView.contentMode = .scaleAspectFit
        return navImageView
    }()
    
    lazy var closeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .blue
        button.layer.cornerRadius = 25
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = .zero
//        button.addTarget(self, action: #selector(handleEndButton), for: .touchUpInside)
        return button
    }()
    
//    lazy var cancelButton: UIButton = {
//        let cb = UIButton()
//        cb.backgroundColor = .clear
//        cb.setTitleColor(.red, for: .normal)
//        cb.setTitle(.localizedString(key: "cancel"), for: .normal)
//        cb.addTarget(self, action: #selector(handleDiscardButton), for: .touchUpInside)
//        return cb
//    }()
    
    let markerA = GMSMarker()
    let markerB = GMSMarker()
    
    @objc func handleOutButton() {
        if let id = id {
            Socket.shared.out(id: id)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        self.dismiss(animated: true, completion: {
//            UserDefaults.standard.set(0, forKey: "currentOrderID")
//        })

        order()
    }
    
    var driverMarker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarTransparent(title: "nil", shadowImage: false)
        driverAcceptedOrderLabel.text = "Водитель в пути"
        
        mapsView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.addSubview(mapsView!)
        
        mapsView?.setMinZoom(10, maxZoom: 25)
        
        if let lat = fromLat, let lon = fromLon {
            mapsView?.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15)
        }
        
        markerA.icon = #imageLiteral(resourceName: "marker_a")
        
        markerA.map = self.mapsView
        
        if let apointLat = fromLat, let apointLon = fromLon {
            markerA.position = CLLocationCoordinate2D(latitude: apointLat, longitude: apointLon)
        }
        
        setupViews()
    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Socket.shared.client.off("driver_position")
        Socket.shared.client.off("order")
        Socket.shared.client.off("order_trade")
        if driverID != nil{
            Socket.shared.client.off("user_position_" + "\(driverID!)")
        }
        mapsView?.delegate = nil
        mapsView?.removeFromSuperview()
        mapsView = nil

        self.removeFromParentViewController()
    }
    
    
    private func getDriverLocation() {
        Socket.shared.client.on("driver_position") { (value, ack) in
            let dataArray = value as NSArray
            let dataString = dataArray[0] as! String
            print("DataString: \(dataString)")
            let encodedData = dataString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: encodedData, options: []) as! [String : AnyObject]
                let json = JSON(jsonObject)
                print("DriverMarkerJson: \(json["lat"]) \(json["lon"])")
                self.showDriverLocation(lat: json["lat"].doubleValue, lon: json["lon"].doubleValue)
                if json["statusCode "].intValue == Constant.statusCode.success {
                    print(json["result"].arrayValue)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func handleCall() {        
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func showDriverLocation(lat: Double, lon: Double){
        self.driverMarker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.driverMarker.icon = #imageLiteral(resourceName: "taxi_icon")
        self.driverMarker.map = self.mapsView
        
        print("Lat: \(lat) Long: \(lon)")
        
        let startLocation = CLLocation(latitude: self.driverMarker.position.latitude, longitude: self.driverMarker.position.longitude)
        let endLocation = CLLocation(latitude: self.markerA.position.latitude, longitude: self.markerA.position.longitude)
        
        self.drawPath(startLocation: startLocation, endLocation: endLocation)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15)
        
        self.mapsView?.camera = camera
    }
    
    func loadDriverLocation() {
        if let id = driverID {
            Socket.shared.loadLocation(id: id, completion: { (lat, lon) in
                self.showDriverLocation(lat: lat, lon: lon)
            })
        } else {
            print("asdklasdlk")
        }
    }
    
    func order() {
        var stepCarColor = ""
        var stepCarModel = ""
        var stepCarMark = ""
        var stepCarNumber = ""
        var stepDriverName = ""
        Socket.shared.order(completion: { (id ,step, carMark, carModel, carColor, carNumber, name, driverPhone, surname, middleName, rating, avatar, driverID, driverLat, driverLon) in
            DispatchQueue.main.async {
                stepCarMark = carMark
                stepCarColor = carColor
                stepCarModel = carModel
                stepCarNumber = carNumber
            }
        })
        print("Step: \(step)")
        if let step = step {
            if step == 2 {
                self.getDriverLocation()
                self.loadDriverLocation()
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.orderView.frame.origin.y = self.view.frame.height
                    self.mapsView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    self.orderView.isHidden = true
                    
                    self.driverAcceptedOrderLabel.isHidden = false
                    self.driverAcceptedOrderLabel.frame = CGRect(x: 0, y: (UIViewController.heightNavBar * 2), width: self.view.frame.width, height: 30)
                    
                    if let carColor = self.carColor, let carMark = self.carMark, let carModel = self.carModel, let carNumber = self.carNumber, let name = self.name {
                        self.infoLabel.text = "\(stepCarColor) \(stepCarMark) \(stepCarModel), \(stepCarNumber) \(stepDriverName)"
                    }
                    
                    self.infoLabel.isHidden = false
                    self.infoLabel.frame = CGRect(x: 35, y: (UIViewController.heightNavBar * 2 + 40), width: self.view.frame.width - 70, height: 70)
                    
                    self.callButton.frame = CGRect(x: (self.view.frame.width / 2) - 65, y: self.view.frame.height - 130, width: 130, height: 40)
                    self.iamOutButton.frame = CGRect(x: (self.view.frame.width / 2) - 65, y: self.view.frame.height - 130, width: 130, height: 40)
//                    self.cancelButton.frame = CGRect(x: (self.view.frame.width / 2) - 65, y: self.view.frame.height - 75, width: 130, height: 40)
                    self.callButton.isHidden = false
                    self.iamOutButton.isUserInteractionEnabled = false
                    
                }, completion: nil)
            } else if step == 3 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.orderView.isHidden = true
                    
                    self.mapsView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    
                    if let carColor = self.carColor, let carMark = self.carMark, let carModel = self.carModel, let carNumber = self.carNumber, let name = self.name {
                        self.infoLabel.text = "\(carColor) \(carMark) \(carModel), \(carNumber) \(name)"
                    }
                    
                    self.driverAcceptedOrderLabel.isHidden = true
                    
                    self.infoLabel.isHidden = false
                    self.infoLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
                    self.infoLabel.frame = CGRect(x: 35, y: (UIViewController.heightNavBar * 2 + 40), width: self.view.frame.width - 70, height: 70)
                    self.driverArrived.isHidden = false
                    self.driverArrived.frame = CGRect(x: 0, y: UIViewController.heightNavBar * 2, width: self.view.frame.width - 50, height: 30)
                    
                    self.callButton.frame = CGRect(x: (self.view.frame.width / 2) - 145, y: self.view.frame.height - 130, width: 130, height: 40)
                    
                    self.iamOutButton.isHidden = false
                    self.callButton.isHidden = false
                    
                    self.iamOutButton.frame = CGRect(x: (self.view.frame.width / 2) + 15, y: self.view.frame.height - 130, width: 130, height: 40)
                    
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else if step == 4 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.orderView.isHidden = true
                    
                    self.mapsView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    
                    self.infoLabel.isHidden = false
                    
                    if let carColor = self.carColor, let carMark = self.carMark, let carModel = self.carModel, let carNumber = self.carNumber, let name = self.name {
                        self.infoLabel.text = "\(carColor) \(carMark) \(carModel), \(carNumber) \(name)"
                    }
                    
                    self.infoLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
                    self.infoLabel.frame = CGRect(x: 35, y: (UIViewController.heightNavBar * 2 + 40), width: self.view.frame.width - 70, height: 70)
                    self.driverArrived.isHidden = false
                    self.driverArrived.text = "Хорошей поездки!"
                    self.driverArrived.frame = CGRect(x: 0, y: UIViewController.heightNavBar * 2, width: self.view.frame.width - 50, height: 30)
                    self.callButton.frame = CGRect(x: (self.view.frame.width / 2) - 65, y: self.view.frame.height - 130, width: 130, height: 40)
                    
                    self.iamOutButton.isHidden = false
                    
                    self.iamOutButton.frame = CGRect(x: (self.view.frame.width / 2) + 15, y: self.view.frame.height + 130, width: 130, height: 40)
                    
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else if step == 5 {
                let car = carMark! + " " + carModel! + " " + carColor!
                self.showFeedbackViewController(id: id!, name: name!, surname: surname!, middleName: middleName!, rating: rating!, avatar: avatar ?? "", car: car, phone: driverPhone!, carNumber: carNumber!, driverID : driverID!)
                UserDefaults.standard.set(0, forKey: "currentOrderID")
            } else {
                print("Step: \(step)")
                //                navigationController?.isNavigationBarHidden = true
                showOrderTrade()
            }
            getOrderSteps()
        } else {
            showOrderTrade()
        }
        

    }

    private func getOrderSteps(){
        Socket.shared.order(completion: { (id ,step, carMark, carModel, carColor, carNumber, name, driverPhone, surname, middleName, rating, avatar, driverID, driverLat, driverLon) in
            self.getDriverLocation()
            self.loadDriverLocation()
            self.phone = driverPhone
            self.driverID = driverID
            print("Step: \(step) lat: \(driverLat) lon: \(driverLon)")
            let systemSoundID: SystemSoundID = 1000
            AudioServicesPlaySystemSound(systemSoundID)

            if step == 0 {
                self.id = nil
                self.cityID = nil
                self.infoLabel.text = nil
                UserDefaults.standard.set(0, forKey: "currentOrderID")
                self.completion?()
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.setupAppdelegate()
                }
            } else if step == 2 {
                self.showDriverLocation(lat: driverLat, lon: driverLon)

                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {


                    self.orderView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 185)
                    self.mapsView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

                    self.driverAcceptedOrderLabel.isHidden = false
                    self.driverAcceptedOrderLabel.frame = CGRect(x: 0, y: (UIViewController.heightNavBar * 2), width: self.view.frame.width - 50, height: 15)

                    self.infoLabel.text = "\(carColor) \(carMark) \(carModel), \(carNumber) \(name)"

                    self.infoLabel.isHidden = false
                    self.infoLabel.frame = CGRect(x: 35, y: (UIViewController.heightNavBar * 2 + 40), width: self.view.frame.width - 70, height: 70)
                    self.callButton.frame = CGRect(x: (self.view.frame.width / 2) - 65, y: self.view.frame.height - 130, width: 130, height: 40)
                    self.iamOutButton.frame = CGRect(x: (self.view.frame.width / 2) - 65, y: self.view.frame.height - 130, width: 130, height: 40)
                    self.callButton.isHidden = false
                }, completion: nil)
            } else if step == 3 {
//                self.setNavigationBarTransparent(title: nil, shadowImage: false)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

                    self.orderView.isHidden = true
                    self.driverAcceptedOrderLabel.isHidden = true

                    self.infoLabel.text = "\(carColor) \(carMark) \(carModel), \(carNumber) \(name)"
                    self.infoLabel.frame = CGRect(x: 35, y: (UIViewController.heightNavBar * 2 + 40), width: self.view.frame.width - 70, height: 70)
                    self.driverArrived.isHidden = false
                    let _: CGFloat = (self.view.frame.width / 2) - ((self.view.frame.width / 2) - 25)
                    self.driverArrived.frame = CGRect(x: 0, y: UIViewController.heightNavBar * 2, width: self.view.frame.width - 50, height: 30)

                    self.callButton.isHidden = false
                    self.callButton.frame = CGRect(x: (self.view.frame.width / 2) - 145, y: self.view.frame.height - 130, width: 130, height: 40)
//                    self.cancelButton.frame = CGRect(x: (self.view.frame.width / 2) - 65, y: self.view.frame.height - 75, width: 130, height: 40)

                    self.iamOutButton.isHidden = false
                    self.iamOutButton.isUserInteractionEnabled = true

                    self.iamOutButton.frame = CGRect(x: (self.view.frame.width / 2) + 15, y: self.view.frame.height - 130, width: 130, height: 40)
                }, completion: nil)
            } else if step == 4 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

                    self.infoLabel.text = "\(carColor) \(carMark) \(carModel), \(carNumber) \(name)"

//                    self.infoLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
                    self.infoLabel.frame = CGRect(x: 35, y: (UIViewController.heightNavBar * 2 + 40), width: self.view.frame.width - 70, height: 70)
                    self.driverArrived.text = "Хорошей поездки!"

                    self.callButton.frame = CGRect(x: (self.view.frame.width / 2) - 65, y: self.view.frame.height - 130, width: 130, height: 40)

                    self.iamOutButton.isHidden = false
                    self.iamOutButton.isUserInteractionEnabled = false


                    self.iamOutButton.frame = CGRect(x: (self.view.frame.width / 2) + 15, y: self.view.frame.height + 130, width: 130, height: 40)
                }, completion: nil)
            } else if step == 5 {
                let car = carMark + " " + carModel + " " + carColor
                self.showFeedbackViewController(id: id, name: name, surname: surname, middleName: middleName, rating: rating, avatar: avatar, car: car, phone: driverPhone, carNumber: carNumber, driverID : driverID)
                self.id = nil
                self.infoLabel.text = nil
            } 
        })
    }

    func getOrderInformation(order: User) {
        print("Information received")
        self.driverID = order.id
        self.carMark = order.taxi_cars?.mark?.name
        self.carModel = order.taxi_cars?.model?.name
        self.carColor = order.taxi_cars?.color?.name_en
        self.carNumber = order.taxi_cars?.number
        self.name = order.name
        self.price = order.price
        self.middleName = order.middle_name
        self.surname = order.surname
        self.avatar = order.avatar
        self.car = order.taxi_cars
        self.driverPhone = order.phone
        self.rating = Double(order.rating ?? "0")!
    }

    func showOrderTrade(){
        let orderTradeController = OrderTradeViewController()
        orderTradeController.modalTransitionStyle = .crossDissolve
        orderTradeController.modalPresentationStyle = .overCurrentContext
        orderTradeController.delegate = self

        if let lat = fromLat, let lon = fromLon {
            orderTradeController.location = CLLocation(latitude: lat, longitude: lon)
        }

        orderTradeController.block = { [weak self] in
            guard let `self` = self else {return}
            self.handleDiscardButton(UIButton())
        }

        orderTradeController.orderAcceptedBlock = { [weak self] in
            guard let `self` = self else {return}
            self.step = 2
            self.order()
            self.getOrderSteps()
            print("Get order steps called")
        }
        
//        let navC = UINavigationController(rootViewController: orderTradeController)

        self.present(orderTradeController, animated: true, completion: nil)
    }

    func showFeedbackViewController(id : Int, name : String, surname : String, middleName : String, rating: Double, avatar : String, car : String, phone : String, carNumber : String, driverID : Int) {
        let feedbackViewController = FeedbackViewController()
        feedbackViewController.id = id
        feedbackViewController.driverID = driverID
        if let url = URL(string: avatar) {
            feedbackViewController.profileImage.kf.setImage(with: url, placeholder: UIImage(named: "profile_image"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        feedbackViewController.fullName.text = surname + " " + name + " " + middleName
        feedbackViewController.ratingView.rating = rating
        feedbackViewController.ratingView.text = "(\(rating))"
        feedbackViewController.carLabel.text = car
        feedbackViewController.numberLabel.text = carNumber
        feedbackViewController.phone = phone

        let nav = UINavigationController(rootViewController: feedbackViewController)
        UserDefaults.standard.set(0, forKey: "currentOrderID")

        present(nav, animated: true, completion: nil)
    }
    
    func setupViews() {
        navigationController?.setNavigationBarHidden(true, animated: false)
//        view.addSubview(closeButton)
        view.addSubview(orderView)
        view.addSubview(driverArrived)
        view.addSubview(driverAcceptedOrderLabel)
        view.addSubview(infoLabel)
        view.addSubview(callButton)
        view.addSubview(iamOutButton)
//        view.addSubview(cancelButton)
        view.addSubview(navImageView)
        orderView.addSubview(orderViewLine)
        orderView.addSubview(pointAimageView)
        orderView.addSubview(pointALabel)
        orderView.addSubview(pointBimageView)
        orderView.addSubview(pointBLabel)
        orderView.addSubview(priceImageView)
        orderView.addSubview(priceLabel)
        orderView.addSubview(orderButton)
        
        let orderViewImageViewWidth = 16
        let orderViewImageViewHeight = 24
        
//        closeButton.snp.makeConstraints { (make) in
//            make.top.equalTo(70)
//            make.right.equalTo(-10)
//            make.width.equalTo(50)
//            make.height.equalTo(50)
//        } 185
    
        orderView.frame = CGRect(x: 0, y: view.frame.height - 185, width: view.frame.width, height: 185)
        
        driverArrived.frame = CGRect(x: 0, y: UIViewController.heightNavBar * 2, width: self.view.frame.width - 50, height: 30)
        driverArrived.isHidden = true
        navImageView.frame = CGRect(x: self.view.frame.width/2 - 100, y: 0, width: 200, height: 100)
        driverAcceptedOrderLabel.frame = CGRect(x: 0 , y: -100, width: view.frame.width - 50, height: 15)
        driverAcceptedOrderLabel.isHidden = true
        
        infoLabel.frame = CGRect(x: (view.frame.width / 2) - ((view.frame.width / 2) - 35), y: -90, width: view.frame.width - 70, height: 13)
        infoLabel.isHidden = true
        
        callButton.frame = CGRect(x: (view.frame.width / 2) - 65, y: view.frame.height + 50, width: 120, height: 40)
        callButton.isHidden = true
        
        iamOutButton.frame = CGRect(x: (view.frame.width / 2) - 65, y: view.frame.height + 50, width: 120, height: 40)
        iamOutButton.isHidden = true
//        self.cancelButton.frame = CGRect(x: (self.view.frame.width / 2) - 65, y: self.view.frame.height - 75, width: 130, height: 40)

        orderViewLine.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        if view.frame.width < 375 {
            pointAimageView.snp.makeConstraints { (make) in
                make.top.equalTo(15)
                make.left.equalTo(20)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            pointALabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(pointAimageView)
                make.left.equalTo(pointAimageView.snp.right).offset(30)
            })
            
            pointBimageView.snp.makeConstraints { (make) in
                make.top.equalTo(pointAimageView.snp.bottom).offset(10)
                make.left.equalTo(20)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            pointBLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(pointBimageView)
                make.left.equalTo(pointBimageView.snp.right).offset(30)
            })
            
            priceImageView.snp.makeConstraints { (make) in
                make.top.equalTo(pointBimageView.snp.bottom).offset(10)
                make.left.equalTo(20)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            priceLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(priceImageView)
                make.left.equalTo(priceImageView.snp.right).offset(30)
            })
        } else {
            pointAimageView.snp.makeConstraints { (make) in
                make.top.equalTo(15)
                make.left.equalTo(50)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            pointALabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(pointAimageView)
                make.left.equalTo(pointAimageView.snp.right).offset(30)
            })
            
            pointBimageView.snp.makeConstraints { (make) in
                make.top.equalTo(pointAimageView.snp.bottom).offset(10)
                make.left.equalTo(50)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            pointBLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(pointBimageView)
                make.left.equalTo(pointBimageView.snp.right).offset(30)
            })
            
            priceImageView.snp.makeConstraints { (make) in
                make.top.equalTo(pointBimageView.snp.bottom).offset(10)
                make.left.equalTo(50)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            priceLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(priceImageView)
                make.left.equalTo(priceImageView.snp.right).offset(30)
            })
        }
        
        navImageView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalToSuperview().offset(16)
            }
            make.centerX.equalToSuperview()
        }
        
        orderButton.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalTo(-10)
            make.height.equalTo(35)
        }
    }
}
