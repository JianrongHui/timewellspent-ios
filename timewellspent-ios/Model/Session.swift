//
//  Session.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/17.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import UIKit

public struct Session: Codable {
    var beforeRating: Int
    var afterRating: Int
    var timestamp: Double
    var duration: Int
    var deviceId: String = UIDevice.current.identifierForVendor!.uuidString
    
    static let Placeholder: Session = .init(beforeRating: 0, afterRating: 0, timestamp: Date.distantPast.timeIntervalSince1970, duration: 0, deviceId: "")
}

class SessionService {
    var currentSession = Session.Placeholder
    
    static let shared = SessionService()
    
    func postToFirebase() {
        let db = Firestore.firestore()
        currentSession = Session(beforeRating: 1, afterRating: 4, timestamp: Date().timeIntervalSince1970, duration: DeviceService.shared.getEstimatedSessionTime())
        db.collection("session").document(UUID().uuidString).setData(currentSession.dictionary)
        currentSession = .Placeholder
    }
    
    

}
