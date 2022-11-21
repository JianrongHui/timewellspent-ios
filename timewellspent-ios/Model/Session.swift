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
    var timestamp: Date
    var screenTime: Int
    var mindfulnessDuration: Int
    var deviceId: String = UIDevice.current.identifierForVendor!.uuidString
    
    static let Placeholder: Session = .init(beforeRating: 0, afterRating: 0, timestamp: Date.distantPast, screenTime: 0, mindfulnessDuration: 0, deviceId: "")
}

class SessionService {
    var currentSession = Session.Placeholder
    
    static let shared = SessionService()
    
    func postToFirebase(beforeRating: Int, afterRating: Int) {
        let db = Firestore.firestore()
        currentSession = Session(beforeRating: beforeRating, afterRating: afterRating, timestamp: Date(), screenTime: DeviceService.shared.getEstimatedSessionTime(), mindfulnessDuration: DeviceService.shared.getMindfulnessDuration())
        db.collection("session").document(UUID().uuidString).setData(currentSession.dictionary)
        currentSession = .Placeholder
    }
    
    

}
