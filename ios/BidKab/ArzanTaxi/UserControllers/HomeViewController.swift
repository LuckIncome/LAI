//
//  ViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/8/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import GoogleMaps
import GooglePlaces
import SVProgressHUD
import FirebaseMessaging
import Cosmos

let GMS_API_KEY = "AIzaSyBxsonU1udXLJqY0uzhDuPN_opy-WfLl-g"
let GMSP_API_KEY = "AIzaSyA2XB1sKFDCBoxpN-R17gGB4PZ_gMHsWJI"

protocol HomeViewControllerDelegate {
    func showFeedbackViewController(id : Int, name : String, surname : String, middleName : String, rating: Double, avatar : String, car : String, phone : String, carColor : String, driverID : Int)
}

class HomeViewController: UIViewController, CLLocationManagerDelegate,  HomeViewControllerDelegate {
    
    let dictionary = [String : String]()

    var selectedTextField: UITextField = UITextField()
    var isInSearchPage: Bool = false
    var pointConstructed: Bool = false
    var mapsView : GMSMapView?
    var locationManager = CLLocationManager()
    var fromCoordinate : CLLocationCoordinate2D?
    var toCoordinate : CLLocationCoordinate2D?
    var passengersCount = 1
    var user : User? {
        didSet {
            if let user = user {
                print(user.city)
                print(user.city_id)
            }
        }
    }
    var drivers : [User]?
    var orderID : Int?
    var isWoman: Bool = false
    var isInvalid: Bool = false
    
    var currentOrder : Order? {
        didSet {
            if let order = currentOrder {
                let orderController = OrderViewController()

                orderController.delegate = self
                orderController.from = order.from
                orderController.to = order.to
                orderController.cityID = order.city_id
                orderController.fromLat = Double(order.from_lat!)
                orderController.fromLon = Double(order.from_lon!)
                orderController.toLat = Double(order.to_lat!)
                orderController.toLon = Double(order.to_lon!)

                if order.bonus! == 1 {
                    let doublePrice = Double(order.price!)
                    orderController.price = "\(doublePrice.getRemainder())₸ + \(doublePrice.getBonus())₸ bonus"
                } else {
                    orderController.price = "\(order.price!)₸"
                }
                orderController.id = order.id
                orderController.step = order.step
                orderController.carMark = order.driver?.taxi_cars?.mark?.name
                orderController.carModel = order.driver?.taxi_cars?.model?.name
                orderController.carColor = order.driver?.taxi_cars?.color?.name_ru
                orderController.carNumber = order.driver?.taxi_cars?.number
                orderController.name = order.driver?.name
                orderController.surname = order.driver?.surname
                orderController.middleName = order.driver?.middle_name
                orderController.avatar = order.driver?.avatar
                orderController.driverPhone = order.driver?.phone
                orderController.rating = Double(order.driver?.rating ?? "0")!
                
//                orderController.mapsView = self.mapsView
                if let driverId = order.driver?.id {
                    orderController.driverID = driverId
                }
                if let phone = order.driver?.phone {
                    orderController.phone = phone
                }
                if let lat = order.driver?.lat, let lon = order.driver?.lon {
                    if let doubleLat = Double(lat), let doubleLon = Double(lon) {
                        orderController.driverCoordinate = CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLon)
                    }
                }
                if order.step! == 5 {
                    showFeedbackViewController(id: order.id!, name: order.driver!.name!, surname: order.driver!.surname!, middleName: order.driver!.middle_name!, rating: Double(order.driver!.rating ?? "0")!, avatar: order.driver!.avatar ?? "", car: "\(order.driver!.taxi_cars!.mark!.name!) \(order.driver!.taxi_cars!.model!.name!)", phone: order.driver!.phone!, carColor: order.driver!.taxi_cars!.color!.name_en!, driverID: order.driver!.id!)
                } else {
//                    present(orderController, animated: true, completion: nil)
                    navigationController?.pushViewController(orderController, animated: true)
                }
            }
        }
    }
    
    let orderView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
