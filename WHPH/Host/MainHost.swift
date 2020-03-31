//
//  MainHost.swift
//  Work Hard, Play Hard
//
//  Created by Devin Green on 3/28/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct MainHost: View {
    @ObservedObject var manager: AlarmManager
    @State var showingAlarmHost: Bool = false
    @State var sentAlarm: Alarm = Alarm.BLANK()
    
    var body: some View {
        NavigationView {
            List(manager.alarms, id: \.id) { alarm in
                AlarmRow()
                    .environmentObject(alarm)
                    .onTapGesture(count: 2) {
                        self.sentAlarm = alarm
                        self.showingAlarmHost.toggle()
                }
            }
            .navigationBarTitle(Text("Work Hard, Play Hard"))
            .navigationBarItems(trailing: MainHostAddAlarmButton(showingAlarmHost: $showingAlarmHost, sentAlarm: $sentAlarm))
            .sheet(isPresented: $showingAlarmHost) {
                AlarmHost(isPresented: self.$showingAlarmHost)
                    .environmentObject(self.sentAlarm)
                    .onDisappear(){
                        self.sentAlarm = Alarm.BLANK()
                        self.manager.reload(nil)
                }
            }
            .padding(.top, 10)
        }
    }
}

struct MainHost_Previews: PreviewProvider{
    static var previews: some View {
        MainHost(manager: AlarmManager())
    }
}
