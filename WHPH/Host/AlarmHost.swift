//
//  AlarmHost.swift
//  WHPH
//
//  Created by Devin Green on 3/30/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct AlarmHost: View {
    @Binding var alarm: Alarm
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    TextField("Alarm Name", text: $alarm.name)
                }
            }
            .navigationBarTitle($alarm.id.wrappedValue == nil ? "Add New Alarm" : "Edit \(alarm.name)")
            .navigationBarItems(trailing: AlarmHostSaveButton(alarm: $alarm, isPresented: $isPresented))
        }
    }
}

struct AlarmHost_Previews: PreviewProvider {
    static var previews: some View {
        AlarmHost(alarm: .constant(Alarm.BLANK()), isPresented: .constant(true))
    }
}
