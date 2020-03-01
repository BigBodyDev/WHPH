//
//  AlarmRowText.swift
//  WHPH
//
//  Created by Devin Green on 3/28/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct AlarmRowText: View {
    var alarm: Alarm
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .bottom, spacing: 5) {
                
                Text(alarm.time.stringNoHrPeriod)
                    .font(.largeTitle)
                
                Text(alarm.time.hrPeriod)
                    .font(.headline)
                    .padding(.bottom, 5)
            }
            Text(alarm.name)
        }
    }
}

struct AlarmRowText_Previews: PreviewProvider {
    static var previews: some View {
        AlarmRowText(alarm: Alarm.TEST())
    }
}


