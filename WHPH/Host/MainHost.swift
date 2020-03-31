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
    @State var sentAlarm: Alarm = Alarm.BLANK()
    
    var body: some View {
        NavigationView {
            List($manager.alarms.wrappedValue.indices, id: \.self) { index in
                AlarmRow(alarm: self.$manager.alarms[index])
                    .onTapGesture(count: 2) {
                        self.sentAlarm = self.manager.alarms[index]
                        self.showingAlarmHost.toggle()
                }
            }
            .navigationBarTitle(Text("Work Hard, Play Hard"))
            .navigationBarItems(trailing: MainHostAddAlarmButton(showingAlarmHost: $showingAlarmHost, sentAlarm: $sentAlarm))
            .sheet(isPresented: $showingAlarmHost) {
                AlarmHost(alarm: self.sentAlarm, isPresented: self.$showingAlarmHost)
                    .environmentObject(AlarmManager.shared)
                    .onDisappear(){
                        self.sentAlarm = Alarm.BLANK()
                }
            }
            .padding(.top, 10)
        }
    }
}

struct MainHost_Previews: PreviewProvider{
    static var previews: some View {
        MainHost()
            .environmentObject(AlarmManager.shared)
    }
}
