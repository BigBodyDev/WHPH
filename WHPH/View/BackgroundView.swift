//
//  BackgroundView.swift
//  WHPH
//
//  Created by Devin Green on 3/28/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 10)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
//            .previewLayout(.fixed(width: 500, height: 300))
    }
}
