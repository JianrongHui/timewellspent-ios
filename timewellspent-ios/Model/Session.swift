//
//  Session.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/17.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

public struct Session: Codable {
    var beforeRating: Int
    var afterRating: Int
    var timestamp: Double
    
    static let Placeholder: Session = .init(beforeRating: 0, afterRating: 0, timestamp: Date.distantPast.timeIntervalSince1970)
}

class SessionService {
    var currentSession = Session.Placeholder
    
    static let shared = SessionService()
    
    func postToFirebase() {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        currentSession = Session(beforeRating: 1, afterRating: 4, timestamp: Date().timeIntervalSince1970)
        db.collection("session").document(UUID().uuidString).setData(currentSession.dictionary)
        currentSession = .Placeholder
    }
    
    

}