//    let orderViewLine : UIView = {
//        let view = UIView()
//
//        view.backgroundColor = .blue
//
//        return view
//    }()
    
    let pointAimageView = Helper.setupOrderViewImage(with: #imageLiteral(resourceName: "pointa"))
    let pointBimageView = Helper.setupOrderViewImage(with: #imageLiteral(resourceName: "pointb"))
    let priceImageView = Helper.setupOrderViewImage(with: #imageLiteral(resourceName: "price").withRenderingMode(.alwaysTemplate))
    let countOfPassengersImageView = Helper.setupOrderViewImage(with: #imageLiteral(resourceName: "passengers").withRenderingMode(.alwaysTemplate))
    
//    let bPointSearchButton = Helper.setSearchButton(title: .localizedString(key: "to"), tag: 1)
    let pointBunderline = Helper.setupUnderline()
    
    let priceTextField : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: .localizedString(key: "price"), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var aPointSearchButton : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: .localizedString(key: "from"), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.delegate = self
        return textField
    }()
    
    lazy var bPointSearchButton : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: .localizedString(key: "to"), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.delegate = self
        return textField
    }()
    
    let descriptionImageView = Helper.setupOrderViewImage(with: #imageLiteral(resourceName: "comment").withRenderingMode(.alwaysTemplate))
    
    let descriptionTextField : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: .localizedString(key: "desc"), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        return textField
    }()
    
    let descriptionTextFieldUnderline = Helper.setupUnderline()
    
    let pointAunderline = Helper.setupUnderline()
    let priceUnderline = Helper.setupUnderline()
    
    let countOfPassangersLabel: UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "passengers_count")
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()
    
    let countOfPassangersLine = Helper.setupUnderline()
    
    lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "minus"), for: .normal)
        button.layer.cornerRadius = 12
        button.tintColor = .black
        button.tag = 0
        button.addTarget(self, action: #selector(handlePassangersCount(sender:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let countOfPassangers: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = .blue
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.layer.cornerRadius = 12
        button.tintColor = .black
        button.tag = 1
        button.addTarget(self, action: #selector(handlePassangersCount(sender:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let takeTravelerLabel: UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "take_traveler")
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()
    
    let takeTravelerSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = true
        switcher.onTintColor = .blue
        switcher.isHidden = true
        return switcher
    }()
    
    let bonusLabel: UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "bonus")
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()
    
    let womanLabel: UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "woman")
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    let invalidLabel: UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "invalid")
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()
    
    let bonusSwitcher : UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
        switcher.onTintColor = .blue
        switcher.isHidden = true
        return switcher
    }()
    
    let womanSwitcher : UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
        switcher.onTintColor = .blue
        switcher.tag = 0
        switcher.addTarget(self, action: #selector(handleSwitcher(_:)), for: .valueChanged)
        return switcher
    }()
    
    let invalidSwitcher : UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
        switcher.onTintColor = .blue
        switcher.tag = 1
        switcher.addTarget(self, action: #selector(handleSwitcher(_:)), for: .valueChanged)
        return switcher
    }()
    
    lazy var orderButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.localizedString(key: "order"), for: .normal)
        button.backgroundColor = .yellow
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleOrderButton), for: .touchUpInside)
        return button
    }()
    
    lazy var myPositionButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "myLocation").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .blue
        button.layer.cornerRadius = 25
