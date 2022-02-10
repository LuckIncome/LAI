//
//  UserHistoryAddress.swift
//  BidKab
//
//  Created by Eldor Makkambayev on 8/29/19.
//  Copyright © 2019 Nursultan Zhiyembay. All rights reserved.
//

import Foundation
class UserHistoryAddress: Codable {
    var from: String
    var from_lat: Double
    var from_lon: Double
    
    init(from: String, from_lat: Double, from_lon: Double) {
        self.from = from
        self.from_lat = from_lat
        self.from_lon = from_lon
    }
}
