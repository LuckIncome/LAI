//
//  DriverSubscriptionResponse.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 8/14/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import Foundation

class DriverSubscriptionResponse: Codable {
    var statusCode: Int
    var message: String
    var result: DriverSubscription
    
    private enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode "
        case message
        case result
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = try values.decode(Int.self, forKey: .statusCode)
        self.message = try values.decode(String.self, forKey: .message)
        self.result = try values.decode(DriverSubscription.self, forKey: .result)
    }
    
    class AccessDate: Codable {
        var date: String
    }
    
    class DriverSubscription: Codable {
        var accessDate: AccessDate
        var token: String
        var online: Int
        
        private enum CodingKeys: String, CodingKey {
            case accessDate = "access_date"
            case token
            case online
        }
        
        required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.accessDate = try values.decode(AccessDate.self, forKey: .accessDate)
            self.token = try values.decode(String.self, forKey: .token)
            self.online = try values.decode(Int.self, forKey: .online)
        }
    }
}
