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
    @State var alarm: Alarm = Alarm.BLANK()
    
    var body: some View {
        NavigationView {
            ZStack {
                List (manager.alarms, id: \.id) { alarm in
                    AlarmRow(alarm: .constant(alarm))
                        .onTapGesture(count: 2) {
                            self.alarm = alarm
                            self.showingAlarmHost.toggle()
                        }
                }
                .navigationBarTitle(Text("Work Hard, Play Hard"))
                .navigationBarItems(trailing: MainHostAddAlarmButton(showingAlarmHost: $showingAlarmHost, alarm: $alarm))
                    
                .sheet(isPresented: $showingAlarmHost) {
                    AlarmHost(isPresented: self.$showingAlarmHost)
                        .environmentObject(self.alarm)
                        .onDisappear(){
                            self.alarm = Alarm.BLANK()
                        }
                }
                
                
            }
        }
    }
}

struct MainHost_Previews: PreviewProvider{
    static var previews: some View {
        MainHost()
            .environmentObject(AlarmManager())
    }
}
