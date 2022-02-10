//
//  PaymentType.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 9/7/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol PaymentType {
    var controller: PaymentVC? { get set }
    init(vc: PaymentVC)
    var title: String { get }
    func processPayment()
}
