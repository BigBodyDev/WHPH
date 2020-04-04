//
//  AlarmManager.swift
//  WHPH
//
//  Created by Devin Green on 3/30/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseDatabase

class AlarmManager: ObservableObject {
    @Published var alarms = [Alarm]()
    
    var numberOfSensitiveAlarms: Int {
        var count = Int()
        for alarm in alarms{
            count += alarm.isActive ? 1 : 0
        }
        return count
    }
    
    init() {
        Database.database().reference().child("Alarms").observe(.value) { snapshot in
            self.alarms.removeAll()
            
            var alarms = [Alarm]()
            
            if let values = snapshot.value as? Dictionary<String, Any> {
                for id in values.keys {
                    if let value = values[id] as? Dictionary<String, Any>{
                        var isOn: Bool = true
                        var isActive: Bool = false
                        var name: String = "Alarm"
                        var repeatInstances = [String]()
                        var time: Time = Time()
                        
                        if let _isOn = value["isOn"] as? Bool {
                            isOn = _isOn
                        }
                        if let _isActive = value["active"] as? Bool {
                            isActive = _isActive
                        }
                        if let _name = value["name"] as? String {
                            name = _name
                        }
                        if let _repeatInstances = value["repeat"] as? [String] {
                            repeatInstances = _repeatInstances
                        }
                        if let timeString = value["time"] as? String{
                            time = Time(timeString)
                        }
                        
                        let alarm = Alarm(id: id, name: name, time: time, isOn: isOn, isActive: isActive, repeatInstances: repeatInstances, isNew: false)
                        alarms.append(alarm)
                        
                    }
                    
                }
            }
            
            func sortedAlarmArray(alarms: [Alarm]) -> [Alarm]{
                return alarms.sorted(by: { (first, second) -> Bool in
                    first.time < second.time
                })
            }
            self.alarms = sortedAlarmArray(alarms: alarms)
        }
    }
    
    func disarmAlarms(_ completionHandler: (() -> ())?){
        var json = Dictionary<String, Any>()
        for alarm in self.alarms{
            if alarm.isActive{
                alarm.isActive = false
                if alarm.repeatInstances.isEmpty{
                    alarm.isOn = false
                }else{
                    alarm.isOn = true
                }
            }
            json[alarm.id.uuidString] = alarm.toJSON()
        }
        Database.database().reference().child("Alarms").setValue(json) { (error, reference) in
            print(reference.description())
        }
    }
    
}
