//
//  DisarmHost.swift
//  WHPH
//
//  Created by Devin Green on 4/2/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct DisarmHost: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var alarmManager: AlarmManager
    @Binding var codeManager: QRCodeManager
    
    @State var showingScanner = false
    @State var showingScannedAlert = false
    @State var showingDisarmedAlert = false
    @State var scannedCode: QRCode?
    
    var body: some View {
        ZStack{
            Color.purple
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading){
                DisarmText(codeManager: $codeManager)
                    .alert(isPresented: $showingScannedAlert) {
                        Alert(title: scannedAlertTitle,
                              message: scannedAlertMessage,
                              dismissButton: scannedAlertDismissButton)
                    }
                
                ScanButton(showingScanner: self.$showingScanner)
                    .alert(isPresented: $showingDisarmedAlert) {
                        Alert(title: disarmedAlertTitle,
                              message: disarmedAlertMessage,
                              dismissButton: disarmedAlertDismissButton)
                    }
            }
            .offset(y: -64)
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(mode: .constant(mode)))
        .onDisappear(){
            self.codeManager.unscanAndShuffleAllCodes(nil)
        }
        .sheet(isPresented: $showingScanner) {
            self.scanner
                .onAppear(){
                    toggleTorch(on: true)
                }
                .onDisappear(){
                    if self.scannedCode != nil {
                        self.showingScannedAlert = true
                    }
                }
        }
    }
    
    var scanner: CodeScannerView {
        CodeScannerView(codeTypes: [.qr], simulatedData: "https://whph.herokuapp.com/?name=EMERGENCY520SHUTOFF&id=C38908C0-EDB2-4548-9C1A-E282A8ED7E4E", completion: { result in
            self.showingScanner = false
            
            switch result {
            case .success(let code):
                if let url = URL(string: code), let parameters = url.queryParameters, let id = parameters["id"]{
                    
                    for code in self.codeManager.codes{
                        if code.id.uuidString == id{
                            print("\n\n")
                            print(code.name)
                            print("\n\n")
                            self.scannedCode = code
                            code.scan(nil)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    var scannedAlertTitle: Text {
        Text(
            self.scannedCode!.id.uuidString == "C38908C0-EDB2-4548-9C1A-E282A8ED7E4E" ?
                "You have scanned the emergency shutoff code":
                "You have scanned:\n\"\(scannedCode!.name).\""
        )
    }
    
    var scannedAlertMessage: Text {
        Text(
            self.scannedCode!.id.uuidString == "C38908C0-EDB2-4548-9C1A-E282A8ED7E4E" ?
                String() :
                codeManager.selectedCodes.contains(scannedCode!) ?
                    "Good Work! 😁" :
                    "Wrong code buddy 😐"
        )
    }
    
    var scannedAlertDismissButton: Alert.Button{
        Alert.Button.default(
            Text(
                self.scannedCode!.id.uuidString == "C38908C0-EDB2-4548-9C1A-E282A8ED7E4E" ?
                    "Continue":
                    codeManager.selectedCodes.contains(scannedCode!) ?
                        "Hooray! " :
                        "Damn..."
            )
            , action: {
                DispatchQueue.main.async {
                    if self.scannedCode?.id.uuidString == "C38908C0-EDB2-4548-9C1A-E282A8ED7E4E"{
                        self.showingDisarmedAlert = true
                        self.alarmManager.disarmAlarms(nil)
                    }else{
                        var scannedCount = Int()
                        for selectedCode in self.codeManager.selectedCodes{
                            scannedCount += selectedCode.scanned ? 1 : 0
                        }
                        if scannedCount == self.codeManager.selectedCodes.count{
                            self.showingDisarmedAlert = true
                            self.alarmManager.disarmAlarms(nil)
                        }
                    }
                    self.scannedCode = nil
                }
        })
    }
    
    var disarmedAlertTitle: Text {
        Text(
            self.codeManager.selectedCodes.count == 1 ?
                "You've sucessfully scanned the code!" :
                "You've sucessfully scanned all the codes!")
    }
    
    var disarmedAlertMessage: Text {
        Text(
            self.alarmManager.numberOfSensitiveAlarms == 1 ?
                "Your alarm has been disarmed! 🥳" :
                "Your alarms have been disarmed! 🥳")

    }
    
    var disarmedAlertDismissButton: Alert.Button {
        Alert.Button.default(Text("Yay!"), action: {
            self.mode.wrappedValue.dismiss()
        })
    }
}

struct DisarmHost_Previews: PreviewProvider {
    static var previews: some View {
        DisarmHost(codeManager: .constant(QRCodeManager()))
            .environmentObject(QRCodeManager())
    }
}



extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

fileprivate func toggleTorch(on: Bool) {
    guard let device = AVCaptureDevice.default(for: .video) else { return }

    if device.hasTorch {
        do {
            try device.lockForConfiguration()

            if on == true {
                device.torchMode = .on
            } else {
                device.torchMode = .off
            }

            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    } else {
        print("Torch is not available")
    }
}
