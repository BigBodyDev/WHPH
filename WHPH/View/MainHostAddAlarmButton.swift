//
//  MainHostAddAlarmButton.swift
//  WHPH
//
//  Created by Devin Green on 3/30/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct MainHostAddAlarmButton: View {
    @Binding var showingAlarmHost: Bool
    @Binding var sentAlarm: Alarm
    
    var body: some View {
        Button(action: {
            self.sentAlarm = Alarm.BLANK()
            self.showingAlarmHost.toggle()
        }) {
            Image(systemName: "plus")
                .imageScale(.large)
                .padding()
        }
    }
}

struct MainHostAddAlarmButton_Previews: PreviewProvider {
    static var previews: some View {
        MainHostAddAlarmButton(showingAlarmHost: .constant(false), sentAlarm: .constant(Alarm.BLANK()))
    }
}
