//
//  DriverOrderViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/18/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import GoogleMaps
import VisualEffectView
import SnapKit
import AVFoundation

class DriverOrderViewController : UIViewController, CLLocationManagerDelegate {
    var driverHome : DriverHomeController?
    
    var order : Order? {
        didSet {
            if let pasCount = order?.count_passenger, let name = order?.passenger?.name, let aPoint = order?.from, let bPoint = order?.to, let price = order?.price, let image = order?.passenger?.avatar {
                
                if image != "no image" {// URL(string: avatar)
                    profileImage.kf.setImage(with: image.serverUrlString.url, placeholder: UIImage(named: "profile_image-1"), options: nil, progressBlock: nil, completionHandler: nil)
                } else {
                    profileImage.image = UIImage(named: "profile_image-1")
                }

                passengersCountLabel.text = "\(pasCount)"
                nameLabel.text = name
                aPointLabel.text = aPoint
                bPointLabel.text = bPoint
                if let getPassenger = order?.get_passenger {
                    let color: UIColor = getPassenger == 0 ? .red : .blue
                    countView.backgroundColor = color
                }
                var finalPrice = ""
                if order?.bonus! == 1 {
                    let doublePrice = Double(price)
                    finalPrice = "\(doublePrice.getRemainder())₸ + \(doublePrice.getBonus())₸ bonus"
                } else {
                    finalPrice = "\(price)₸"
                }
                priceLabel.text = finalPrice
            }
        }
    }
    
    var polyline: GMSPolyline?
    
    var shouldEnd = false {
        didSet {
            print(shouldEnd)
        }
    }
    var acceptViewHeightContraint: Constraint?
    var endButtonBottomConstraint: Constraint?
    var mapsView : GMSMapView?
    var locationManager = CLLocationManager()
    var toCoordinate : CLLocationCoordinate2D?
    var fromCoordinate : CLLocationCoordinate2D?
    var distanse : Double? {
        didSet {
            if let distanse = distanse {
                distanceLabel.text = "\(distanse) km."
            }
        }
    }
    
    var currentLocation: CLLocation?
    var timeToSendLocation = 0
    var timerToCountSendLocation: Timer?
    
    let timeView : VisualEffectView = {
        let view = VisualEffectView()
        view.blurRadius = 2
        view.scale = 1
        view.colorTint = .darkGray
        view.colorTintAlpha = 0.55
        return view
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        label.textColor = .white
        return label
    }()
    
