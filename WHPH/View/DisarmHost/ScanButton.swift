//
//  ScanButton.swift
//  WHPH
//
//  Created by Devin Green on 4/2/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct ScanButton: View {
    @Binding var showingScanner: Bool
    
    var body: some View {
        Button(action: {
            self.showingScanner.toggle()
        }) {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .frame(height: 75, alignment: .center)
                    .padding(20)
                
                HStack(spacing: 20) {
                    Text("Click here to scan code")
                        .font(.headline)
                        .foregroundColor(.purple)
                    Image(systemName: "camera.fill")
                        .imageScale(.large)
                        .foregroundColor(.purple)
                }
            }
            
        }
    }
}

struct ScanButton_Previews: PreviewProvider {
    static var previews: some View {
        ScanButton(showingScanner: .constant(false))
    }
}
