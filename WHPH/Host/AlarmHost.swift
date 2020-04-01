//
//  AlarmHost.swift
//  WHPH
//
//  Created by Devin Green on 3/30/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct AlarmHost: View {
    @EnvironmentObject var alarm: Alarm
    @Binding var isPresented: Bool
    
    var repeatText: String{
        if alarm.repeatInstances.isEmpty{
            return "None"
        }else if alarm.repeatInstances.count == 7{
            return "Everyday"
        }else if alarm.repeatInstances == ["Saturday", "Sunday"]{
            return "Weekends"
        }else if alarm.repeatInstances == ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]{
            return "Weekdays"
        }else if alarm.repeatInstances.count == 1{
            return alarm.repeatInstances[0]
        }else{
            var finalStr = String()
            for x in 0..<alarm.repeatInstances.count{
                finalStr += alarm.repeatInstances[x].prefix(3)
                
                if x != alarm.repeatInstances.count - 1{
                    finalStr += ", "
                }
            }
            return finalStr
        }
    }
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Alarm name")){
                    TextField("My Alarm", text: $alarm.name)
                    AlarmDatePicker()
                }
                Section{
                    HStack{
                        Text("Active")
                        Toggle(isOn: $alarm.isOn){
                            Spacer()
                        }
                    }
                    NavigationLink(destination: RepeatSelectHost()) {
                        HStack{
                            Text("Repeat")
                            Spacer()
                            Text(repeatText)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Section {
                    if !alarm.isNew{
                        DeleteFormRow(isPresented: $isPresented)
                    }
                }
            }
            .navigationBarTitle(alarm.isNew ? "Add New Alarm" : "Edit \"\($alarm.name.wrappedValue != String() ? $alarm.name.wrappedValue : "Alarm")\"")
            .navigationBarItems(trailing: AlarmHostSaveButton(isPresented: $isPresented))
        }
    }
}

struct AlarmHost_Previews: PreviewProvider {
    static var previews: some View {
        AlarmHost(isPresented: .constant(true))
    }
}