    lazy var myPositionButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "my_location"), for: .normal)
        button.layer.cornerRadius = 25
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = .zero
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleMyLocation), for: .touchUpInside)
        return button
    }()
    
    let acceptView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let countView : UIView = {
        let view = UIView()
        view.backgroundColor = .blue
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
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    let aPointLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let bPointLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
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
        return imageView
    }()
    
    let distanceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    lazy var phoneButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "phone"), for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCall), for: .touchUpInside)
        return button
    }()
    
    lazy var endButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.localizedString(key: "driver_arrived"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .yellow
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleEndButton), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.localizedString(key: "cancel"), for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.tintColor = .red
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleCancelOrder(_:)), for: .touchUpInside)
        return button
    }()
    
    let userOutLabel : UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "client_out")
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    @objc func hideUserOutLabel() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.userOutLabel.frame = CGRect(x: (self.view.frame.width / 2) - ((self.view.frame.width / 2) - 25), y: -100, width: self.view.frame.width - 50, height: 20)
        }, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runTimerToCountSendLocation()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .blue
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.blue]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Socket.shared.client.off("order")
        invalidateTimerToCountSendLocation()
    }

    private func runTimerToCountSendLocation(){
        timerToCountSendLocation = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            let isTimeToSendLocation = self.timeToSendLocation % 10 == 0

            self.mapsView?.isMyLocationEnabled = true
//            print("SendLocation \(self.timeToSendLocation)")
            guard let latitude = self.currentLocation?.coordinate.latitude else {return}
            guard let longitude = self.currentLocation?.coordinate.longitude else {return}


            let startLocation = CLLocation(latitude: latitude, longitude: longitude)
            let endLocation = CLLocation(latitude: self.markerA.position.latitude, longitude: self.markerA.position.longitude)

            let distance = startLocation.distance(from: endLocation)

            self.distanse = Double(round(10*distance/1000)/10)

            self.drawPath(startLocation: startLocation, endLocation: endLocation)

            if isTimeToSendLocation {
                Socket.shared.sendLocation(lat: "\(latitude)", lon: "\(longitude)")
                self.sendDriverPosition(lat: latitude, lon: longitude)
            }

            self.timeToSendLocation = self.timeToSendLocation + 1
        })
    }

    private func invalidateTimerToCountSendLocation(){
        timerToCountSendLocation?.invalidate()
    }
    
    func setupViews() {
        view.addSubview(acceptView)
        view.addSubview(userOutLabel)
        acceptView.addSubview(countView)
        countView.addSubview(passengersCountLabel)
        countView.addSubview(profileImage)
        acceptView.addSubview(nameLabel)
        acceptView.addSubview(aPointLabel)
        acceptView.addSubview(bPointLabel)
        acceptView.addSubview(phoneButton)
        acceptView.addSubview(priceLabel)
        acceptView.addSubview(compassImage)
        acceptView.addSubview(distanceLabel)
//        acceptView.addSubview(phoneButton)
        acceptView.addSubview(endButton)
        acceptView.addSubview(cancelButton)
        
        acceptView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 280)

        userOutLabel.frame = CGRect(x: (self.view.frame.width / 2) - ((self.view.frame.width / 2) - 25), y: -100, width: view.frame.width - 50, height: 20)
        userOutLabel.isHidden = true
        
        countView.snp.makeConstraints({ (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.width.equalTo(60)
            make.height.equalTo(60)
        })
        
        passengersCountLabel.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
        })

        profileImage.snp.makeConstraints { (make) in
            make.center.width.height.equalToSuperview()
        }

        nameLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(countView.snp.bottom).offset(5)
            make.centerX.equalTo(countView)
            make.width.equalTo(profileImage)
        })
        
        aPointLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(countView).offset(-9)
            make.left.equalTo(countView.snp.right).offset(20)
            make.right.equalTo(-75)
        })
        
        bPointLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(countView).offset(9)
            make.left.equalTo(countView.snp.right).offset(20)
            make.right.equalTo(-75)
        })
        
        phoneButton.snp.makeConstraints { (make) in
            make.top.equalTo(bPointLabel)
            make.right.equalToSuperview().offset(-8)
            make.height.width.equalTo(45)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(nameLabel)
            make.left.equalTo(aPointLabel)
        }

        compassImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceLabel)
            make.left.equalTo(acceptView.snp.centerX)
            make.width.equalTo(15)
            make.height.equalTo(20)
        }

        distanceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceLabel)
            make.left.equalTo(compassImage.snp.right).offset(4)
        }
        
