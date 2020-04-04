//
//  MainHost.swift
//  Work Hard, Play Hard
//
//  Created by Devin Green on 3/28/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct MainHost: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var alarmManager: AlarmManager
    @ObservedObject var codeManager: QRCodeManager
    @State var showingAlarmHost: Bool = false
    @State var alarm: Alarm = Alarm.BLANK()
    
    var body: some View {
        NavigationView {
            ZStack {
                List (alarmManager.alarms, id: \.id) { alarm in
                    AlarmRow(alarm: .constant(alarm))
                        .onTapGesture(count: 2) {
                            if !alarm.isActive{
                                self.alarm = alarm
                                self.showingAlarmHost.toggle()
                            }
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
                
                
                if alarmManager.numberOfSensitiveAlarms > 0{
                    VStack{
                        Spacer()
                        NavigationLink(destination: DisarmHost(codeManager: .constant(codeManager))){
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.purple)
                                    .cornerRadius(15)
                                    .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.1), radius: 10)
                                    .frame(height: 165)
                                
                                VStack(alignment: .leading, spacing: 5){
                                    Text(alarmManager.numberOfSensitiveAlarms == 1 ? "Click here to disarm your alarm" : "Click here to disarm your alarms")
                                        .font(.title)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                    
                                    Text(alarmManager.numberOfSensitiveAlarms == 1 ? "You have 1 alarm that need to be disarmed" : "You have \(alarmManager.numberOfSensitiveAlarms) alarms that need to be disarmed")
                                        .font(.headline)
                                        .foregroundColor(Color.white.opacity(0.5))
                                }
                            }.padding()
                        }
                    }
                }
                
            }
        }
    }
}

struct MainHost_Previews: PreviewProvider{
    static var previews: some View {
        MainHost(codeManager: QRCodeManager())
            .environmentObject(AlarmManager())
            .environmentObject(QRCodeManager())
    }
}
