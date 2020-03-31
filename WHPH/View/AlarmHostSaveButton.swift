//
//  AlarmHostSaveButton.swift
//  WHPH
//
//  Created by Devin Green on 3/30/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct AlarmHostSaveButton: View {
    @EnvironmentObject var alarm: Alarm
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: {
            self.alarm.save {
                self.isPresented = false
            }
        }) {
            Spacer()
            Text("Save")
        }
    }
}

struct AlarmHostSaveButton_Previews: PreviewProvider {
    static var previews: some View {
        AlarmHostSaveButton(isPresented: .constant(true))
            .environmentObject(Alarm.TEST())
    }
}
