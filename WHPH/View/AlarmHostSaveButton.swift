//
//  AlarmHostSaveButton.swift
//  WHPH
//
//  Created by Devin Green on 3/30/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct AlarmHostSaveButton: View {
    @EnvironmentObject var manager: AlarmManager
    @Binding var alarm: Alarm
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: {
            self.$alarm.wrappedValue.save {
                self.manager.reload {
                    self.isPresented = false
                }
            }
        }) {
            Spacer()
            Text("Save")
        }
    }
}

struct AlarmHostSaveButton_Previews: PreviewProvider {
    static var previews: some View {
        AlarmHostSaveButton(alarm: .constant(Alarm.BLANK()), isPresented: .constant(true))
            .environmentObject(AlarmManager.shared)
    }
}