//        button.layer.shadowOpacity = 0.5
//        button.layer.shadowOffset = .zero
//        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleMyLocation), for: .touchUpInside)
        return button
    }()
    
    let markerA = GMSMarker()
    let markerB = GMSMarker()
    
    let infoView : UIView = {
        let infoView = UIView()
        infoView.backgroundColor = .white
//        let overlineView = UIView()
//        overlineView.backgroundColor = .blue
//        infoView.addSubview(overlineView)
//        overlineView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.left.right.equalToSuperview()
//            make.height.equalTo(1)
//        }
        return infoView
    }()
    
    let carText : UILabel = {
        let carText = UILabel()
        carText.font = UIFont.boldSystemFont(ofSize: 14)
        carText.textAlignment = .center
        carText.textColor = .black
        return carText
    }()
    
    lazy var closeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "mini_close").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        return button
    }()
    
    let profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "profile_image")
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let fullName : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .blue
        return label
    }()
    
    let ratingView : CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.starSize = 13
        view.settings.fillMode = .half
        return view
    }()

    lazy var mapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Move to map", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
        return button
    }()

    private func moveToPlaceList(){
        let controller = PlaceListViewController()
        controller.delegate = self
        controller.isAorB = selectedTextField == aPointSearchButton
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func handleSwitcher(_ sender: UISwitch) {
        switch sender.tag {
        case 0:
            isWoman = sender.isOn
        default:
            isInvalid = sender.isOn
        }
    }
    
    @objc private func handleCloseButton() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.carText.text = nil
            self.profileImage.image = nil
            self.fullName.text = nil
            self.ratingView.rating = 0
            self.ratingView.text = nil
            
            if let navBarHeight =  self.navigationController?.navigationBar.frame.height {
                let statusBarHeight = UIApplication.shared.statusBarFrame.height
                self.mapsView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 170)
            }
            self.orderView.frame.origin.y = self.view.frame.height - 220
            self.infoView.frame.origin.y = self.view.frame.height
        }, completion: nil)
    }

    @objc private func mapButtonPressed(){
        isInSearchPage = true
        let controller = MapViewController()
        controller.pointChooseMarker.icon = selectedTextField == aPointSearchButton ? #imageLiteral(resourceName: "marker_a") : #imageLiteral(resourceName: "marker_b")
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func showFeedbackViewController(id : Int, name : String, surname : String, middleName : String, rating: Double, avatar : String, car : String, phone : String, carColor: String, driverID : Int) {
        let feedbackViewController = FeedbackViewController()
        feedbackViewController.id = id
        feedbackViewController.driverID = driverID
        if let url = URL(string: avatar) {
            feedbackViewController.profileImage.kf.setImage(with: url, placeholder: UIImage(named: "profile_image"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        feedbackViewController.fullName.text = surname + " " + name + " " + middleName
        feedbackViewController.ratingView.rating = rating
        feedbackViewController.ratingView.text = "(\(rating))"
        feedbackViewController.carLabel.text = "\(car) \(carColor)"
        
//        feedbackViewController.numberLabel.text = carNumber
        feedbackViewController.phone = phone
 
        let nav = UINavigationController(rootViewController: feedbackViewController)
        UserDefaults.standard.set(0, forKey: "currentOrderID")
        
        present(nav, animated: true, completion: nil)
    }
    
    func switchRole() {
        if let token = UserDefaults.standard.string(forKey: "token") {
            Alamofire.request(Constant.api.transition, method: .post, parameters: [ "token" : token, "role" : 1 ], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        if json["statusCode "].intValue == Constant.statusCode.success {
                        } else {
                            indicator.showError(withStatus: "Error")
                            indicator.dismiss(withDelay: 1.5)
                        }
                    }
                } else {
                    indicator.showError(withStatus: "Error")
                    indicator.dismiss(withDelay: 1.5)
                }
            })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !isInSearchPage{
            mapsView?.delegate = nil
            mapsView?.removeFromSuperview()
            mapsView = nil

            removeFromParentViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cityId = UserDefaults.standard.integer(forKey: "city_id")

        Messaging.messaging().unsubscribe(fromTopic: "order_list_\(cityId)")

        self.extendedLayoutIncludesOpaqueBars = true
        selectedTextField = aPointSearchButton
        pointAunderline.backgroundColor = .lightGray
        countOfPassangersLine.isHidden = true
        countOfPassengersImageView.isHidden = true
        
        view.backgroundColor = .white
//        navigationItem.title = "BID KAB"
//        var langImage = UIImage()
//
//        if UserDefaults.standard.string(forKey: "language") == "kz" {
//            langImage = UIImage(named: "kazakh")!
//        } else if UserDefaults.standard.string(forKey: "language") == "ru" {
//            langImage = UIImage(named: "russian")!
//        } else if UserDefaults.standard.string(forKey: "language") == "en" {
//            langImage = UIImage(named: "english")!
//        }

//        langImage = langImage.withRenderingMode(.alwaysOriginal)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: langImage, style: .plain, target: self, action: #selector(changeLanguage))
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }

        configureMapView()
        
        setupViews()
        switchRole()
    }

    func configureMapView(){
        GMSServices.provideAPIKey(GMS_API_KEY)
        GMSPlacesClient.provideAPIKey(GMSP_API_KEY)

        if let navBarHeight =  navigationController?.navigationBar.frame.height {
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            mapsView = GMSMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 220))
        }

        view.addSubview(mapsView!)
        mapsView?.delegate = self

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapsView?.isMyLocationEnabled = true
        locationManager.startUpdatingLocation()
        mapsView?.setMinZoom(10, maxZoom: 25)
    }
    
    func loadCurrentOrder() {
        if UserDefaults.standard.integer(forKey: "currentOrderID") != 0 {
            Alamofire.request(Constant.api.taxi_order + "\(UserDefaults.standard.integer(forKey: "currentOrderID"))").responseJSON { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        if json["statusCode"].intValue == Constant.statusCode.success {
                            
                            let temp = Order()
                            
                            temp.id = json["result"]["id"].intValue
                            temp.type = json["result"]["type"].stringValue
                            temp.passenger_id = json["result"]["passenger_id"].intValue
                            
                            let user = User(json: json)
                            
                            let car = Car(json: json)
                            
                            let mark = CarMark()
                            
                            mark.id = json["result"]["driver"]["taxi_cars"]["car_mark_id"].intValue
                            mark.name = json["result"]["driver"]["taxi_cars"]["car_mark"].stringValue
                            
                            car.mark = mark
                            
                            let model = CarModel()
                            
                            model.id = json["result"]["driver"]["taxi_cars"]["car_model_id"].intValue
                            model.car_mark_id = car.mark?.id
                            model.name = json["result"]["driver"]["taxi_cars"]["car_model"].stringValue
                            
                            car.model = model
                            
                            car.number = json["result"]["driver"]["taxi_cars"]["number"].stringValue
                            car.year = json["result"]["driver"]["taxi_cars"]["year"].stringValue
                            
                            let color = CarColor()
                            
                            color.id = json["result"]["driver"]["taxi_cars"]["color"]["id"].intValue
                            color.name_kk = json["result"]["driver"]["taxi_cars"]["color"]["name_kk"].stringValue
                            color.name_ru = json["result"]["driver"]["taxi_cars"]["color"]["name_ru"].stringValue
                            color.name_en = json["result"]["driver"]["taxi_cars"]["color"]["name_en"].stringValue
                            
                            car.color = color
                            
                            temp.passenger = user
                            temp.driver_id = json["result"]["driver_id"].intValue
                            
                            let driver = User()
                            
                            driver.id = json["result"]["driver"]["id"].intValue
                            driver.surname = json["result"]["driver"]["surname"].stringValue
                            driver.name = json["result"]["driver"]["name"].stringValue
                            driver.middle_name = json["result"]["driver"]["middle_name"].stringValue
                            driver.phone = json["result"]["driver"]["phone"].stringValue.removingWhitespaces()
                            driver.lat = json["result"]["driver"]["lat"].stringValue
                            driver.lon = json["result"]["driver"]["lon"].stringValue
                            
                            temp.driver = driver
                            
                            temp.from = json["result"]["from"].stringValue
                            temp.from_lat = json["result"]["from_lat"].stringValue
                            temp.from_lon = json["result"]["from_lon"].stringValue
                            temp.to = json["result"]["to"].stringValue
                            temp.to_lat = json["result"]["to_lat"].stringValue
                            temp.to_lon = json["result"]["to_lon"].stringValue
                            temp.price = json["result"]["price"].intValue
                            temp.city_id = json["result"]["city_id"].intValue
                            temp.count_passenger = json["result"]["count_passenger"].intValue
                            temp.get_passenger = json["result"]["get_passenger"].intValue
                            temp.bonus = json["result"]["bonus"].intValue
                            temp.status = json["result"]["status"].intValue
                            temp.step = json["result"]["step"].intValue
                            temp.created_at = json["result"]["created_at"].stringValue
                            temp.driver?.taxi_cars = car
                            
                            self.currentOrder = temp
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23),
            NSAttributedString.Key.foregroundColor: UIColor.blue
        ]
        
        setNavigationBarTransparent(title: nil, shadowImage: false)
        

        if !isInSearchPage {
            fetchUserData()
        }

        print("UserDefaults: \(UserDefaults.standard.integer(forKey: "currentOrderID"))")

        loadCurrentOrder()
        getAllDrivers()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location = locations.last

        if let lat = location?.coordinate.latitude, let lon = location?.coordinate.longitude {
            Socket.shared.pushLocation(lat: lat, lon: lon)
        }

        let camera = GMSCameraPosition.camera(withLatitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, zoom: 15)

        fromCoordinate = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)

        mapsView?.camera = camera
        mapsView?.isMyLocationEnabled = true


        if let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude {
            self.markerA.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            getPlaceName(latitude, longitude, aPointSearchButton)
        }
    }

    
    
    func setupViews() {
        priceImageView.tintColor = .blue
        descriptionImageView.tintColor = .blue
        
        view.addSubview(orderView)
//        orderView.addSubview(orderViewLine)
        orderView.addSubview(pointAimageView)
        orderView.addSubview(pointBimageView)
        orderView.addSubview(priceImageView)
        orderView.addSubview(descriptionImageView)
        orderView.addSubview(countOfPassengersImageView)
        orderView.addSubview(aPointSearchButton)
        orderView.addSubview(pointAunderline)
        orderView.addSubview(bPointSearchButton)
        orderView.addSubview(pointBunderline)
        orderView.addSubview(priceTextField)
        orderView.addSubview(priceUnderline)
        orderView.addSubview(descriptionTextField)
        orderView.addSubview(descriptionTextFieldUnderline)
        orderView.addSubview(countOfPassangersLabel)
        orderView.addSubview(countOfPassangersLine)
        orderView.addSubview(minusButton)
        orderView.addSubview(plusButton)
        orderView.addSubview(countOfPassangers)
        orderView.addSubview(takeTravelerLabel)
        orderView.addSubview(takeTravelerSwitcher)
        orderView.addSubview(bonusSwitcher)
        orderView.addSubview(bonusLabel)
        orderView.addSubview(orderButton)
//        orderView.addSubview(womanLabel)
//        orderView.addSubview(womanSwitcher)
//        orderView.addSubview(invalidLabel)
//        orderView.addSubview(invalidSwitcher)

        view.addSubview(infoView)
        infoView.addSubview(carText)
        infoView.addSubview(closeButton)
        infoView.addSubview(profileImage)
        infoView.addSubview(fullName)
        infoView.addSubview(ratingView)
        
        view.addSubview(myPositionButton)
        
        let orderViewImageViewWidth = 20
        let orderViewImageViewHeight = 30
        
        infoView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 190)
        
        carText.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(carText)
            make.right.equalTo(-15)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        profileImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        fullName.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImage).offset(-8)
            make.left.equalTo(profileImage.snp.right).offset(10)
            make.right.equalTo(-20)
        }
        
        ratingView.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImage).offset(8)
            make.left.equalTo(fullName)
        }

        orderView.frame = CGRect(x: 0, y: view.frame.height - 280, width: view.frame.width, height: 280)
        orderView.round(corners: [.topLeft, .topRight], radius: 30)
        orderView.shadow(opacity: 0.8, radius: 2)

        
