//
//  Time.swift
//  WHPH
//
//  Created by Devin Green on 3/30/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation

class Time: Equatable {
    private var _underlyingDate: Date
    var underlyingDate: Date {
        return _underlyingDate
    }
    var comparisonDate: Date {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .full

        let timeString = timeFormatter.string(from: _underlyingDate)
        if let date = timeFormatter.date(from: timeString){
            return date
        }
        return Date()
    }
    
    var dateString: String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: underlyingDate).appending("Z")
    }
    
    var string: String{
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        return formatter.string(from: underlyingDate)
    }
    var stringNoHrPeriod: String {
        return String(self.string.split(separator: " ")[0])
    }
    var hrPeriod: String {
        return String(self.string.split(separator: " ")[1])
    }
    
    init() {
        _underlyingDate = Date()
    }
    
    init(_ timeString: String){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        _underlyingDate = dateFormatter.date(from: timeString) ?? Date()
    }
    
    init(_ date: Date){
        _underlyingDate = date
    }
    
    static func ==(lhs: Time, rhs: Time) -> Bool {
        return lhs.comparisonDate == rhs.comparisonDate
    }
    
    static func < (lhs: Time, rhs: Time) -> Bool {
        return lhs.comparisonDate < rhs.comparisonDate
    }
    
    static func > (lhs: Time, rhs: Time) -> Bool {
        return lhs.comparisonDate > rhs.comparisonDate
    }
}

extension Date{
    var WHPHString: (time: String, hrPeriod: String) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        let timeStr: String = String(formatter.string(from: self).split(separator: " ")[0])
        let hrString: String = String(formatter.string(from: self).split(separator: " ")[1])

        return (time: timeStr, hrPeriod: hrString)
    }
}
