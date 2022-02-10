//
//  LeftMenuController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/13/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

enum UserLeftMenu : Int {
    case main = 0
    case city
    case history
    case intercity
//    case vip
    case cargo
    case special
    case moto
//    case friends
    case contactUs
    case notifications
//    case help
    case share

}

enum DriverLeftMenu : Int {
    case main = 0
    case city
    case history
    case intercity
//    case vip
    case cargo
    case special
    case moto
//    case friends
    case contactUs
    case notifications
//    case help
    case share
}

class LeftMenuController : UIViewController, UITableViewDelegate, UITableViewDataSource, LeftMenuControllerDelegate  {

    
    let menuCellID = "menuCellID"
    var driverModeIsOn = false
    var userModeIsOn = true
    var cityName = ""
    var promocode = "Promocode "
    var user : User? {
        didSet {
            if let name = user?.city {
                cityName = name
                menuItemsTableView.reloadData()
            }
            if let promocode = user?.promo_code {
                self.promocode = "Promocode \(promocode)"
                menuItemsTableView.reloadData()
            }
        }
    }
    
    
    var userMenuItems = [String.localizedString(key: "city"), String.localizedString(key: "history"), String.localizedString(key: "intercity"), String.localizedString(key: "cargo"), String.localizedString(key: "special_eqipment"), String.localizedString(key: "moto"), String.localizedString(key: "contactUs"), String.localizedString(key: "notifications"), String.localizedString(key: "share"), "", String.localizedString(key: "driver_mode")]
    var userMenuIcons = [UIImage(named: "city"), UIImage(named: "history"), UIImage(named: "intercity"), UIImage(named: "cargo"), UIImage(named: "special_equipment"), UIImage(named: "ic_moto")?.withRenderingMode(.alwaysTemplate), UIImage(named: "call-feedback"), UIImage(named: "notifications"), UIImage(named: "share-1")?.withRenderingMode(.alwaysTemplate), UIImage(), UIImage(named: "driver_mode")]
    
