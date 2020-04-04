//
//  Alarm.swift
//  Work Hard, Play Hard
//
//  Created by Devin Green on 3/28/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseDatabase

class Alarm: ObservableObject, Identifiable, Equatable {
    @Published var id: UUID
    @Published var name: String
    @Published var time: Time
    @Published var isOn: Bool{
        didSet{
            save(nil)
        }
    }
    @Published var isActive: Bool
    @Published var repeatInstances = [String]()
    @Published var isNew: Bool
    
    init(id: String, name: String, time: Time, isOn: Bool, isActive: Bool, repeatInstances: [String], isNew: Bool){
        self.id = UUID(uuidString: id)!
        self.name = name
        self.time = time
        self.isOn = isOn
        self.isActive = isActive
        self.repeatInstances = repeatInstances
        self.isNew = isNew
    }
    
    func save(_ completionHandler: (() -> ())?) {
        Database.database().reference().child("Alarms").child(id.uuidString).setValue(self.toJSON()) { (error, reference) in
            print(reference.description())
            completionHandler?()
        }
    }
    
    func delete(_ completionHandler: (() -> ())?) {
        Database.database().reference().child("Alarms").child(id.uuidString).setValue(nil) { (error, reference) in
            print(reference.description())
            completionHandler?()
        }
    }
    
    func toJSON() -> Dictionary<String, Any> {
        let json: Dictionary<String, Any> = ["name": self.name, "time": time.dateString, "active": isActive, "isOn": isOn, "repeat": self.repeatInstances]
        return json
    }
    
    static func ==(lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.time == rhs.time
    }
}

extension Alarm {
    func printAlarm(){
        print("id: \(self.id.uuidString),\nname: \(String(describing: self.name)),\ntime: \(self.time),\nisActive: \(self.isActive),\nisOn: \(self.isOn),")
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
        return Alarm(id: UUID().uuidString, name: "Alarm", time: Time(), isOn: true, isActive: false, repeatInstances: [], isNew: true)
    }
    static func TEST() -> Alarm {
        let alarm = Alarm(id: "this is a id", name: "Wake Up", time: Time(), isOn: true, isActive: false, repeatInstances: ["Saturday", "Sunday"], isNew: false)
        return alarm
    }
}

extension Date {
    mutating func removeDate(){
        
    }
}
