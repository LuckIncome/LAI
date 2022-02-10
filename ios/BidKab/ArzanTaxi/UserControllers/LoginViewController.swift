//
//  LoginViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/30/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit
import MaterialTextField
import InputMask
import Alamofire
import SwiftyJSON
import SVProgressHUD
import FirebaseMessaging

protocol ConfidentialAnswer{
    func confidentialReceive(isAccepted: Bool)
}

class LoginViewController : UIViewController, MaskedTextFieldDelegateListener, ConfidentialAnswer {
    
    var maskedDelegate : MaskedTextFieldDelegate?
    var user : User?
    var statusCode = Constant.statusCode.notFound
    var phone: String?
//    var accountKit: AKFAccountKit!
    
    let phoneNumber = Helper.createInputField(withPlaceholder: String.localizedString(key: "phone_number"), errorText: "")
    
    lazy var continueButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.localizedString(key: "continue"), for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleContinueButton() {
        if let phoneNumber = phoneNumber.text {
            if phoneNumber.count == 16 {
                self.phoneNumber.setError(nil, animated: true)
//                let controller = ConfidentialViewController()
//                controller.delegate = self
//                self.navigationController?.pushViewController(controller, animated: true)
                phone = phoneNumber
                moveToNext()
            } else {
                self.phoneNumber.setError(NSError(domain: "Fill the field", code: 1, userInfo: nil), animated: true)
            }
        }
    }

    func confidentialReceive(isAccepted: Bool) {
        if isAccepted {
//            confirmPhoneNumber()
        } 
    }

//    private func confirmPhoneNumber(){
//        if let phoneNumber = phoneNumber.text {
//            self.phone = String(phoneNumber.suffix(phoneNumber.count-1))
//            print(phoneNumber.removingWhitespaces())
//            let akfPhoneNumber = AKFPhoneNumber(countryCode: "7", phoneNumber: String(phoneNumber.suffix(phoneNumber.count-2)))
//            let inputState = UUID().uuidString
//            let controller = accountKit.viewControllerForPhoneLogin(with: akfPhoneNumber, state: inputState)
//            controller.delegate = self
//            controller.isEditing = false
//            controller.setAdvancedUIManager(MyUIManager())
//            self.present(controller, animated: true, completion: nil)
//        }
//    }

    func setupViews() {
        view.addSubview(phoneNumber)
        
        view.addSubview(continueButton)
        
        phoneNumber.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.left.equalTo(50)
            make.right.equalTo(-70)
        }
        
        continueButton.snp.makeConstraints { (make) in
            make.left.equalTo(70)
            make.right.equalTo(-70)
            make.height.equalTo(45)
            make.bottom.equalTo(-20)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if accountKit == nil {
//            accountKit = AKFAccountKit(responseType: .accessToken)
//        }
        
        view.backgroundColor = .white
        navigationItem.title = "QazTaxi"
        
        maskedDelegate = MaskedTextFieldDelegate(primaryFormat: "{+7} [000] [000] [00] [00]")
        maskedDelegate?.listener = self
        phoneNumber.delegate = maskedDelegate
        phoneNumber.errorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        phoneNumber.keyboardType = .phonePad
        
        setupViews()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        maskedDelegate?.put(text: "+7", into: phoneNumber)
    }

    func moveToNext(){
        if let phone = phone {
            SVProgressHUD.show()
            User.authUser(body: ["phone" : phone.removingWhitespaces()], completion: { (result, user, statusCode) in
                self.user = user
                self.statusCode = statusCode

                if let token = user.token {
                    Messaging.messaging().subscribe(toTopic: "/topics/\(token)")
                }

                print(statusCode)

                SVProgressHUD.dismiss()

                if statusCode == Constant.statusCode.notFound {
                    let regController = ConfirmAuthViewController()//RegisterViewController()
                    regController.phone = self.phone
                    
                    self.navigationController?.pushViewController(regController, animated: true)
                } else {
                    print("Logged in")

                    UserDefaults.standard.set(self.phone!, forKey: "phoneNumber")
                    let navController = UINavigationController(rootViewController: HomeViewController())
                    let leftController = LeftMenuController()
                    leftController.user = self.user
                    let slideController = SWRevealViewController(rearViewController: leftController, frontViewController: navController)
                    UIApplication.shared.keyWindow?.rootViewController = slideController

                    self.dismiss(animated: true) {
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    }
                }
            })
        }
    }

}

//extension LoginViewController: AKFViewControllerDelegate {
//    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
//        moveToNext()
//    }
//
//    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
//        print("ERror: \(error.localizedDescription)")
//    }
//}
//
//class MyUIManager: NSObject, AKFAdvancedUIManager {
//
//    let screenSize = UIScreen.main.bounds
//
//    func bodyView(for state: AKFLoginFlowState) -> UIView? {
//        let view = UIView()
//        view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.1).isActive = true
//        view.backgroundColor = .clear
//        return view
//    }
//
//    func setActionController(_ actionController: AKFActionController) {
//
//    }
//
//    func actionBarView(for state: AKFLoginFlowState) -> UIView? {
//        let view = UILabel()
//        view.text = "BidKab"
//        view.textColor = .white
//        view.textAlignment = .center
//        view.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
//        view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.10).isActive = true
//        view.backgroundColor = .blue
//        return view
//    }
//
//    func headerView(for state: AKFLoginFlowState) -> UIView? {
//        let view = UIView()
//        view.heightAnchor.constraint(equalToConstant: screenSize.height * 0.15).isActive = true
//        view.backgroundColor = .clear
//        return view
//    }
//
//    func footerView(for state: AKFLoginFlowState) -> UIView? {
//        let view = UIView()
//        view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.15).isActive = true
//        view.backgroundColor = .clear
//        return view
//    }
//
//    func theme() -> AKFTheme? {
//        let theme = AKFTheme.default()
//        theme.backgroundColor = .white
//        theme.buttonBackgroundColor = .blue
//        theme.buttonDisabledBackgroundColor = .blue
//        theme.buttonTextColor = .white
//        theme.buttonBorderColor = .clear
//        theme.inputTextColor = .black
//        theme.textColor = .lightGray
//        theme.titleColor = .lightGray
//        theme.statusBarStyle = .lightContent
//        theme.inputBackgroundColor = #colorLiteral(red: 0.968690514, green: 0.968690514, blue: 0.968690514, alpha: 1)
//        return theme
//    }
//
//    func setError(_ error: Error) {
//
//    }
//
//    func buttonType(for state: AKFLoginFlowState) -> AKFButtonType {
//        return .next
//    }
//
//    func textPosition(for state: AKFLoginFlowState) -> AKFTextPosition {
//        return .aboveBody
//    }
//
//}
