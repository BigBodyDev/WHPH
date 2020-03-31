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
                        Toggle(isOn: $alarm.active){
                            Spacer()
                        }
                    }
                    NavigationLink(destination: BackgroundView()) {
                        HStack{
                            Text("Repeat")
                            Spacer()
                            Text("None")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Section {
                    if alarm.id != nil {
                        DeleteFormRow(isPresented: $isPresented)
                    }
                }
            }
            .navigationBarTitle($alarm.id.wrappedValue == nil ? "Add New Alarm" : "Edit \"\($alarm.name.wrappedValue != String() ? $alarm.name.wrappedValue : "Alarm")\"")
            .navigationBarItems(trailing: AlarmHostSaveButton(isPresented: $isPresented))
        }
    }
}

struct AlarmHost_Previews: PreviewProvider {
    static var previews: some View {
        AlarmHost(isPresented: .constant(true))
            .environmentObject(Alarm.TEST())
    }
}