    var driverMenuItems = [String.localizedString(key: "city"), String.localizedString(key: "history"), String.localizedString(key: "intercity"), String.localizedString(key: "cargo"), String.localizedString(key: "special_eqipment"), String.localizedString(key: "moto"),  String.localizedString(key: "contactUs"), String.localizedString(key: "notifications"), String.localizedString(key: "share"), "", String.localizedString(key: "driver_mode")]
    var driverMenuIcons = [UIImage(named: "city"), UIImage(named: "history"), UIImage(named: "intercity"), UIImage(named: "cargo"), UIImage(named: "special_equipment"), UIImage(named: "ic_moto")!.withRenderingMode(.alwaysTemplate), UIImage(named: "call-feedback"), UIImage(named: "notifications"), UIImage(named: "share-1")?.withRenderingMode(.alwaysTemplate), UIImage(), UIImage(named: "driver_mode")]
    
//    let backgroundImage : UIImageView = {
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "menu_background"))
//        return imageView
//    }()
    
    let profileView : UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 80
        return view
    }()
    
    let nameOfUserLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    let phoneNumberLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    lazy var userAvatar: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "profile_image-1")
        image.layer.cornerRadius = 40
        image.layer.masksToBounds = true
        return image
    }()
    
    lazy var profileButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.localizedString(key: "profile"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.contentMode = .left
        button.addTarget(self, action: #selector(handleProfileSettings), for: .touchUpInside)
        return button
    }()

//    lazy var promotionalCodeLabel: UILabel = {
//        let label = UILabel()
//        label.font = .boldSystemFont(ofSize: 16)
//        label.textColor = .white
//        return label
//    }()
    
    let bonus : UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(addBonus), for: .touchUpInside)
        return button
    }()

    lazy var promocodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Activate promocode", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.contentMode = .left
        button.addTarget(self, action: #selector(promocodeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var menuItemsTableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    @objc func handleProfileSettings() {
        if let slideMenu = revealViewController() {
            var navController = UINavigationController()
            if driverModeIsOn {
                let driverProfileController = DriverProfileController()
                driverProfileController.user = user
                navController = UINavigationController(rootViewController: driverProfileController)
            } else {
                let userProfileController = ProfileViewController()
                userProfileController.user = user
                navController = UINavigationController(rootViewController: userProfileController)
            }
            slideMenu.pushFrontViewController(navController, animated: true)
        }
    }

    func sharePromo() {
        let itunesLink = Constant.api.itunesLink
        if driverModeIsOn {
            if let promo = user?.promo_code {
                let activityViewController = UIActivityViewController(activityItems: [.localizedString(key: "promo_text_1") + promo + .localizedString(key: "promo_text_2") + itunesLink], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view

                present(activityViewController, animated: true, completion: nil)
            }
        } else {
            let activityViewController = UIActivityViewController(activityItems: ["Go to " + itunesLink + " and download QazTaxi app"], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view

            present(activityViewController, animated: true, completion: nil)
        }
    }

    @objc func promocodeButtonPressed(){
        let alertController = PromocodeViewController()
        alertController.afterCompletion = { [weak self] in
            guard let `self` = self else {return}
            self.fetchUserData()
        }
        alertController.modalTransitionStyle = .crossDissolve
        alertController.modalPresentationStyle = .overCurrentContext
        self.present(alertController, animated: true, completion: nil)
    }

    @objc func addBonus() {
        processPayment()
    }


    private func processPayment() {
        if let slideMenu = revealViewController() {
            let alert = UIAlertController(title: String.localizedString(key: "sum"), message: nil, preferredStyle: .alert)

            alert.addTextField { (textField) in
                textField.textAlignment = .center
                textField.font = .systemFont(ofSize: 17)
                textField.keyboardType = .numberPad
            }

            let alertBtn = UIAlertAction(title: .localizedString(key: "cancel"), style: .cancel) { (action) in
            }

            let cancelBtn = UIAlertAction(title: .localizedString(key: "pay"), style: .default) { (action) in
                let textField = alert.textFields![0]

                if textField.text! != "" {
                    let token = UserDefaults.standard.string(forKey: "token")!
                    let url = Constant.api.bonus + token + "&amount=\(textField.text!)"

                    Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                        if response.result.isSuccess {
                            if let value = response.result.value {
                                let json = JSON(value)
                                print("Bonus: \(json)")
                                let vc = PayBoxViewController()
                                let navC = UINavigationController(rootViewController: vc)
                                vc.url = json["data"]["authorization_url"].stringValue
                                slideMenu.rearViewController.present(navC, animated: true, completion: nil)
                            }
                        }
                    })
                }
            }
            alert.addAction(alertBtn)
            alert.addAction(cancelBtn)
            alert.preferredAction = cancelBtn

            slideMenu.rearViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func addBonusAction(sum: String) {
        if sum != "" {
            let token = UserDefaults.standard.string(forKey: "token")!
            let url = Constant.api.bonus + token + "&amount=\(sum)"
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        let vc = PayBoxViewController()
                        let navC = UINavigationController(rootViewController: vc)
                        vc.url = json["result"].stringValue
                        self.present(navC, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    func setupViews() {
        view.addSubview(profileView)
        view.addSubview(menuItemsTableView)
        profileView.addSubview(userAvatar)
        profileView.addSubview(phoneNumberLabel)
        profileView.addSubview(nameOfUserLabel)
        profileView.addSubview(profileButton)

        profileView.snp.makeConstraints({ (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalToSuperview()
            }
            make.right.equalToSuperview().offset(-40)
            make.left.equalToSuperview().offset(-80)
            make.width.equalTo(view.bounds.width + 40)
            make.height.equalTo(200)
        })

        userAvatar.snp.makeConstraints { (make) in
            make.left.equalTo(95)
            make.centerY.equalToSuperview().offset(-10)
            make.height.width.equalTo(80)
        }
        
        menuItemsTableView.snp.makeConstraints({ (make) in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        })
        
        phoneNumberLabel.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview().offset(10)
            make.left.equalTo(userAvatar.snp.right).offset(12)
            make.right.equalTo(-15)
        })
        
        nameOfUserLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(userAvatar.snp.right).offset(12)
            make.right.equalTo(-15)
            make.bottom.equalTo(phoneNumberLabel.snp.top).offset(-5)
        })
        
        profileButton.snp.makeConstraints({ (make) in
            make.top.equalTo(userAvatar.snp.bottom).offset(10)
            make.centerX.equalTo(userAvatar)
        })

        profileView.addSubview(bonus)

        bonus.snp.makeConstraints({ (make) in
            make.centerY.equalTo(profileButton)
            make.right.equalTo(-15)
        })

        profileView.addSubview(promocodeButton)
        promocodeButton.snp.makeConstraints { (promocodeButton) in
            promocodeButton.bottom.equalToSuperview().offset(-10)
            promocodeButton.left.equalTo(profileButton)
        }

    }
    
    func switchToDriverMode(isOn : Bool, completion: ((Bool) -> ())) {
        indicator.show()
        driverModeIsOn = isOn
        
        guard let driverWas = user?.driver_was else {
            indicator.showError(withStatus: "Please, try again.")
            completion(false)
            return }
        
        if driverWas == 0 {
            if isOn {
                if let slideMenu = revealViewController() {
                    let driverProfileController = DriverProfileController()
                    driverProfileController.user = user
                    let navController = UINavigationController(rootViewController: driverProfileController)
                    slideMenu.pushFrontViewController(navController, animated: true)
                    driverModeIsOn = false
                }
            } else {
                if let slideMenu = revealViewController() {
                    let homeViewController = HomeViewController()
                    homeViewController.user = user
                    let navController = UINavigationController(rootViewController: homeViewController)
                    slideMenu.pushFrontViewController(navController, animated: true)
                }
            }
        } else {
            if isOn {
                if let token = UserDefaults.standard.string(forKey: "token") {
                    Alamofire.request(Constant.api.transition, method: .post, parameters: [ "token" : token, "role" : 2 ], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                        if response.result.isSuccess {
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                if json["statusCode "].intValue == Constant.statusCode.success {
                                    if let slideMenu = self.revealViewController() {
                                        let driverHomeController = DriverHomeController()
                                        driverHomeController.user = self.user
                                        let navController = UINavigationController(rootViewController: driverHomeController)
                                        slideMenu.pushFrontViewController(navController, animated: true)
                                        self.driverModeIsOn = false
                                        self.driverModeIsOn = true
                                    }
                                } else {
                                    indicator.showError(withStatus: "Error")
                                    indicator.dismiss(withDelay: 1.5)
                                }
                            }
                        }
                    })
                }
            } else {
                if let token = UserDefaults.standard.string(forKey: "token") {
                    Alamofire.request(Constant.api.transition, method: .post, parameters: [ "token" : token, "role" : 1 ], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                        if response.result.isSuccess {
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                if json["statusCode "].intValue == Constant.statusCode.success {
                                    if let slideMenu = self.revealViewController() {
                                        let homeViewController = HomeViewController()
                                        homeViewController.user = self.user
                                        let navController = UINavigationController(rootViewController: homeViewController)
                                        slideMenu.pushFrontViewController(navController, animated: true)
                                    }
                                } else {
                                    indicator.showError(withStatus: "Error")
                                    indicator.dismiss(withDelay: 1.5)
                                }
                            }
                        }
                    })
                }
            }
        }
        
        menuItemsTableView.reloadData()
    }
    
    func fetchUserData() {
        if let phone = UserDefaults.standard.string(forKey: "phoneNumber") {
            User.authUser(body: ["phone" : phone.removingWhitespaces()], completion: { (result, user, statusCode) in
                if statusCode == Constant.statusCode.success {
                    self.user = user
                    self.nameOfUserLabel.text = user.name
                    self.phoneNumberLabel.text = "\(user.phone!)"
//                    self.promotionalCodeLabel.text = "Promocode \(user.promo_code!)"
                    self.checkForPromocodeAccess()
                    if let balanse = user.balanse {
                        self.bonus.setTitle("\(balanse)₸", for: .normal)
                    }
                    print("IMAGEEE ", user.avatar)

                    if user.avatar != "http://185.111.106.48/no image" {
//                            DispatchQueue.main.async {
                                self.userAvatar.kf.setImage(with: user.avatar?.url)
//                            }
                    } else {
                        self.userAvatar.image = #imageLiteral(resourceName: "profile_image-1")
                    }
                    UserDefaults.standard.set(user.token, forKey: "token")
                    UserDefaults.standard.set(user.promo_code, forKey: "promoCode")
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.bool(forKey: "driverWas") {
            if UserDefaults.standard.bool(forKey: "isUserInDriverMode") {
                driverModeIsOn = true
            } else {
                driverModeIsOn = false
            }
        } else {
            driverModeIsOn = false
        }
        
        view.backgroundColor = .white
        
        menuItemsTableView.register(MenuCell.self, forCellReuseIdentifier: menuCellID)
        
        setupViews()
        
//        if let name = user?.name, let phone = user?.phone, let balance = user?.balanse {
//            nameOfUserLabel.text = name
//            phoneNumberLabel.text = phone
//            bonus.setTitle("\(balance)₸", for: .normal)
//        }
        
    }

    func checkForPromocodeAccess(){
        if let promocode_access = user?.promo_code_access {
            switch promocode_access {
            case 0:
                promocodeButton.isHidden = true
                profileView.snp.remakeConstraints({ (make) in
                    if #available(iOS 11.0, *) {
                        make.top.equalTo(view.safeAreaLayoutGuide)
                    } else {
                        make.top.equalToSuperview()
                    }
                    make.right.equalToSuperview().offset(-40)
                    make.left.equalToSuperview().offset(-80)
                    make.width.equalTo(view.bounds.width + 40)
                    make.height.equalTo(190)
                })
                break
            default:
                promocodeButton.isHidden = false
                profileView.snp.remakeConstraints({ (make) in
                    if #available(iOS 11.0, *) {
                        make.top.equalTo(view.safeAreaLayoutGuide)
                    } else {
                        make.top.equalToSuperview()
                    }
                    make.right.equalToSuperview().offset(-40)
                    make.left.equalToSuperview().offset(-80)
                    make.width.equalTo(view.bounds.width + 40)
                    make.height.equalTo(240)
                })
                break
            }
        }
        checkIfIsDriver()
    }

    func checkIfIsDriver(){
        if UserDefaults.standard.bool(forKey: "isUserInDriverMode"){
            bonus.isHidden = false
            profileView.snp.remakeConstraints({ (make) in
                if #available(iOS 11.0, *) {
                    make.top.equalTo(view.safeAreaLayoutGuide)
                } else {
                    make.top.equalToSuperview()
                }
                make.right.equalToSuperview().offset(-40)
                make.left.equalToSuperview().offset(-80)
                make.width.equalTo(view.bounds.width + 40)
                make.height.equalTo(240)
            })
        } else {
            bonus.isHidden = true
            promocodeButton.isHidden = true
            profileView.snp.remakeConstraints({ (make) in
                if #available(iOS 11.0, *) {
                    make.top.equalTo(view.safeAreaLayoutGuide)
                } else {
                    make.top.equalToSuperview()
                }
                make.right.equalToSuperview().offset(-40)
                make.left.equalToSuperview().offset(-80)
                make.width.equalTo(view.bounds.width + 40)
                make.height.equalTo(190)
            })
        }
    }
    
    func changeViewController(menu : UserLeftMenu) {
        if let slideMenu = revealViewController() {
            switch menu {
            case .city:
                print("city")
                let homeController = HomeViewController()
                let navController = UINavigationController(rootViewController: homeController)
                slideMenu.pushFrontViewController(navController, animated: true)
                break
            case .history:
                print("history")
                let historyController = HistoryViewController()
                let navController = UINavigationController(rootViewController: historyController)
                slideMenu.pushFrontViewController(navController, animated: true)
                break
            case .intercity:
                print("intercity")
                let navController = UINavigationController(rootViewController: IntercityViewController())
                slideMenu.pushFrontViewController(navController, animated: true)
                break
//            case .vip:
//                print("toy")
//                let navController = UINavigationController(rootViewController: ToyTaxiViewController())
//                slideMenu.pushFrontViewController(navController, animated: true)
//                break
            case .special:
                print("special")
                let navController = UINavigationController(rootViewController: SpecialViewController())
                slideMenu.pushFrontViewController(navController, animated: true)
                break
            case .cargo:
                print("cargo")
                let navController = UINavigationController(rootViewController: CargoViewController())
                slideMenu.pushFrontViewController(navController, animated: true)
                break
            case .moto:
                print("moto")
                let navController = UINavigationController(rootViewController: MotoViewController())
                slideMenu.pushFrontViewController(navController, animated: true)
                break
//            case .friends:
//                print("friends")
//                let friendsController = FriendLocationViewController()
//                let navController = UINavigationController(rootViewController: friendsController)
//                slideMenu.pushFrontViewController(navController, animated: true)
//                break
            case .share:
                print("share")
                sharePromo()
                break
            case .notifications:
                print("notifications")
                let navController = UINavigationController(rootViewController: NotificationsViewController())
                slideMenu.pushFrontViewController(navController, animated: true)
                break
//            case .help:
//                print("help")
//                let navController = UINavigationController(rootViewController: HelpController())
//                slideMenu.pushFrontViewController(navController, animated: true)
//                break
            case .contactUs:
                let vc = ContactUsController()
                let navC = UINavigationController(rootViewController: vc)
                slideMenu.pushFrontViewController(navC, animated: true)
                break
            default:
                break
            }
        }
    }
    
    func changeViewController(menu : DriverLeftMenu) {
        if let slideMenu = revealViewController() {
            slideMenu.navigationController?.popViewController(animated: true)
            switch menu {
            case .city:
                print("city")
                let navController = UINavigationController(rootViewController: DriverHomeController())
                slideMenu.pushFrontViewController(navController, animated: true)
                break
            case .history:
                print("history")
                let navController = UINavigationController(rootViewController: DriverHistoryViewController())
                slideMenu.pushFrontViewController(navController, animated: true)
                break
            case .intercity:
                print("intercity")
                let navController = UINavigationController(rootViewController: DriverIntercityController())
                slideMenu.pushFrontViewController(navController, animated: true)
                break
//            case .vip:
//                print("vip")
//                let navController = UINavigationController(rootViewController: DriverToyTaxiViewController())
//                slideMenu.pushFrontViewController(navController, animated: true)
//                break
            case .special:
                print("special")
                let navController = UINavigationController(rootViewController: DriverSpecialViewController() )
                slideMenu.pushFrontViewController(navController, animated: true)
                break
            case .cargo:
                print("cargo")
                let navController = UINavigationController(rootViewController: DriverCargoViewController() )
                slideMenu.pushFrontViewController(navController, animated: true)
                break
            case .moto:
                print("moto")
                let navController = UINavigationController(rootViewController: DriverMotoViewController())
                slideMenu.pushFrontViewController(navController, animated: true)
                break
//            case .friends:
//                print("friends")
//                let navController = UINavigationController(rootViewController: FriendLocationViewController())
//                slideMenu.pushFrontViewController(navController, animated: true)
//                break
            case .share:
                print("share")
                sharePromo()
                break
            case .notifications:
                print("notifications")
                let navController = UINavigationController(rootViewController: NotificationsViewController())
                slideMenu.pushFrontViewController(navController, animated: true)
                break
//            case .help:
//                print("help")
//                let navController = UINavigationController(rootViewController: HelpController())
//                slideMenu.pushFrontViewController(navController, animated: true)
//                break
            case .contactUs:
                let vc = ContactUsController()
                let navC = UINavigationController(rootViewController: vc)
                slideMenu.pushFrontViewController(navC, animated: true)
                break
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuItemsTableView.dequeueReusableCell(withIdentifier: menuCellID, for: indexPath) as! MenuCell
        cell.delegate = self
        
        if driverModeIsOn {
            cell.textLabel?.text = driverMenuItems[indexPath.row]
            cell.textLabel?.textColor = .blue
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//            if indexPath.row == 0 {
//                cell.detailTextLabel?.text = cityName
//            } else {
//                cell.detailTextLabel?.text = nil
//            }
            cell.iconImage.image = driverMenuIcons[indexPath.row]?.withRenderingMode(.alwaysTemplate)
            cell.iconImage.tintColor = .blue
            
            if indexPath.row != 10 {
                cell.driverModeSwitcher.removeFromSuperview()
                if indexPath.row == 9 {
                    cell.iconImage.removeFromSuperview()
                    cell.textLabel?.snp.makeConstraints({ (make) in
                        make.left.equalToSuperview().offset(15)
                        make.centerY.equalToSuperview()
                    })
                    let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
                    let underlineAttributedString = NSAttributedString(string: promocode, attributes: underlineAttribute)
                    cell.textLabel!.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                    cell.textLabel?.attributedText = underlineAttributedString
                }
            } else {
                cell.iconImage.removeFromSuperview()
                cell.textLabel?.snp.makeConstraints({ (make) in
                    make.left.equalToSuperview().offset(15)
                    make.centerY.equalToSuperview()
                })
                cell.setDriverModeSwitcher()
                cell.driverModeSwitcher.isOn = true
                UserDefaults.standard.set(true, forKey: "isUserInDriverMode")
            }
        } else {
            cell.textLabel?.text = userMenuItems[indexPath.row]
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//            if indexPath.row == 0 {
//                cell.detailTextLabel?.text = cityName
//            } else {
//                cell.detailTextLabel?.text = nil
//            }
            cell.iconImage.image = userMenuIcons[indexPath.row]?.withRenderingMode(.alwaysTemplate)
            cell.iconImage.tintColor = .blue
            
            if indexPath.row != 10 {
                cell.driverModeSwitcher.removeFromSuperview()
                if indexPath.row == 9 {
                    cell.iconImage.removeFromSuperview()
                    cell.textLabel?.snp.makeConstraints({ (make) in
                        make.left.equalToSuperview().offset(15)
                        make.centerY.equalToSuperview()
                    })
                    let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.foregroundColor: UIColor.gray] as [NSAttributedStringKey : Any]
                    let underlineAttributedString = NSAttributedString(string: promocode, attributes: underlineAttribute)
                    cell.textLabel!.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                    cell.textLabel?.attributedText = underlineAttributedString
//                    cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 11)
                }
            } else {
                cell.iconImage.removeFromSuperview()
                cell.textLabel?.snp.makeConstraints({ (make) in
                    make.left.equalToSuperview().offset(15)
                    make.centerY.equalToSuperview()
                })
                cell.setDriverModeSwitcher()
                cell.driverModeSwitcher.isOn = false
                UserDefaults.standard.set(false, forKey: "isUserInDriverMode")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("IndexPath: \(indexPath)")
        if driverModeIsOn {
            if let menu = DriverLeftMenu(rawValue: indexPath.row + 1) {
                changeViewController(menu: menu)
            }
        } else {
            if let menu = UserLeftMenu(rawValue: indexPath.row + 1) {
                changeViewController(menu: menu)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 9 {
            return 45
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if driverModeIsOn {
            return 11
        } else {
            return 11
        }
    }
}
