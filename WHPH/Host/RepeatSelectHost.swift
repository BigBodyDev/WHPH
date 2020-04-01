//
//  RepeatSelectHost.swift
//  WHPH
//
//  Created by Devin Green on 3/30/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct RepeatSelectHost: View {
    @EnvironmentObject var alarm: Alarm
    
    var body: some View {
        List{
            RepeatOptionButton(option: "Sunday")
            RepeatOptionButton(option: "Monday")
            RepeatOptionButton(option: "Tuesday")
            RepeatOptionButton(option: "Wednesday")
            RepeatOptionButton(option: "Thursday")
            RepeatOptionButton(option: "Friday")
            RepeatOptionButton(option: "Saturday")
        }
        .navigationBarTitle("Repeat")
        .listRowBackground(Color.clear)
    }
}

struct RepeatSelectHost_Previews: PreviewProvider {
    static var previews: some View {
        RepeatSelectHost()
            .environmentObject(Alarm.TEST())
    }
}
