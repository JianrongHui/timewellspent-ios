//
//  Constants.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/19.
//

import Foundation
import SwiftUI
import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift

extension Color {
    static let AppPickerBg = Color.init(hex: "1C1C1E")
}

enum Constants: String, CaseIterable {
    
    static let remoteConfig = RemoteConfig.remoteConfig()

    case minContinuousScreenTime, maxContinuousScreenTime
    
    static var remoteConfigDefaults: [String: NSObject] = [
        minContinuousScreenTime.rawValue: 15 as NSObject,
        maxContinuousScreenTime.rawValue: 40 as NSObject,
    ]
    
    static let minDuration = Constants.remoteConfig.configValue(forKey: Constants.minContinuousScreenTime.rawValue).numberValue as? Int ?? 15
    static let maxDuration = Constants.remoteConfig.configValue(forKey: Constants.maxContinuousScreenTime.rawValue).numberValue as? Int ?? 40
    
    static let downloadLink = NSURL(string: "https://apps.apple.com/app/mist/id1631426995")!
    static let landingPageLink = NSURL(string: "https://mindberry.xyz")!
    static let privacyPageLink = NSURL(string: "https://mindberry.xyz/privacy")!
    static let feedbackLink = NSURL(string: "https://forms.gle/G4pN8MyiXrk9doREA")!
    
    static func fetchRemoteConfig() {
        setupRemoteConfigDefaults()
        
        let debugSettings = RemoteConfigSettings()
        debugSettings.minimumFetchInterval = 0
        remoteConfig.configSettings = debugSettings
                
        remoteConfig.fetch(withExpirationDuration: 0) { fetchStatus, error in
            guard error == nil else {
                print(error!)
                return
            }
            remoteConfig.activate()
            print("Retrieved remote config")
            
            //then, we should update data in our app with new values
        }
    }
    
    private static func setupRemoteConfigDefaults() {
        remoteConfig.setDefaults(remoteConfigDefaults)
    }
    
}