//        phoneButton.snp.makeConstraints({ (make) in
//            make.right.equalTo(-15)
//            make.centerY.equalTo(countView)
//            make.width.equalTo(30)
//            make.height.equalTo(30)
//        })
        
        cancelButton.snp.makeConstraints({ (make) in
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(45)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
        })
        
        endButton.snp.makeConstraints { (make) in
            self.endButtonBottomConstraint = make.bottom.equalTo(acceptView.snp.bottom).offset(-80).constraint
            make.left.equalTo(cancelButton.snp.left)
            make.right.equalTo(cancelButton.snp.right)
            make.height.equalTo(45)
        }
        
        acceptView.round(corners: [.topLeft, .topRight], radius: 30)
        acceptView.shadow(opacity: 0.8, radius: 2)

        acceptView.frame = CGRect(x: 0, y: view.frame.height-280, width: view.frame.width, height: 280)

    }
    
    func checkStep() {
        if let currentOrderStep = order?.step {
            if currentOrderStep == 3 {
                view.addSubview(blackView)
                blackView.addSubview(notificationLabel)
                removeCancelButton()
                notificationLabel.text = .localizedString(key: "notif_driver")
                notificationLabel.numberOfLines = 2
                notificationLabel.textColor = .white
                notificationLabel.textAlignment = .center
                
                blackView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
                blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                blackView.alpha = 0
                view.bringSubview(toFront: acceptView)
                distanceLabel.removeFromSuperview()
                compassImage.removeFromSuperview()
                
                notificationLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(60)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                }
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.timeView.alpha = 0
                    self.blackView.alpha = 1
                    self.shouldEnd = false
                    self.endButton.setTitle(.localizedString(key: "cancel"), for: .normal)
                    self.endButton.removeTarget(self, action: #selector(self.handleEndButton), for: .touchUpInside)
                    self.endButton.addTarget(self, action: #selector(self.handleCancelOrder), for: .touchUpInside)
                }, completion: nil)
            } else if currentOrderStep == 4 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.removeCancelButton()
                    self.blackView.alpha = 0
                    self.userOutLabel.isHidden = false
                    self.userOutLabel.frame = CGRect(x: (self.view.frame.width / 2) - ((self.view.frame.width / 2) - 25), y: 60, width: self.view.frame.width - 50, height: 20)
                    self.endButton.setTitle(.localizedString(key: "end_order"), for: .normal)
                    self.endButton.removeTarget(self, action: #selector(self.handleEndButton), for: .touchUpInside)
                    self.endButton.addTarget(self, action: #selector(self.handleCancelOrder), for: .touchUpInside)
                    self.shouldEnd = true
                    Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.hideUserOutLabel), userInfo: nil, repeats: false)
                }, completion: nil)
            }
        }
        
        Socket.shared.order(completion: { (id, step, carMark, carModel, carColor, carNumber, name, driverPhone, surname, middleName, rating, avatar, driverID, driverLat, driverLon) in
            let systemSoundID: SystemSoundID = 1000
            AudioServicesPlaySystemSound(systemSoundID)
            if step == 3 {
                self.removeCancelButton()
                self.view.addSubview(self.blackView)
                self.blackView.addSubview(self.notificationLabel)
                
                self.notificationLabel.text = .localizedString(key: "notif_driver")
                self.notificationLabel.numberOfLines = 2
                self.notificationLabel.textColor = .white
                self.notificationLabel.textAlignment = .center
                
                self.blackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                self.blackView.alpha = 0
                self.view.bringSubview(toFront: self.acceptView)
                
                self.distanceLabel.removeFromSuperview()
                self.compassImage.removeFromSuperview()
                
                self.notificationLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(60)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                }
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.timeView.alpha = 0
                    self.blackView.alpha = 1
                    self.shouldEnd = false
                    self.endButton.setTitle(.localizedString(key: "cancel"), for: .normal)
                    self.endButton.removeTarget(self, action: #selector(self.handleEndButton), for: .touchUpInside)
                    self.endButton.addTarget(self, action: #selector(self.handleCancelOrder), for: .touchUpInside)
                }, completion: nil)
            } else if step == 4 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.blackView.alpha = 0
                    self.userOutLabel.isHidden = false
                    self.userOutLabel.frame = CGRect(x: (self.view.frame.width / 2) - ((self.view.frame.width / 2) - 25), y: 60, width: self.view.frame.width - 50, height: 20)
                    self.endButton.setTitle(.localizedString(key: "end_order"), for: .normal)
                    self.endButton.removeTarget(self, action: #selector(self.handleEndButton), for: .touchUpInside)
                    self.endButton.addTarget(self, action: #selector(self.handleCancelOrder), for: .touchUpInside)
                    self.shouldEnd = true
                    
                    Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.hideUserOutLabel), userInfo: nil, repeats: false)
                }, completion: nil)
            } else if step == 5 {
                if let slideMenu = self.revealViewController() {
                    UserDefaults.standard.set(0, forKey: "currentOrderID")
                    
                    self.order = nil
                    
                    let driverHome = DriverHomeController()
                    driverHome.currentOrder = nil
                    
                    let navController = UINavigationController(rootViewController: driverHome)
                    slideMenu.pushFrontViewController(navController, animated: true)
                }
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func removeCancelButton() {
        acceptViewHeightContraint?.update(offset: 180)
        endButtonBottomConstraint?.update(offset: -15)
        endButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(acceptView.snp.centerX)
            make.height.equalTo(45)
            make.left.equalTo(60)
            make.right.equalTo(-60)
        }
        cancelButton.removeFromSuperview()
    }
    
    var markerA = GMSMarker()
    
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
        
//        navigationItem.title = .localizedString(key: "user_orders")
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        
        GMSServices.provideAPIKey(GMS_API_KEY)
        
        mapsView = GMSMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(mapsView!)
        
        setupViews()
        
//        view.addSubview(myPositionButton)
        
