//
//  QRCodeManager.swift
//  WHPH
//
//  Created by Devin Green on 4/2/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseDatabase
import Combine

class QRCodeManager: ObservableObject {
    
    @Published var selectedCodes = [QRCode]()
    @Published var codes = [QRCode]()
    
    init() {
        Database.database().reference().child("QRCodes").observeSingleEvent(of: .value) { snapshot in
            var codes = [QRCode]()
            if let values = snapshot.value as? Dictionary<String, Any> {
                for id in values.keys {
                    if let value = values[id] as? Dictionary<String, Any>{
                        if let name = value["name"] as? String, let enabled = value["enabled"] as? Bool, let scanned = value["scanned"] as? Bool {
                            let code = QRCode(id: id, name: name, enabled: enabled, scanned: scanned)
                            codes.append(code)
                        }
                    }
                }
            }
            self.codes = codes
            
            if self.selectedCodes.isEmpty{
                self.selectCodes()
            }
        }
    }
    
    func selectCodes(){
        var selectedCodes = [QRCode]()
        let randomCount = Int.random(in: 1..<3)
        for var x in 0...randomCount{
            let randomIndex = Int.random(in: 0..<codes.count)
            let code = codes[randomIndex]
            if !selectedCodes.contains(code) && code.id.uuidString != "C38908C0-EDB2-4548-9C1A-E282A8ED7E4E" && code.enabled == true{
                selectedCodes.append(codes[randomIndex])
            }else{
                x += 1
            }
        }
        self.selectedCodes = selectedCodes
    }
    
    func unscanAndShuffleAllCodes(_ completionHandler: (() -> ())?){
        var json = Dictionary<String, Any>()
        for code in self.codes{
            code.scanned = false
            json[code.id.uuidString] = code.toJSON()
        }
        Database.database().reference().child("QRCodes").setValue(json) { (error, reference) in
            self.selectCodes()
        }
    }
}

extension QRCodeManager {
    static func setNewCodes() {
        let underLivingRoomTable = QRCode("Under Living Room Table")
        let guestBathroom = QRCode("Guest Bathroom")
        let hallCloset = QRCode("Hall Closet")
        let laundryRoom = QRCode("Laundry Room")
        let garageDoor = QRCode("Garage Door")
        let garageToolTable = QRCode("Garage Tool Table")
        let pantry = QRCode("Pantry")
        let refrigerator = QRCode("Refrigerator")
        let underDiningTable = QRCode("Under Dining Table")
        let mediaCabinet = QRCode("MediaCabinet")
        let underOfficeTable = QRCode("Under Office Table")
        let officeCloset = QRCode("Office Closet")
        let EMERGENCY_SHUTOFF = QRCode("EMERGENCY_SHUTOFF")
        
        let masterJson = [
            underLivingRoomTable.id.uuidString: underLivingRoomTable.toJSON(),
            guestBathroom.id.uuidString: guestBathroom.toJSON(),
            hallCloset.id.uuidString: hallCloset.toJSON(),
            laundryRoom.id.uuidString: laundryRoom.toJSON(),
            garageDoor.id.uuidString: garageDoor.toJSON(),
            garageToolTable.id.uuidString: garageToolTable.toJSON(),
            pantry.id.uuidString: pantry.toJSON(),
            refrigerator.id.uuidString: refrigerator.toJSON(),
            underDiningTable.id.uuidString: underDiningTable.toJSON(),
            mediaCabinet.id.uuidString: mediaCabinet.toJSON(),
            underOfficeTable.id.uuidString: underOfficeTable.toJSON(),
            officeCloset.id.uuidString: officeCloset.toJSON(),
            EMERGENCY_SHUTOFF.id.uuidString: EMERGENCY_SHUTOFF.toJSON(),
        ]
        
        print(masterJson)
    }
    
    static func getURLsFromQRCodes(){
        Database.database().reference().child("QRCodes").observeSingleEvent(of: .value) { snapshot in
            var urlStrings = [String]()
            if let values = snapshot.value as? Dictionary<String, Any> {
                for id in values.keys {
                    if let value = values[id] as? Dictionary<String, Any>{
                        if let name = value["name"] as? String {
                            let newUrl = "https://whph.herokuapp.com/?name=\(name.replacingOccurrences(of: " ", with: "%20"))&id=\(id)"
                            urlStrings.append(newUrl)
                        }
                    }
                }
            }
            for url in urlStrings{
                print(url)
            }
        }
    }
}
