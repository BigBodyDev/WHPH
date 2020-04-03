//
//  QRCodeLocation.swift
//  WHPH
//
//  Created by Devin Green on 4/1/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Combine

class QRCode: ObservableObject, Equatable {
    var id: UUID
    @Published var name: String
    @Published var enabled: Bool
    @Published var scanned: Bool
    
    init(_ name: String) {
        self.id = UUID()
        self.name = name
        self.enabled = true
        self.scanned = false
    }
    
    init(id: String, name: String, enabled: Bool, scanned: Bool){
        self.id = UUID.init(uuidString: id)!
        self.name = name
        self.enabled = enabled
        self.scanned = scanned
        
        Database.database().reference().child("QRCodes").child(self.id.uuidString).observe(.value) { (snapshot) in
            if let value = snapshot.value as? Dictionary<String, Any>{
                if let name = value["name"] as? String, let enabled = value["enabled"] as? Bool, let scanned = value["scanned"] as? Bool {
                    self.id = UUID.init(uuidString: id)!
                    self.name = name
                    self.enabled = enabled
                    self.scanned = scanned
                }
            }
        }
    }
    
    static func ==(lhs: QRCode, rhs: QRCode) -> Bool {
        return lhs.id == rhs.id
    }
    
    func scan(_ completionHandler: (() -> ())?){
        self.scanned = true
        Database.database().reference().child("QRCodes").child(self.id.uuidString).setValue(self.toJSON()) { (error, reference) in
            print(reference.description())
        }
    }
    
    func toJSON() -> Dictionary<String, Any>{
        return ["name": name, "enabled": enabled, "scanned": scanned]
    }
    
    static func UnderLivingRoomTable() -> QRCode {
        return QRCode(id: "2506D2FF-F46C-491E-9112-FC1A54AD49F5", name: "Under Living Room Table", enabled: true, scanned: false)
    }
}