//        orderView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.height.equalTo(265)
//        }
        
//        orderViewLine.snp.makeConstraints { (make) in
//            make.top.left.right.equalToSuperview()
//            make.height.equalTo(1)
//        }
        
        if view.frame.width < 375 {
            pointAimageView.snp.makeConstraints { (make) in
                make.top.equalTo(20)
                make.left.equalTo(20)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            pointBimageView.snp.makeConstraints { (make) in
                make.top.equalTo(pointAimageView.snp.bottom).offset(15)
                make.left.equalTo(20)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            priceImageView.snp.makeConstraints { (make) in
                make.top.equalTo(pointBimageView.snp.bottom).offset(15)
                make.left.equalTo(20)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            descriptionImageView.snp.makeConstraints { (make) in
                make.top.equalTo(priceImageView.snp.bottom).offset(15)
                make.centerX.equalTo(priceImageView)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            countOfPassengersImageView.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionImageView.snp.bottom).offset(15)
                make.centerX.equalTo(priceImageView)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            aPointSearchButton.snp.makeConstraints { (make) in
                make.top.equalTo(pointAimageView)
                make.left.equalTo(pointAimageView.snp.right).offset(15)
                make.right.equalTo(-20)
                make.height.equalTo(pointAimageView)
            }
            
            bPointSearchButton.snp.makeConstraints { (make) in
                make.top.equalTo(pointBimageView)
                make.left.equalTo(pointBimageView.snp.right).offset(15)
                make.right.equalTo(-20)
                make.height.equalTo(pointBimageView)
            }
            
            priceTextField.snp.makeConstraints { (make) in
                make.top.equalTo(priceImageView)
                make.left.equalTo(priceImageView.snp.right).offset(15)
                make.right.equalTo(-20)
                make.height.equalTo(priceImageView)
            }
            
            descriptionTextField.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionImageView)
                make.left.equalTo(descriptionImageView.snp.right).offset(10)
                make.right.equalTo(-20)
                make.height.equalTo(descriptionImageView)
            }
            
            plusButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(countOfPassangersLabel)
                make.right.equalTo(-20)
                make.width.equalTo(24)
                make.height.equalTo(24)
            }
            
            bonusSwitcher.snp.makeConstraints { (make) in
                make.centerY.equalTo(takeTravelerSwitcher)
                make.right.equalTo(-10)
            }
            
//            womanSwitcher.snp.makeConstraints { (make) in
//                make.top.equalTo(takeTravelerSwitcher.snp.bottom).offset(0)
//                make.left.equalTo(takeTravelerLabel.snp.right).offset(-5)
//            }

//            invalidSwitcher.snp.makeConstraints { (make) in
//                make.top.equalTo(bonusSwitcher.snp.bottom).offset(0)
//                make.right.equalTo(-10)
//            }

//            womanLabel.snp.makeConstraints { (make) in
//                make.centerY.equalTo(womanSwitcher)
//                make.left.equalTo(15)
//                make.right.equalTo(womanSwitcher.snp.left).offset(-5)
//            }

//            invalidLabel.snp.makeConstraints { (make) in
//                make.centerY.equalTo(invalidSwitcher)
//                make.right.equalTo(invalidSwitcher.snp.left).offset(-5)
//            }
        } else {
            pointAimageView.snp.makeConstraints { (make) in
                make.top.equalTo(20)
                make.left.equalTo(50)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            pointBimageView.snp.makeConstraints { (make) in
                make.top.equalTo(pointAimageView.snp.bottom).offset(15)
                make.left.equalTo(50)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            priceImageView.snp.makeConstraints { (make) in
                make.top.equalTo(pointBimageView.snp.bottom).offset(15)
                make.left.equalTo(50)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            descriptionImageView.snp.makeConstraints { (make) in
                make.top.equalTo(priceImageView.snp.bottom).offset(15)
                make.left.equalTo(50)
                make.width.equalTo(orderViewImageViewWidth)
                make.height.equalTo(orderViewImageViewHeight)
            }
            
            countOfPassengersImageView.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionImageView.snp.bottom).offset(10)
                make.centerX.equalTo(priceImageView)
                make.width.equalTo(24)
                make.height.equalTo(20)
            }
            
            aPointSearchButton.snp.makeConstraints { (make) in
                make.top.equalTo(pointAimageView)
                make.left.equalTo(pointAimageView.snp.right).offset(15)
                make.right.equalTo(-50)
                make.height.equalTo(pointAimageView)
            }
            
            bPointSearchButton.snp.makeConstraints { (make) in
                make.top.equalTo(pointBimageView)
                make.left.equalTo(pointBimageView.snp.right).offset(15)
                make.right.equalTo(-50)
                make.height.equalTo(pointBimageView)
            }
            
            priceTextField.snp.makeConstraints { (make) in
                make.top.equalTo(priceImageView)
                make.left.equalTo(priceImageView.snp.right).offset(15)
                make.right.equalTo(-50)
                make.height.equalTo(priceImageView)
            }
            
            descriptionTextField.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionImageView)
                make.left.equalTo(descriptionImageView.snp.right).offset(15)
                make.right.equalTo(-50)
                make.height.equalTo(descriptionImageView)
            }
            
            plusButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(countOfPassangersLabel)
                make.right.equalTo(-50)
                make.width.equalTo(24)
                make.height.equalTo(24)
            }
            
            bonusSwitcher.snp.makeConstraints { (make) in
                make.centerY.equalTo(takeTravelerSwitcher)
                make.right.equalTo(-40)
            }
            
