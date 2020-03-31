//
//  AlarmManager.swift
//  WHPH
//
//  Created by Devin Green on 3/30/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import Alamofire
import SwiftUI

class AlarmManager: ObservableObject {
    static var shared = AlarmManager()
    
    @Published var alarms = [Alarm]()
    
    init() {
        reload(nil)
    }
    
    func reload(_ completionHandler: (() -> ())?){
        AF.request("https://api.airtable.com/v0/appJcIDCIJdhCznhF/Alarms?api_key=keycK6AVjkarbE5ZK").responseJSON { response in
            self.alarms.removeAll()
            
            if let dict = response.value as? Dictionary<String, Any>, let values = dict["records"] as? [Dictionary<String, Any>] {
                for value in values {
                    var id: String?
                    if let _id = value["id"] as? String{
                        id = _id
                    }
                    if let fields = value["fields"] as? Dictionary<String, Any>{
                        var active: Bool = false
                        var name: String = "Alarm"
                        var repeatInstances = [String]()
                        var time: Time = Time()
                        
                        
                        if let _active = fields["active"] as? Bool {
                            active = _active
                        }
                        if let _name = fields["name"] as? String {
                            name = _name
                        }
                        if let _repeatInstances = fields["repeat"] as? [String] {
                            repeatInstances = _repeatInstances
                            
                        }
                        if let timeString = fields["time"] as? String{
                            time = Time(timeString)
                        }
                        
                        let alarm = Alarm(id: id, name: name, time: time, active: active, repeatInstances: repeatInstances)
                        self.alarms.append(alarm)
                    }
                }
            }
            self.alarms = self.alarms.sorted(by: { (first, second) -> Bool in
                first.time < second.time
            })
            completionHandler?()
        }
    }
}
