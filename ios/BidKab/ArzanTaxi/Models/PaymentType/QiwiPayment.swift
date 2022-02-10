//
//  QiwiPayment.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 9/7/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire

class QiwiPayment: PaymentType {
    weak var controller: PaymentVC?
    
    var title: String {
        return .localizedString(key: "balanceQiwi")
    }
    
    required init(vc: PaymentVC) {
        self.controller = vc
    }
    
    func processPayment() {
        var images: [UIImage]
        images = [1, 2, 3, 4, 5].map { UIImage(named: "qiwi\($0)")! }
        let vc = InstructionsController(images: images)
        let backButtonItem = UIBarButtonItem()
        backButtonItem.title = String.localizedString(key: "back")
        controller?.navigationItem.backBarButtonItem = backButtonItem
        vc.title = "QIWI"
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
}