//        myPositionButton.snp.makeConstraints { (make) in
//            make.top.equalTo(60)
//            make.right.equalTo(-15)
//            make.width.equalTo(50)
//            make.height.equalTo(50)
//        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapsView?.isMyLocationEnabled = true
        locationManager.startUpdatingLocation()
        mapsView?.setMinZoom(10, maxZoom: 25)
        
        if let fromLat = order?.from_lat, let fromLon = order?.from_lon {
            
            fromCoordinate = CLLocationCoordinate2D(latitude: Double(fromLat)!, longitude: Double(fromLon)!)
        
            markerA.position = fromCoordinate!
            
            markerA.icon = #imageLiteral(resourceName: "marker_a")
            
            let camera = GMSCameraPosition.camera(withLatitude: Double(fromLat)!, longitude: Double(fromLon)!, zoom: 15)
            
            mapsView?.camera = camera
            
            markerA.map = mapsView
        }
        
        checkStep()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }

    func showAlertAboutDistance(){
        let alertController = UIAlertController(title: "", message: "To announce the parish, you must be within 1 km radius.", preferredStyle: .alert)
        present(alertController, animated: true, completion:{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                alertController.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    @objc func handleMyLocation() {
        if let latitude = locationManager.location?.coordinate.latitude, let longitude = locationManager.location?.coordinate.longitude {
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
            
            mapsView?.animate(to: camera)
        }
    }
    
    let blackView = UIView()
    let notificationLabel = UILabel()
    
    @objc func handleCall() {

        if var phone = order?.passenger?.phone?.removingWhitespaces() {
            phone = phone.contains("+") ? phone : "+\(phone)"
            if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
                print(url)
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    @objc func handleEndButton() {
        print("Distance: \(distanse)")
        if let distance = distanse, distance <= 1 {
            if let id = order?.id {
                Socket.shared.orderArrived(id: id)
                print(id)
            }
            removeCancelButton()
            view.addSubview(blackView)
            blackView.addSubview(notificationLabel)

            notificationLabel.text = .localizedString(key: "notif_driver")
            notificationLabel.numberOfLines = 2
            notificationLabel.textColor = .white
            notificationLabel.textAlignment = .center

            blackView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.alpha = 0

            distanceLabel.removeFromSuperview()
            compassImage.removeFromSuperview()

            notificationLabel.snp.makeConstraints { (make) in
                if #available(iOS 11.0, *) {
                    make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
                } else {
                    make.top.equalTo(60)
                }
                make.left.equalTo(15)
                make.right.equalTo(-15)
            }

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.timeView.alpha = 0
                self.blackView.alpha = 1
                self.endButton.setTitle(.localizedString(key: "end_order"), for: .normal)
                self.acceptView.frame = CGRect(x: 0, y: self.view.frame.height-180, width: self.view.frame.width, height: 180)
            }, completion: nil)
            endButton.removeTarget(self, action: #selector(handleEndButton), for: .touchUpInside)
            endButton.addTarget(self, action: #selector(handleCancelOrder), for: .touchUpInside)
        } else {
            showAlertAboutDistance()
        }
    }
    
    private func sendDriverPosition(lat: Double, lon: Double) {
        guard let orderId = order?.id else { return }
        Socket.shared.sendDriverLocation(orderId: orderId, lat: String(lat), lon: String(lon))
    }
    
    @objc func handleCancelOrder(_ sender: UIButton) {
        print("Handle Cancel")
        sender.isEnabled = false
        if shouldEnd {
            print("Ended")
            if let slideMenu = revealViewController() {
                if let id = order?.id {
                    Socket.shared.endOrder(id: id)
                    
                    UserDefaults.standard.set(0, forKey: "currentOrderID")
                    
                    self.order = nil
                    
                    let driverHome = DriverHomeController()
                    
                    driverHome.currentOrder = nil
                    
                    let navController = UINavigationController(rootViewController: driverHome)
                    slideMenu.pushFrontViewController(navController, animated: true)
                }
            }
        } else {
            print("Canceled")
            if let slideMenu = revealViewController() {
                if let id = order?.id, let cityId = order?.city_id {
                    Socket.shared.cancelOrder(id: id, city_id: cityId) { isSuccess in
                        sender.isEnabled = isSuccess ? true : false

                        if isSuccess {
                            UserDefaults.standard.set(0, forKey: "currentOrderID")

                            self.order = nil

                            let driverHome = DriverHomeController()

                            driverHome.currentOrder = nil

                            let navController = UINavigationController(rootViewController: driverHome)
                            slideMenu.pushFrontViewController(navController, animated: true)
                        } else {
                            indicator.show(withStatus: "Can't cancel")
                            indicator.dismiss(withDelay: 0.5)
                        }
                    }
                }
            }
        }
    }
}
