//
//  Alarm.swift
//  Work Hard, Play Hard
//
//  Created by Devin Green on 3/28/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import Alamofire
import SwiftUI

final class AlarmManager: ObservableObject {
    static var shared = AlarmManager()
    
    
    @Published var alarms = [Alarm]()
    
    init() {
        reload(nil)
    }
    
    func initialize(){
//        initialize
    }
    
    func reload(_ completionHandler: (() -> ())?){
        AF.request("https://api.airtable.com/v0/appJcIDCIJdhCznhF/Alarms?api_key=keycK6AVjkarbE5ZK").responseJSON { response in
            self.alarms.removeAll()
            
            if let dict = response.value as? Dictionary<String, Any>, let values = dict["records"] as? [Dictionary<String, Any>] {
                for value in values {
                    if let fields = value["fields"] as? Dictionary<String, Any>, let id = fields["id"] as? Int, let active = fields["active"] as? Bool, let name = fields["name"] as? String, let repeatInstances = fields["repeat"] as? [String], let timeString = fields["time"] as? String{
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
                        let time = formatter.date(from: timeString)!
                        
                        let alarm = Alarm.init(id, name: name, time: time, active: active, repeatInstances: repeatInstances)
                        self.alarms.append(alarm)
                    }
                }
            }
            completionHandler?()
        }
    }
}

final class Alarm: ObservableObject, Identifiable {
    private var _id: Int
    var name: String
    var time: Date
    var active: Bool{
        didSet{
            self.printAlarm()
        }
    }
    var repeatInstances = [String]()
    
    public var id: Int {
        return _id
    }
    
    init(_ id: Int){
        self._id = id
        self.name = "Alarm"
        self.time = Date()
        self.active = true
    }
    
    init(_ id: Int, name: String, time: Date, active: Bool, repeatInstances: [String]){
        self._id = id
        self.name = name
        self.time = time
        self.active = active
        self.repeatInstances = repeatInstances
    }
    
    func printAlarm(){
        print("id: \(self.id),\nname: \(String(describing: self.name)),\ntime: \(self.time),\nactive: \(self.active),")
        if repeatInstances.isEmpty {
            print("repeat: no repeat")
        }else{
            var finalStr = String()
            for str in repeatInstances {
                finalStr.append("\(str), ")
            }
            print("repeat: \(finalStr)")
        }
        print()
    }
}
