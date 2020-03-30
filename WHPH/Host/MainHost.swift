//
//  MainHost.swift
//  Work Hard, Play Hard
//
//  Created by Devin Green on 3/28/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

let TEST_ALARM = Alarm(01234121234, name: "Alarm", time: Date(), active: true, repeatInstances: ["Saturday", "Sunday"])

struct MainHost: View {
    @ObservedObject var manager: AlarmManager
    
    var addAlarmButton: some View {
        Button(action: {
//            self.showingProfile.toggle()
        }) {
            Image(systemName: "plus")
                .imageScale(.large)
                .padding()
        }
    }
    
    var body: some View {
        NavigationView {
            List(manager.alarms.indices, id: \.self) { index in
                AlarmRow(alarm: self.$manager.alarms[index])
            }
            .navigationBarTitle(Text("Work Hard, Play Hard"))
            .navigationBarItems(trailing: addAlarmButton)
        }
    }
}

struct MainHost_Previews: PreviewProvider {
    static var previews: some View {
        MainHost(manager: AlarmManager.shared)
    }
}
