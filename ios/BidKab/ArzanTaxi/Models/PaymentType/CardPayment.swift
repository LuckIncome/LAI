//
//  CardPayment.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 9/7/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CardPayment: PaymentType {
    weak var controller: PaymentVC?
    
    var title: String {
        return .localizedString(key: "balanceCard")
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
                            self.controller?.present(navC, animated: true, completion: nil)
                        }
                    }
                })
            }
        }
        alert.addAction(alertBtn)
        alert.addAction(cancelBtn)
        alert.preferredAction = cancelBtn
        
        self.controller?.present(alert, animated: true, completion: nil)
    }
}
