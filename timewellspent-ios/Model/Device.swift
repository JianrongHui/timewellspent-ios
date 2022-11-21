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
    
    enum CodingKeys: String, CodingKey {
        case estimatedSessionTime
        case hasRatedApp
        case mindfulnessDuration
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        estimatedSessionTime = try values.decodeIfPresent(Int.self, forKey: .estimatedSessionTime) ?? 20
        hasRatedApp = try values.decodeIfPresent(Bool.self, forKey: .hasRatedApp) ?? false
        mindfulnessDuration = try values.decodeIfPresent(Int.self, forKey: .mindfulnessDuration) ?? 1
    }
    
    init() {
        estimatedSessionTime = 20
        hasRatedApp = false
        mindfulnessDuration = 1
    }
    
}