//            womanSwitcher.snp.makeConstraints { (make) in
//                make.top.equalTo(takeTravelerSwitcher.snp.bottom).offset(0)
//                make.left.equalTo(takeTravelerLabel.snp.right).offset(-5)
//            }
//
//            invalidSwitcher.snp.makeConstraints { (make) in
//                make.top.equalTo(bonusSwitcher.snp.bottom).offset(0)
//                make.right.equalTo(-40)
//            }
//
//            womanLabel.snp.makeConstraints { (make) in
//                make.centerY.equalTo(womanSwitcher)
//                make.left.equalTo(15)
//                make.right.equalTo(womanSwitcher.snp.left).offset(0)
//            }
//
//            invalidLabel.snp.makeConstraints { (make) in
//                make.centerY.equalTo(invalidSwitcher)
//                make.right.equalTo(invalidSwitcher.snp.left).offset(0)
//            }
        }
        
        pointAunderline.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(aPointSearchButton).offset(10)
            make.height.equalTo(0.5)
        }

        pointBunderline.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bPointSearchButton).offset(10)
            make.height.equalTo(0.5)
        }
        
        priceUnderline.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(priceTextField).offset(10)
            make.height.equalTo(0.5)
        }
        
        descriptionTextFieldUnderline.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(descriptionTextField).offset(10)
            make.height.equalTo(0.5)
        }
        
        countOfPassangersLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countOfPassengersImageView)
            make.left.equalTo(countOfPassengersImageView.snp.right).offset(10)
            make.height.equalTo(countOfPassengersImageView)
        }
        
        countOfPassangersLine.snp.makeConstraints { (make) in
            make.left.equalTo(countOfPassangersLabel)
            make.right.equalTo(priceTextField)
            make.bottom.equalTo(countOfPassangersLabel).offset(6)
            make.height.equalTo(0.5)
        }
        
        minusButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(countOfPassangersLabel)
            make.left.equalTo(countOfPassangersLabel.snp.right)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }

        countOfPassangers.snp.makeConstraints { (make) in
            make.centerY.equalTo(countOfPassangersLabel)
            make.left.equalTo(minusButton.snp.right).offset(5)
            make.right.equalTo(plusButton.snp.left).offset(-5)
        }
        
        takeTravelerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countOfPassengersImageView.snp.bottom).offset(15)
            make.left.equalTo(view).offset(20)
        }
        
        takeTravelerSwitcher.snp.makeConstraints { (make) in
            make.centerY.equalTo(takeTravelerLabel)
            make.left.equalTo(takeTravelerLabel.snp.right).offset(-5)
        }
        
        takeTravelerSwitcher.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)

        bonusSwitcher.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        womanSwitcher.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        invalidSwitcher.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        
        bonusLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(bonusSwitcher)
            make.right.equalTo(bonusSwitcher.snp.left).offset(5)
        }
        
        orderButton.snp.makeConstraints { (make) in
            make.width.equalTo(180)
            make.height.equalTo(42)
            make.bottom.equalTo(-25)
            make.centerX.equalToSuperview()
        }
        
        myPositionButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(orderView.snp.top).offset(-40)
            make.right.equalTo(-15)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }

//        view.addSubview(mapButton)
//        mapButton.snp.makeConstraints { (mapButton) in
//            mapButton.right.bottom.equalTo(mapsView!)
//            mapButton.height.equalTo(30)
//            mapButton.width.equalTo(80)
//        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if textField == aPointSearchButton {
            selectedTextField = textField
            pointAunderline.backgroundColor = .lightGray
            pointBunderline.backgroundColor = .lightGray
            isInSearchPage = true
            moveToPlaceList()
        } else if textField == bPointSearchButton {
            selectedTextField = textField
            pointBunderline.backgroundColor = .lightGray
            pointAunderline.backgroundColor = .lightGray
            isInSearchPage = true
            moveToPlaceList()
        }
    }
}

extension HomeViewController: PlaceDelegate {
    func place(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees, _ name: String) {
        if selectedTextField == aPointSearchButton {
            fromCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            toCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        selectedTextField.text = name
        isInSearchPage = false
    }
}
