//
//  Device.swift
//  mist-ios
//
//  Created by Adam Monterey on 9/3/22.
//

import Foundation

struct Device: Codable {
    var estimatedSessionTime: Int = 20
    var mindfulnessDuration: Int = 1
    var hasRatedApp: Bool = false
    var lastReceivedNewUpdateAlertVersion: String = "0.0.0"
    
    enum CodingKeys: String, CodingKey {
        case estimatedSessionTime
        case hasRatedApp
        case mindfulnessDuration
        case lastReceivedNewUpdateAlertVersion
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        estimatedSessionTime = try values.decodeIfPresent(Int.self, forKey: .estimatedSessionTime) ?? 20
        hasRatedApp = try values.decodeIfPresent(Bool.self, forKey: .hasRatedApp) ?? false
        mindfulnessDuration = try values.decodeIfPresent(Int.self, forKey: .mindfulnessDuration) ?? 1
        lastReceivedNewUpdateAlertVersion = try values.decodeIfPresent(String.self, forKey: .lastReceivedNewUpdateAlertVersion) ?? "0.0.0"
    }
    
    init() {
        estimatedSessionTime = 20
        mindfulnessDuration = 1
        hasRatedApp = false
        lastReceivedNewUpdateAlertVersion = "0.0.0"
    }
    
}
