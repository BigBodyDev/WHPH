//
//  CodeText.swift
//  WHPH
//
//  Created by Devin Green on 4/2/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct CodeText: View {
    @ObservedObject var code: QRCode
    
    var body: some View {
        Text($code.name.wrappedValue)
            .font(.title)
            .strikethrough($code.scanned.wrappedValue, color: .white)
            .foregroundColor($code.scanned.wrappedValue ? Color.white.opacity(0.5) : .white)
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
    }
}

struct CodeText_Previews: PreviewProvider {
    static var previews: some View {
        CodeText(code: QRCode.UnderLivingRoomTable())
    }
}
