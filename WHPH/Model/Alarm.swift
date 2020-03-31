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

class Alarm: ObservableObject, Identifiable {
    @Published var id: String?
    @Published var name: String
    @Published var time: Time
    @Published var active: Bool
    @Published var repeatInstances = [String]()
    
    init(id: String?, name: String, time: Time, active: Bool, repeatInstances: [String]){
        self.id = id
        self.name = name
        self.time = time
        self.active = active
        self.repeatInstances = repeatInstances
    }
    
    func save(_ completionHandler: @escaping () -> Void) {
        if let id = self.id{
            print(id)
            completionHandler()
        }else{
            AF.request("https://api.airtable.com/v0/appJcIDCIJdhCznhF/Alarms?api_key=keycK6AVjkarbE5ZK", method: .post, parameters: self.toJSON(), encoding: JSONEncoding.default).responseJSON { response in
                print(response.value!)
                completionHandler()
            }
        }
        
    }
    
    func toJSON() -> Dictionary<String, Any> {
        let json: Dictionary<String, Any> = ["name": self.name, "time": time.dateString, "active": active, "repeat": self.repeatInstances]
        return ["fields": json]
    }
    
    
}

extension Alarm {
    func printAlarm(){
        print("id: \(self.id ?? "none"),\nname: \(String(describing: self.name)),\ntime: \(self.time),\nactive: \(self.active),")
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
    
    static func BLANK() -> Alarm {
        return Alarm(id: nil, name: "Alarm", time: Time(), active: true, repeatInstances: [])
    }
    static func TEST() -> Alarm {
        return Alarm(id: "this is a id", name: "Wake Up", time: Time(), active: true, repeatInstances: ["Saturday", "Sunday"])
    }
}

extension Date {
    mutating func removeDate(){
        
    }
}
