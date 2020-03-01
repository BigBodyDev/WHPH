//
//  MainHost.swift
//  Work Hard, Play Hard
//
//  Created by Devin Green on 3/28/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct MainHost: View {
    @EnvironmentObject var manager: AlarmManager
    @State var showingAlarmHost: Bool = false
    
    var body: some View {
        NavigationView {
            List(manager.alarms.indices, id: \.self) { index in
                AlarmRow(alarm: self.$manager.alarms[index])
            }
            .navigationBarTitle(Text("Work Hard, Play Hard"))
            .navigationBarItems(trailing: MainHostAddAlarmButton(showingAlarmHost: $showingAlarmHost))
            .sheet(isPresented: $showingAlarmHost) {
                AlarmHost(alarm: .constant(Alarm.BLANK()), isPresented: self.$showingAlarmHost)
                    .environmentObject(AlarmManager.shared)
            }
        }
    }
}

struct MainHost_Previews: PreviewProvider {
    static var previews: some View {
        MainHost()
            .environmentObject(AlarmManager.shared)
    }
}
