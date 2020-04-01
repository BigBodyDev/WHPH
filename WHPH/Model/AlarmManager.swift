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
    
    init() {
        Database.database().reference().child("Alarms").observe(.value) { snapshot in
            self.alarms.removeAll()
            var newAlarms = [Alarm]()
            if let values = snapshot.value as? Dictionary<String, Any> {
                for id in values.keys {
                    if let value = values[id] as? Dictionary<String, Any>{
                        var isOn: Bool = true
                        var status: AlarmState = .idle
                        var name: String = "Alarm"
                        var repeatInstances = [String]()
                        var time: Time = Time()
                        
                        if let _isOn = value["isOn"] as? Bool {
                            isOn = _isOn
                        }
                        if let _status = value["status"] as? Int {
                            status = AlarmState(rawValue: _status)!
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
                        
                        let alarm = Alarm(id: id, name: name, time: time, isOn: isOn, state: status, repeatInstances: repeatInstances)
                        newAlarms.append(alarm)
                        alarm.isNew = false
                    }
                    
                }
            }
            newAlarms.sort(by: { (first, second) -> Bool in
                first.time < second.time
            })
            self.alarms = newAlarms
        }
    }
}
