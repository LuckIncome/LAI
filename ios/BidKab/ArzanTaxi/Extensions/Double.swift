//
//  Double.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 8/29/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import Foundation

extension Double {
    func getBonus() -> Int {
        return Int(self / 10)
    }
    
    func getRemainder() -> Int {
        return Int(self) - getBonus()
    }
}
