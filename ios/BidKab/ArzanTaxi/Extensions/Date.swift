//
//  Date.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 8/14/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import Foundation

extension Date {
    func incrementDate(byHours hours: Int) -> Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: hours, to: self)
        
        return date ?? self
    }
    
    func getDifferenceInSeconds(fromDate date: Date) -> Int {
        return Int(self.timeIntervalSince(date))
    }
}

//

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 3)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}

//

extension Date {
    func getString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: self)
        
        return dateString
    }
    
    func getServerDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "CAT")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: self.incrementDate(byHours: -1))
    }
    
}

extension String {
    func getDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self)!
        
        return date
    }
}

extension Int {
    func getTimerLabelText() -> String {
        let hours = self / 3600
        let minutes = self / 60 % 60
        let seconds = self % 60
        let timerLabelText = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        
        return timerLabelText
    }
}
