//
//  DriverHomeController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/18/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import Firebase

class DriverHomeController : UITableViewController, CLLocationManagerDelegate {
    
    let cellID = "driverHomeCellID"
    var locationManager = CLLocationManager()
    var distance : Double?
    var phone = ""
    var timer = Timer()
    var timerForSwitchOff = Timer()
    var locationTimer = Timer()
    var locationSeconds = 0
    var seconds = 0
    var currentSeconds = 0

    var currentLocation: CLLocation?
    var timeToSendLocation = 0
    var timerToCountSendLocation: Timer?
    var timerToProgressView: Timer?
    var isFetchedData = false
    var changeCost: Int = 0 {
        didSet {
            self.costLabel.costLabel.text = "\(self.changeCost)₸"
        }
    }
    
    var currentOrder : Order? {
        didSet {
            if let order = currentOrder {
                if let sideController = self.revealViewController() {
                    let orderController = DriverOrderViewController()
                    orderController.order = order
                    let navController = UINavigationController(rootViewController: orderController)
                    sideController.pushFrontViewController(navController, animated: true)
                } else {
                    print("asdasd")
                }
            }
        }
    }
    
    var id = 0
    var user : User? {
        didSet {
            if !isFetchedData {
                print("Socket order list called")
                getAllOrders()
                isFetchedData = true
            }
        }
    }
    
    var orderList : [Order]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var index : Int?
    
    lazy var driverTitleView: DriverCityTitleView = {
        let titleView = DriverCityTitleView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        titleView.statusSwitch.addTarget(self, action: #selector(handleBusySwitch(_:)), for: .valueChanged)
        titleView.statusLabel.text = UserDefaults.standard.bool(forKey: "switchIsOn") ? .localizedString(key: "busy") : .localizedString(key: "free")
        titleView.statusSwitch.isOn = UserDefaults.standard.bool(forKey: "switchIsOn")
        return titleView
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
        label.font = UIFont.systemFont(ofSize: 29, weight: .medium)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    let profileImage: UIImageView = {
        let profImage = UIImageView()
        profImage.contentMode = .scaleAspectFit
        profImage.layer.cornerRadius = 30
        profImage.layer.masksToBounds = true
        return profImage
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
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
        imageView.tintColor = .blue
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

    lazy var lowestCostOfferButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.tintColor = .blue
        button.setImage(#imageLiteral(resourceName: "minusIcon"), for: .normal)
        button.tag = 1
        button.addTarget(self, action: #selector(offerCost), for: .touchUpInside)
        return button
    }()

    lazy var middleCostOfferButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.tintColor = .blue
        button.isUserInteractionEnabled = false
        button.isHidden = true
        button.addTarget(self, action: #selector(offerCost), for: .touchUpInside)
        return button
    }()
    
    lazy var costLabel: CostView = {
        let lbl = CostView()
        lbl.layer.shadowColor = UIColor.black.cgColor
        lbl.layer.shadowOpacity = 0.7
        lbl.contentMode = .center
        lbl.layer.shadowOffset = .zero
        lbl.layer.shadowRadius = 2
        return lbl
    }()

    lazy var highestCostOfferButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.tintColor = .blue
        button.setImage(#imageLiteral(resourceName: "plusIcon"), for: .normal)
        button.addTarget(self, action: #selector(offerCost), for: .touchUpInside)
        return button
    }()
    
    lazy var acceptButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.localizedString(key: "accept_order"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleAcceptButton), for: .touchUpInside)
        return button
    }()

    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.tintColor = .blue
        progressView.progressTintColor = .blue
        progressView.progress = 1
        return progressView
    }()
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    private func runTimerForSwitchOff(){
        timerForSwitchOff = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerForSwitchOffAction), userInfo: nil, repeats: true)
    }
    
