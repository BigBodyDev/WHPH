//
//  AlarmList.swift
//  WHPH
//
//  Created by Devin Green on 3/30/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct AlarmList: View {
    @Binding var alarms: [Alarm]
    
    var body: some View {
        List {
            ForEach(alarms.indices) { index in
                AlarmRow(alarm: self.$alarms[index])
           }
        }
    }
}

struct AlarmList_Previews: PreviewProvider {
    static var previews: some View {
        AlarmList(alarms: .constant([TEST_ALARM, TEST_ALARM]))
    }
}
