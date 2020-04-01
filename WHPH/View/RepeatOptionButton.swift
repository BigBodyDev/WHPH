//
//  RepeatOptionButton.swift
//  WHPH
//
//  Created by Devin Green on 3/30/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct RepeatOptionButton: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var alarm: Alarm
    var option: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 0){
            Text(option)
                .foregroundColor(alarm.repeatInstances.contains(option) ? (colorScheme == .dark ? .white : .black) : .secondary)
            
            Spacer()
            
            Button(action: {
                if let index = self.alarm.repeatInstances.firstIndex(of: self.option){
                    self.alarm.repeatInstances.remove(at: index)
                }else{
                    self.alarm.repeatInstances.append(self.option)
                }
                
                self.alarm.repeatInstances.sort { (first, second) -> Bool in
                    func weightForString(str: String) -> Int{
                        let options = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
                        return options.firstIndex(of: str)!
                    }
                    
                    let firstWeight = weightForString(str: first)
                    let secondWeight = weightForString(str: second)
                    
                    return firstWeight < secondWeight
                }
            }) {
                Image(systemName: alarm.repeatInstances.contains(option) ? "checkmark.circle.fill" : "circle")
                .imageScale(.large)
                .foregroundColor(.blue)
                    .padding(.vertical)
            }
            
        }
        
    }
}

struct RepeatOptionButton_Previews: PreviewProvider {
    static var previews: some View {
        RepeatOptionButton(option: "Saturday")
            .environmentObject(Alarm.TEST())
    }
}
