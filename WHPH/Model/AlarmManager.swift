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
    @Published var idleAlarms = [Alarm]()
    @Published var standbyAlarms = [Alarm]()
    @Published var activeAlarms = [Alarm]()
    @Published var disarmedAlarms = [Alarm]()
    
    var numberOfSensitiveAlarms: Int {
        return standbyAlarms.count + activeAlarms.count
    }
    
    init() {
        Database.database().reference().child("Alarms").observe(.value) { snapshot in
            self.alarms.removeAll()
            self.idleAlarms.removeAll()
            self.standbyAlarms.removeAll()
            self.activeAlarms.removeAll()
            self.disarmedAlarms.removeAll()
            
            var alarms = [Alarm]()
            var idleAlarms = [Alarm]()
            var standbyAlarms = [Alarm]()
            var activeAlarms = [Alarm]()
            var disarmedAlarms = [Alarm]()
            
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
                        if let _status = value["state"] as? Int {
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
                        
                        let alarm = Alarm(id: id, name: name, time: time, isOn: isOn, state: status, repeatInstances: repeatInstances, isNew: false)
                        alarms.append(alarm)
                        
                        switch alarm.state {
                        case .idle:
                            idleAlarms.append(alarm)
                        case .standby:
                            standbyAlarms.append(alarm)
                        case .active:
                            activeAlarms.append(alarm)
                        case .disarmed:
                            disarmedAlarms.append(alarm)
                        }
                    }
                    
                }
            }
            
            func sortedAlarmArray(alarms: [Alarm]) -> [Alarm]{
                return alarms.sorted(by: { (first, second) -> Bool in
                    first.time < second.time
                })
            }
            self.alarms = sortedAlarmArray(alarms: alarms)
            self.idleAlarms = sortedAlarmArray(alarms: idleAlarms)
            self.standbyAlarms = sortedAlarmArray(alarms: standbyAlarms)
            self.activeAlarms = sortedAlarmArray(alarms: activeAlarms)
            self.disarmedAlarms = sortedAlarmArray(alarms: disarmedAlarms)
        }
    }
    
    func disarmAlarms(_ completionHandler: (() -> ())?){
        var json = Dictionary<String, Any>()
        for alarm in self.alarms{
            if alarm.state.rawValue > 0{
                alarm.state = .idle
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
