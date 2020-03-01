//
//  ModelExample.swift
//  WHPH
//
//  Created by Devin Green on 3/29/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

class MyModelManager: ObservableObject {
    static let shared = MyModelManager()
    
    @Published var myModels: [MyModel] = [
        MyModel(id: "1", name: "First Model", notify: false),
        MyModel(id: "2", name: "Second Model", notify: true)
    ]
}

class MyModel: ObservableObject {
    var id: String
    var name: String
    var notify: Bool
    
    init(id: String, name: String, notify: Bool) {
        self.id = id
        self.name = name
        self.notify = notify
    }
}


import SwiftUI

struct MainView: View {
    @ObservedObject var manager: MyModelManager
    
    var body: some View {
        NavigationView {
            ListView(myModels: $manager.myModels)
                .navigationBarTitle(Text("My Models"))
        }
    }
}
  
struct ListView : View {
    @Binding var myModels: [MyModel]
    
    var body: some View {
        List {
           ForEach(myModels.indices) { index in
               Toggle(isOn: self.$myModels[index].notify) {
                   Text(self.$myModels[index].name.wrappedValue)
                       .opacity(self.$myModels[index].notify.wrappedValue ? 1 : 0.25)
               }
           }
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(manager: MyModelManager.shared)
    }
}
