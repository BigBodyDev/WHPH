//
//  DeleteFormRow.swift
//  WHPH
//
//  Created by Devin Green on 3/30/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct DeleteFormRow: View {
    @EnvironmentObject var alarm: Alarm
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: {
                self.alarm.delete {
                    self.isPresented = false
                }
            }) {
                Text("Delete Alarm")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
            }
            Spacer()
        }
    }
}

struct DeleteFormRow_Previews: PreviewProvider {
    static var previews: some View {
        DeleteFormRow(isPresented: .constant(true))
            .environmentObject(Alarm.TEST())
    }
}
