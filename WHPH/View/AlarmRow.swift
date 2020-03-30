//
//  AlarmRow.swift
//  WHPH
//
//  Created by Devin Green on 3/28/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI



struct AlarmRow: View {
    @Binding var alarm: Alarm
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            HStack {
                AlarmRowText(alarm: $alarm.wrappedValue)
                    .opacity($alarm.active.wrappedValue ? 1 : 0.25)
                
                Toggle(isOn: $alarm.active) {
                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
}

struct AlarmRow_Previews: PreviewProvider {
    static var previews: some View {
        AlarmRow(alarm: .constant(TEST_ALARM))
            .previewLayout(.fixed(width: 400, height: 100))
    }
}

extension Date{
    var WHPHString: (time: String, hrPeriod: String) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
//        let dateStrings = formatter.string(from: self).split(separator: " ")
//
//        return (time: String(dateStrings[0]), hrPeriod: String(dateStrings[0]))
        return (time: "7:00", hrPeriod: "AM")
    }
}
