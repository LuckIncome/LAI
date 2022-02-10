//
//  ConfirmAuthViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/12/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit
import InputMask
import Firebase
import Alamofire
import SVProgressHUD

class ConfirmAuthViewController : UIViewController, MaskedTextFieldDelegateListener {
    
    var maskedDelegate : MaskedTextFieldDelegate?
    var user : User?
    var statusCode = Constant.statusCode.notFound
    var phone : String?
    
    let messageTextField = Helper.createInputField(withPlaceholder: .localizedString(key: "smsCode"), errorText: "")
    
    let authLabel : UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "authCode")
        label.font =  UIFont.systemFont(ofSize: 16, weight: .heavy)
        return label
    }()
    
    lazy var doneButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.localizedString(key: "ready"), for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDone() {
//        if let verificationID = UserDefaults.standard.string(forKey: "vID"), let verificationCode = messageTextField.text {
//            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
//            SVProgressHUD.setDefaultMaskType(.black)
//            SVProgressHUD.show()
//            if let phone = phone {
//                if phone.removingWhitespaces() == "+77004747343" {
//                    User.authUser(body: ["phone" : phone.removingWhitespaces()], completion: { (result, user, statusCode) in
//                        self.user = user
//                        self.statusCode = statusCode
//                        if let token = user.token {
//                            Messaging.messaging().subscribe(toTopic: "/topics/\(token)")
//                        }
//                        SVProgressHUD.dismiss()
//                        if statusCode == Constant.statusCode.notFound {
//                            let regController = RegisterViewController()
//                            regController.phone = self.phone
//                            self.navigationController?.pushViewController(regController, animated: true)
//                        } else {
//                            print("Logged in")
//                            let navController = UINavigationController(rootViewController: HomeViewController())
//                            let leftController = LeftMenuController()
//                            leftController.user = self.user
//                            let slideController = SWRevealViewController(rearViewController: leftController, frontViewController: navController)
//                            UIApplication.shared.keyWindow?.rootViewController = slideController
//                            self.dismiss(animated: true) {
//                                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
//                            }
//                        }
//                    })
//                } else {
//                    Auth.auth().signIn(with: credential, completion: { (user, error) in
//                        if error != nil {
//                            print(error!)
//                            SVProgressHUD.dismiss()
//                            SVProgressHUD.showError(withStatus: String.localizedString(key: "error"))
//                            SVProgressHUD.dismiss(withDelay: 0.5)
//                            return
//                        } else {
//                            if let phoneNumber = self.phone {
//                                User.authUser(body: ["phone" : phoneNumber.removingWhitespaces()], completion: { (result, user, statusCode) in
//                                    self.user = user
//                                    self.statusCode = statusCode
//                                    if let token = user.token {
//                                        Messaging.messaging().subscribe(toTopic: "/topics/\(token)")
//                                    }
//                                    print(statusCode)
//                                    SVProgressHUD.dismiss()
//                                    if statusCode == Constant.statusCode.notFound {
//                                        let regController = RegisterViewController()
//                                        regController.phone = self.phone
//                                        self.navigationController?.pushViewController(regController, animated: true)
//                                    } else {
//                                        print("Logged in")
//                                        let navController = UINavigationController(rootViewController: HomeViewController())
//                                        let leftController = LeftMenuController()
//                                        leftController.user = self.user
//                                        let slideController = SWRevealViewController(rearViewController: leftController, frontViewController: navController)
//                                        UIApplication.shared.keyWindow?.rootViewController = slideController
//                                        self.dismiss(animated: true) {
//                                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
//                                        }
//                                    }
//                                })
//                            }
//                        }
//                    })
//                }
//            }
//        }
        if let phone = phone, let verificationCode = messageTextField.text {
            SVProgressHUD.show()
            User.verifyCode(body: ["phone": phone.removingWhitespaces(), "verification_code": verificationCode]) { user, statusCode in
                self.user = user
                self.statusCode = statusCode
                print(statusCode)
                SVProgressHUD.dismiss()
                if statusCode == Constant.statusCode.success {
                    let regController = RegisterViewController()
                    regController.phone = self.phone
                    regController.code = verificationCode
                    self.navigationController?.pushViewController(regController, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        maskedDelegate = MaskedTextFieldDelegate(primaryFormat: "[0000]")
        maskedDelegate?.listener = self
        messageTextField.delegate = maskedDelegate
        messageTextField.keyboardType = .numberPad
        
        view.addSubview(messageTextField)
        view.addSubview(authLabel)
        view.addSubview(doneButton)
        
        messageTextField.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-100)
            make.left.equalTo(30)
            make.right.equalTo(-50)
        }
        authLabel.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.bottom.equalTo(messageTextField.snp.top).offset(-15)
        }
        doneButton.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.bottom.equalTo(-70)
            make.height.equalTo(45)
        }
    }
}
