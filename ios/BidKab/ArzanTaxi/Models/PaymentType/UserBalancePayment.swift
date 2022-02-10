//
//  UserBalancePayment.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 9/7/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias PaymentVC = UIViewController & UITextFieldDelegate

class UserBalancePayment: PaymentType {
    weak var controller: PaymentVC?
    
    var title: String {
        return .localizedString(key: "balanceUser")
    }
    
    required init(vc: PaymentVC) {
        self.controller = vc
    }
    
    func processPayment() {
        let alert = UIAlertController(title: String.localizedString(key: "enterInfo"), message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.delegate = self.controller
            textField.font = .systemFont(ofSize: 17)
            textField.keyboardType = .numberPad
            textField.placeholder = "+77770001155"
        }
        
        alert.addTextField { (textField) in
            textField.font = .systemFont(ofSize: 17)
            textField.keyboardType = .numberPad
            textField.placeholder = String.localizedString(key: "sum")
        }
        
        let alertBtn = UIAlertAction(title: .localizedString(key: "cancel"), style: .cancel) { (action) in
        }
        
        let cancelBtn = UIAlertAction(title: .localizedString(key: "transfer"), style: .default) { (action) in
            let phone = alert.textFields![0]
            let sum = alert.textFields![1]
            
            if sum.text! != "" && phone.text!.count == 12 {
                let token = UserDefaults.standard.string(forKey: "token")!
                let url = Constant.api.translate_to_user
                let id = UserDefaults.standard.integer(forKey: "user_id")
                
                let body : Parameters = [
                    "token" : token,
                    "user_id" : id,
                    "balanse": "\(sum.text!)",
                    "phone": phone.text!
                ]
                print(body)
                
                Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                    if response.result.isSuccess {
                        if let value = response.result.value {
                            let json = JSON(value)
                            if json["statusCode "].intValue == Constant.statusCode.success {
                                indicator.showSuccess(withStatus: String.localizedString(key: "success"))
                                indicator.dismiss(withDelay: 1.5, completion: {
                                })
                            } else if json["statusCode "].intValue == 402 {
                                indicator.showError(withStatus: String.localizedString(key: "depositLimitMessage"))
                                indicator.dismiss(withDelay: 1.5)
                            } else {
                                indicator.showError(withStatus: String.localizedString(key: "insufficientMoney"))
                                indicator.dismiss(withDelay: 1.5, completion: {
                                })
                            }
                        }
                    } else {
                        print("sdfsd")
                    }
                })
            } else {
                print("phone should be a right format")
            }
        }
        alert.addAction(cancelBtn)
        alert.addAction(alertBtn)
        alert.preferredAction = cancelBtn
        
        self.controller?.present(alert, animated: true, completion: nil)
    }
}
