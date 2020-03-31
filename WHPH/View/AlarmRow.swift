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
                AlarmRowText(alarm: $alarm)
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
        AlarmRow(alarm: .constant(Alarm.TEST()))
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
