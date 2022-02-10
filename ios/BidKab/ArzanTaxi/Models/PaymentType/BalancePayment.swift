//
//  BalancePayment.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 9/7/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BalancePayment: PaymentType {
    weak var controller: PaymentVC?
    
    var title: String {
        return .localizedString(key: "balanceUnits")
    }
    
    required init(vc: PaymentVC) {
        self.controller = vc
    }
    
    func processPayment() {
        let alert = UIAlertController(title: String.localizedString(key: "sum"), message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.textAlignment = .center
            textField.font = .systemFont(ofSize: 17)
            textField.keyboardType = .numberPad
        }
        
        let alertBtn = UIAlertAction(title: .localizedString(key: "cancel"), style: .cancel) { (action) in
        }
        
        let cancelBtn = UIAlertAction(title: .localizedString(key: "withdraw"), style: .default) { (action) in
            let textField = alert.textFields![0]
            
            if textField.text! != "" {
                let token = UserDefaults.standard.string(forKey: "token")!
                let url = Constant.api.translate_to_price
                
                let withdrawSum = Int(textField.text!)!
                
                self.getCurrentBalance(completion: { (balance) in
                    guard balance - withdrawSum >= 100 else {
                        indicator.showError(withStatus: String.localizedString(key: "balanceUnder100"))
                        
                        return
                    }
                    
                    let body : Parameters = [
                        "token" : token,
                        "balanse": "\(textField.text!)",
                    ]
                    
                    Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                        if response.result.isSuccess {
                            if let value = response.result.value {
                                let json = JSON(value)
                                if json["statusCode "].intValue == Constant.statusCode.success {
                                    indicator.showSuccess(withStatus: String.localizedString(key: "success"))
                                    indicator.dismiss(withDelay: 1.5, completion: {
                                    })
                                } else {
                                    indicator.showError(withStatus: String.localizedString(key: "insufficientMoney"))
                                    indicator.dismiss(withDelay: 1.5, completion: {
                                    })
                                }
                            }
                        }
                    })
                })
            }
        }
        alert.addAction(cancelBtn)
        alert.addAction(alertBtn)
        alert.preferredAction = cancelBtn
        
        self.controller?.present(alert, animated: true, completion: nil)
    }
    
    private func getCurrentBalance(completion: @escaping ((Int) -> Void)) {
        guard let phone = UserDefaults.standard.string(forKey: "phoneNumber") else { return }
        User.authUser(body: ["phone" : phone.removingWhitespaces()], completion: { (result, user, statusCode) in
            if statusCode == Constant.statusCode.success {
                if let balanse = user.balanse {
                    completion(balanse)
                }
            }
        })
    }
}
