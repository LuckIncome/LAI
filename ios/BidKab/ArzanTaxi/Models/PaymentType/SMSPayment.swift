//
//  SMSPayment.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 9/7/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SMSPayment: PaymentType {
    weak var controller: PaymentVC?
    var amount = 0
    
    var title: String {
        return .localizedString(key: "balanceSMS")
    }
    
    required init(vc: PaymentVC) {
        self.controller = vc
    }
    
    func processPayment() {
        let alertVC = UIAlertController(title: String.localizedString(key: "sum"), message: nil, cancelButtonTitle: .localizedString(key: "cancel"), okButtonTitle: .localizedString(key: "pay"), validate: TextValidationRule.predicate({ (text) -> Bool in
            Int(text) != nil
        }), textFieldConfiguration: { (textField) in
            textField.placeholder = .localizedString(key: "amount")
            textField.textAlignment = .center
            textField.font = .systemFont(ofSize: 17)
            textField.keyboardType = .numberPad
        }) { (result) in
            guard case let .ok(string) = result else { return }
            self.amount = Int(string)!
            let token = UserDefaults.standard.string(forKey: "token")!
            let url = Constant.api.smsPaymentFirstPart + token + "&amount=\(self.amount)"
            
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value, let _ = JSON(value).dictionaryObject as [String: Any]? {
                        indicator.showSuccess(withStatus: String.localizedString(key: "smsSent"))
                        indicator.dismiss(withDelay: 1.5)
                        self.openWoppayPayment()
                    }
                }
            })
        }
        
        self.controller?.present(alertVC, animated: true, completion: nil)
    }
    
    private func openWoppayPayment() {
        let cancelTitle = String.localizedString(key: "cancel")
        let sendTitle = String.localizedString(key: "send")
        
        let alertVC = UIAlertController(title: String.localizedString(key: "enterSMSCode"), message: nil, cancelButtonTitle: cancelTitle, okButtonTitle: sendTitle, validate: TextValidationRule.nonEmpty, textFieldConfiguration: { (textField) in
            textField.placeholder = .localizedString(key: "smsCode")
            textField.textAlignment = .center
            textField.font = .systemFont(ofSize: 17)
            textField.keyboardType = .numberPad
        }) { (result) in
            guard case let .ok(smsCode) = result else { return }
            let token = UserDefaults.standard.string(forKey: "token")!
            let url = Constant.api.bonus + token + "&amount=\(self.amount)" + "&sms_code=\(smsCode)"
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("Bonus: \(json)")
                        let vc = PayBoxViewController()
                        let navC = UINavigationController(rootViewController: vc)
                        vc.url = json["data"]["authorization_url"].stringValue
                        self.controller?.present(navC, animated: true, completion: nil)
                    }
                }
            })
        }
        self.controller?.present(alertVC, animated: true, completion: nil)
    }
}