    private func runLocationTimer() {
        locationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(locationTimerAction), userInfo: nil, repeats: true)
    }

    private func runProgressViewTimer(){
        blackView.isUserInteractionEnabled = false
        acceptView.isUserInteractionEnabled = false
        getOrderTradeAccept()
        timerToProgressView = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            let progress = self.progressView.progress - 0.025
            if progress <= 0 {
                self.progressView.setProgress(1, animated: true)
                indicator.showInfo(withStatus: "Time is out.")
                indicator.dismiss(withDelay: 0.5)
                self.blackView.isUserInteractionEnabled = true
                self.acceptView.isUserInteractionEnabled = true
                self.handleDismiss()
                Socket.shared.client.off("order_trade_accept")
                self.timerToProgressView?.invalidate()
            } else {
                self.progressView.setProgress(progress, animated: true)
            }
        })
    }

    private func invalidateProgressViewTimer(){
        timerToProgressView?.invalidate()
        progressView.setProgress(1, animated: true)
    }

    private func getOrderTradeAccept(){
        if let id = orderList![index!].id {
            Socket.shared.getAcceptOrderTrade(orderId: id) { order, isSuccess in
                if isSuccess {
                    self.invalidateProgressViewTimer()
                    UserDefaults.standard.set(id, forKey: "currentOrderID")
                    self.handleDismiss()

                    if let slideMenu = self.revealViewController() {
                        let controller = DriverOrderViewController()
                        controller.distanse = self.distance
                        controller.order = order
                        let navController = UINavigationController(rootViewController: controller)
                        slideMenu.pushFrontViewController(navController, animated: true)
                    }
                }
            }
        }
    }

    func showRequestForPay(completion: @escaping (Bool) -> ()){
//        let alert = UIAlertController(title: .localizedString(key: "driver_online"), message: .localizedString(key: "driver_online_text"), preferredStyle: .alert)
//        let yes = UIAlertAction(title: .localizedString(key: "yes"), style: .default, handler: { (action) in
//            self.accessToDriverMode(completion: {(isDriver) in
//                completion(isDriver)
//            })
//        })
//        let no = UIAlertAction(title: .localizedString(key: "no"), style: .destructive, handler: { (action) in
//            self.driverTitleView.statusSwitch.isOn = true
//            self.orderList?.removeAll()
//            self.runTimerForSwitchOff()
//            completion(false)
//        })
//        alert.addAction(yes)
//        alert.addAction(no)
//        self.present(alert, animated: true, completion: nil)
        let vc = RequestForPayViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }

    @objc func offerCost(sender: UIButton){
        
        if sender.tag == 1 {
            self.changeCost -= 50
        } else {
            self.changeCost += 50
        }
        if self.priceLabel.text != self.costLabel.costLabel.text {
            acceptButton.setTitle(String.localizedString(key: "offer_price"), for: .normal)
        } else {
            acceptButton.setTitle(String.localizedString(key: "accept_order"), for: .normal)
        }

    }
    
    @objc func timerAction() {
        seconds -= 1
        let timerLabelText = seconds.getTimerLabelText()
        driverTitleView.timerLabel.text = timerLabelText
        guard seconds == 0 else { return }
        driverTitleView.timerLabel.text = ""
//        timer.invalidate()
    }
    
    @objc func timerForSwitchOffAction(){
        orderList?.removeAll()
        tableView.reloadData()
        print("Removed all orders")
    }
    
    @objc func locationTimerAction() {
        locationSeconds += 1
        guard seconds % 60 == 0 else { return }
        tableView.reloadData()
    }
    
    func checkStatus(withShowAlert: Bool,completion: @escaping (Bool) -> ()) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            Alamofire.request(Constant.api.check, method: .post, parameters: ["token" : token], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if let json = response.result.value, let jsonData = JSON(json).dictionaryObject as [String: Any]? {
                    let decoder = JSONDecoder()
                    guard JSONSerialization.isValidJSONObject(jsonData) else { return }
                    do {
                        let data = try JSONSerialization.data(withJSONObject: jsonData, options: [])
                        let driverStatusResponse = try decoder.decode(DriverStatusResponse.self, from: data)
                        if driverStatusResponse.statusCode == Constant.statusCode.success {
                            let accessDateString = driverStatusResponse.result.accessDate
                            let accessDate = (accessDateString ?? "").getDate()
                            print("Access date: \(accessDate)")
                            let format = DateFormatter()
                            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            format.timeZone = TimeZone(abbreviation: "CAT")!
                            let now = Date().getServerDateString()
                            let convertedDate = format.date(from: now)!
                            print("now: \(convertedDate)")
                            let seconds = accessDate.getDifferenceInSeconds(fromDate: convertedDate)
                            self.seconds = seconds
                            self.currentSeconds = seconds
                            self.runTimer()

//                            Socket.shared.connect()
                            print("Timer is running")
                            UserDefaults.standard.set(true, forKey: "isPaid")
                            completion(true)
                            self.driverTitleView.statusSwitch.isOn = false
                        }else{
                            if withShowAlert{
                                self.showRequestForPay(completion: {(isDriver) -> Void in
                                    completion(isDriver)
                                    UserDefaults.standard.set(isDriver, forKey: "isDriver")
                                })
                            }else{
                                completion(false)
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            })
        }
    }
    
    @objc func handleBusySwitch(_ sender: UISwitch) {
        if sender.isOn {
            currentSeconds = seconds
            seconds = 0
            invalidateTimer()
            runTimerForSwitchOff()
            driverTitleView.statusLabel.text = .localizedString(key:"busy")
            UserDefaults.standard.set(true, forKey: "switchIsOn")
        }else{
            invalidateTimerForSwitchOff()
            fetchUserData()
            getAllOrders()
            driverTitleView.statusLabel.text = .localizedString(key:"free")
            checkStatus(withShowAlert: false, completion: {
                self.driverTitleView.timerLabel.text = $0 ? self.driverTitleView.timerLabel.text : .localizedString(key: "notPaid")
            })
            UserDefaults.standard.set(false, forKey: "switchIsOn")
        }
    }

    private func runTimerToCountSendLocation(){
        timerToCountSendLocation = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            let isTimeToSendLocation = self.timeToSendLocation % 10 == 0
            if isTimeToSendLocation {
//                print("SendLocation \(self.timeToSendLocation)")
                guard let latitude = self.currentLocation?.coordinate.latitude else {return}
                guard let longitude = self.currentLocation?.coordinate.longitude else {return}

                Socket.shared.sendLocation(lat: "\(latitude)", lon: "\(longitude)")
            }
            self.timeToSendLocation = self.timeToSendLocation + 1
        })
    }

    private func invalidateTimerToCountSendLocation(){
        timerToCountSendLocation?.invalidate()
    }

    private func invalidateTimer() {
        timer.invalidate()
        driverTitleView.timerLabel.text = ""
    }
    
    private func invalidateTimerForSwitchOff(){
        timerForSwitchOff.invalidate()
    }
    
    func accessToDriverMode(completion: @escaping (Bool) -> ()) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let body : Parameters = ["token" : token]
            Alamofire.request(Constant.api.access, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if let value = response.result.value, let jsonData = JSON(value).dictionaryObject as [String: Any]?, let statusCode = jsonData["statusCode "] as? Int {
                    guard JSONSerialization.isValidJSONObject(jsonData) else { return }

                    if statusCode == Constant.statusCode.success {
//                            Socket.shared.connect()
                        completion(true)
                    } else {
                        completion(false)
                        indicator.showError(withStatus: "Your money not enough...")
                        indicator.dismiss(withDelay: 1)
                    }

                }
            })
        }
    }
    
    @objc func handleAcceptButton() {
        if self.priceLabel.text == self.costLabel.costLabel.text {
            if let id = orderList![index!].id {
                UserDefaults.standard.set(id, forKey: "currentOrderID")
                Socket.shared.acceptOrder(id: id)
            }
            
            handleDismiss()
            
            if let slideMenu = revealViewController() {
                let controller = DriverOrderViewController()
                controller.order = orderList![index!]
                controller.distanse = self.distance
                let navController = UINavigationController(rootViewController: controller)
                slideMenu.pushFrontViewController(navController, animated: true)
            }

        } else {
            if let list = orderList, let orderId = list[index!].id, let driverId = user?.id {
                let price = self.changeCost
                print("price: \(price) orderId: \(orderId) driverId: \(driverId)")
                Socket.shared.sendOrderTrade(order_id: orderId, driver_id: driverId, price: price) { (isSuccess) in
                    if isSuccess {
                        indicator.showInfo(withStatus: "Please, wait for accept...")
                        indicator.dismiss(withDelay: 0.5)
                        self.runProgressViewTimer()
                    }
                }
            }
        }
    }
    
    @objc func handleCall() {
        phone = phone.contains("+") ? phone : "+\(phone)"
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runLocationTimer()
        let cityId = UserDefaults.standard.integer(forKey: "city_id")
        Messaging.messaging().subscribe(toTopic: "order_list_\(cityId)")
//        var langImage = UIImage()
//        if UserDefaults.standard.string(forKey: "language") == "kz" {
//            langImage = UIImage(named: "kazakh")!
//        } else if UserDefaults.standard.string(forKey: "language") == "ru" {
//            langImage = UIImage(named: "russian")!
//        } else if UserDefaults.standard.string(forKey: "language") == "en" {
//            langImage = UIImage(named: "english")!
//        }
        
//        langImage = langImage.withRenderingMode(.alwaysOriginal)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: langImage, style: .plain, target: self, action: #selector(changeLanguage))

        NotificationCenter.default.addObserver(self, selector: #selector(handleTimerStateDependingOnAppState(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTimerStateDependingOnAppState(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        
        tableView.register(HomeCell.self, forCellReuseIdentifier: cellID)
        
//        navigationItem.titleView = driverTitleView

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.startUpdatingLocation()
        switchRole()
        checkForSwitch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorStyle = .none
        runTimerToCountSendLocation()
        loadCurrentOrder()
        setNavigationBarTransparent(title: .localizedString(key: "orders"), shadowImage: false)
//        navigationController?.navigationBar.titleTextAttributes
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let cityID = user?.city_id else { return }
        Socket.shared.client.off("order_list_\(cityID)")
        invalidateTimerToCountSendLocation()
    }
    
    func checkForSwitch(){
        switch driverTitleView.statusSwitch.isOn{
            case true:
                runTimerForSwitchOff()
                break
            case false:
                invalidateTimerForSwitchOff()
                fetchUserData()
                checkStatus(withShowAlert: false, completion: {self.driverTitleView.timerLabel.text = $0 ? self.driverTitleView.timerLabel.text : .localizedString(key: "notPaid")})
                break
        }
    }
    
    @objc func handleTimerStateDependingOnAppState(_ sender: NSNotification) {
        if sender.name == .UIApplicationDidEnterBackground {
            invalidateTimer()
        } else {
            checkStatus(withShowAlert:true , completion: {(isDriver) in
                UserDefaults.standard.set(isDriver, forKey: "isPaid")
            })
        }
    }
    
    func switchRole() {
        if let token = UserDefaults.standard.string(forKey: "token") {
            Alamofire.request(Constant.api.transition, method: .post, parameters: [ "token" : token, "role" : 2 ], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        if json["statusCode "].intValue == Constant.statusCode.success {
                            print("DirverMODE_ACTIVATEEEEEEEEED")
                        } else {
                            indicator.showError(withStatus: "Error")
                            indicator.dismiss(withDelay: 1.5)
                        }
                    }
                }
            })
        }
    }
    
    func loadCurrentOrder() {
        print("Current id: \(UserDefaults.standard.integer(forKey: "currentOrderID"))")
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
                            
                            let user = User()
                            user.id = json["result"]["passenger"]["id"].intValue
                            user.surname = json["result"]["passenger"]["surname"].stringValue
                            user.name = json["result"]["passenger"]["name"].stringValue
                            user.middle_name = json["result"]["passenger"]["middle_name"].stringValue
                            user.phone = json["result"]["passenger"]["phone"].stringValue
                            user.role = json["result"]["passenger"]["role"].intValue
                            user.city_id = json["result"]["passenger"]["city_id"].intValue
                            user.city = json["result"]["passenger"]["city"].stringValue
                            user.lat = json["result"]["passenger"]["lat"].stringValue
                            user.lon = json["result"]["passenger"]["lon"].stringValue
                            user.avatar = json["result"]["passenger"]["avatar"].stringValue
                            user.token = json["result"]["passenger"]["token"].stringValue
                            user.promo_code = json["result"]["passenger"]["promo_code"].stringValue
                            user.balanse = json["result"]["passenger"]["balance"].intValue
                            user.online = json["result"]["passenger"]["online"].intValue
                            user.iin = json["result"]["passenger"]["iin"].stringValue
                            user.id_card = json["result"]["passenger"]["id_card"].stringValue
                            
                            temp.passenger = user
                            temp.driver_id = json["result"]["driver_id"].intValue
                            temp.driver = nil
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
                            
                            self.currentOrder = temp
                        }
                    } else {
                        print("sdfsdfsdf")
                    }
                } else {
                    print("sdfsdf")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    func getAllOrders() {
        print("UserCityID: \(user?.city_id) \(user?.id)")
        guard let id = user?.city_id else { print("city id not exists"); return }
        Socket.shared.orderList(cityID: id) { (list, statusCode) in
            if statusCode == Constant.statusCode.success {
                print("OrderListDriverController: \(list)")
                self.orderList = list
                self.tableView.reloadData()
            } else {
                print("OrderListFailed")
                self.orderList?.removeAll()
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func handleDismiss() {
        if progressView.progress != 1 {
            invalidateProgressViewTimer()
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.acceptView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 180)
            }
        }, completion: nil)
    }
    
    let blackView = UIView()
    
    let desc : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    func setupBottomPushView(){
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            window.addSubview(acceptView)
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
            acceptView.addSubview(lowestCostOfferButton)
            acceptView.addSubview(middleCostOfferButton)
            acceptView.addSubview(highestCostOfferButton)
            acceptView.addSubview(acceptButton)
            acceptView.addSubview(progressView)
            acceptView.addSubview(costLabel)
            
            blackView.frame = view.frame
            blackView.alpha = 0
            
            acceptView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 300)

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
            bPointLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(countView).offset(9)
                make.left.equalTo(countView.snp.right).offset(20)
                make.right.equalTo(-75)
            }
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
                make.top.equalTo(priceLabel)
                make.left.equalTo(compassImage.snp.right).offset(4)
            }
            acceptButton.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.width.equalTo(180)
                make.bottom.equalTo(-20)
                make.height.equalTo(45)
            }
            progressView.snp.makeConstraints { (make) in
                make.left.equalTo(acceptView)
                make.right.equalTo(acceptView)
                make.bottom.equalTo(acceptView)
                make.height.equalTo(5)
            }
            costLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(acceptButton.snp.top).offset(-20)
                make.width.equalTo(100)
                make.height.equalTo(50)
            }
            lowestCostOfferButton.snp.makeConstraints { (make) in
                make.right.equalTo(costLabel.snp.left)
                make.width.equalTo(50)
                make.height.equalTo(50)
                make.bottom.equalTo(costLabel)
            }
            highestCostOfferButton.snp.makeConstraints { (make) in
                make.left.equalTo(costLabel.snp.right)
                make.width.equalTo(50)
                make.height.equalTo(50)
                make.bottom.equalTo(costLabel)
            }
            acceptView.round(corners: [.topLeft, .topRight], radius: 30)
            acceptView.shadow(opacity: 0.8, radius: 2)
        }
    }
    
    func handleAccept(distance : Double, item : Int) {
        if let window = UIApplication.shared.keyWindow {
            if let list = orderList {
                passengersCountLabel.text = "\(String(describing: list[item].count_passenger!))"
                nameLabel.text = list[item].passenger!.name!
                aPointLabel.text = list[item].from!
                bPointLabel.text = list[item].to!
                if list[item].passenger!.avatar != "no image" {// URL(string: avatar)
                    profileImage.kf.setImage(with: list[item].passenger!.avatar?.serverUrlString.url, placeholder: UIImage(named: "profile_image-1"), options: nil, progressBlock: nil, completionHandler: nil)
                } else {
                    profileImage.image = UIImage(named: "profile_image-1")
                }

                if let getPassenger = list[item].get_passenger {
                    print(getPassenger)
                    let color: UIColor = getPassenger == 0 ? .red : .blue
                    countView.backgroundColor = color
                }
                
                let order = list[item]
                var price = ""
                if order.bonus! == 1 {
                    let doublePrice = Double(order.price!)
                    price = "\(doublePrice.getRemainder())₸ + \(doublePrice.getBonus())₸ bonus"
                } else {
                    price = "\(order.price!)"
                }
                priceLabel.text = "\(price)₸"
                desc.text = list[item].description
                distanceLabel.text = "\(distance) km"
                phone = list[item].passenger!.phone!
//                lowestCostOfferButton.setTitle("\(Int(price)! + 100)₦", for: .normal)
//                middleCostOfferButton.setTitle("\(Int(price)! + 200)₦", for: .normal)
                changeCost = Int(price)!
//                highestCostOfferButton.setTitle("\(Int(price)! + 300)₦", for: .normal)
            }
            
            setupBottomPushView()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.acceptView.frame = CGRect(x: 0, y: window.frame.height - 250, width: window.frame.width, height: 250)
            }, completion: nil)
        }
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomeCell
        
        cell.delegate = self
        if let list = orderList {
            cell.order = list[indexPath.row]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:SS"
            if let date = dateFormatter.date(from: list[indexPath.row].created_at!) {
//                print("time: \(date)")
                cell.orderTimeLabel.text = "\(date.minutes(from: date)) \(String.localizedString(key: "minute"))."
            } else {
                cell.orderTimeLabel.isHidden = true
            }
            
            if let driverLocation = self.currentLocation, let clietLat = list[indexPath.row].passenger!.lat, let clientLon = list[indexPath.row].passenger!.lon {
                let clientLocation = CLLocation(latitude: Double(clietLat)!, longitude: Double(clientLon)!)
                
                let distance = driverLocation.distance(from: clientLocation)
                print(distance)
                
                let roundedDistance = Double(round(10*distance/1000)/10)
                
                cell.distanceLabel.text = "\(roundedDistance) km"
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = orderList {
            return list.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let list = orderList, let driverLocation = self.currentLocation, let clietLat = list[indexPath.row].passenger!.lat, let clientLon = list[indexPath.row].passenger!.lon {
            self.index = indexPath.row
            let clientLocation = CLLocation(latitude: Double(clietLat)!, longitude: Double(clientLon)!)
            let distance = driverLocation.distance(from: clientLocation)
            print("Distance: \(distance)")
            let roundedDistance = round(10*distance/1000)/10
            self.distance = roundedDistance
            checkStatus(withShowAlert: true, completion: {(isDriver) -> Void in
                if isDriver {
                    self.handleAccept(distance: roundedDistance, item: indexPath.row)
                }
            })
        }
    }
}

extension DriverHomeController: MovableToMap {
    func moveToMap(_ pointA: CLLocation, _ pointB: CLLocation) {
        guard let latitude = self.currentLocation?.coordinate.latitude else {return}
        guard let longitude = self.currentLocation?.coordinate.longitude else {return}
        let driverLocation = CLLocation(latitude: latitude, longitude: longitude)
        let controller = PassengerInMapViewController()
        controller.driverPosition = driverLocation
        controller.pointAPosition = pointA
        controller.pointBPosition = pointB
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
