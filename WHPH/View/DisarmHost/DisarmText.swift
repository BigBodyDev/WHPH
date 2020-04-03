//
//  DisarmText.swift
//  WHPH
//
//  Created by Devin Green on 4/2/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct DisarmText: View {
    @Binding var codeManager: QRCodeManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Disarm the following codes:")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .frame(height: 85)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
            
            ForEach(codeManager.selectedCodes, id: \.id) { code in
                CodeText(code: code)
            }
        }
    }
}

struct DisarmText_Previews: PreviewProvider {
    static var previews: some View {
        DisarmText(codeManager: .constant(QRCodeManager()))
            .environmentObject(QRCodeManager())
    }
}
