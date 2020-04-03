//
//  BackButton.swift
//  WHPH
//
//  Created by Devin Green on 4/2/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct BackButton: View {
    @Binding var mode: Binding<PresentationMode>
    
    var body: some View {
        Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image(systemName: "arrow.left")
                .imageScale(.large)
                .foregroundColor(.white)
        }
    }
}
