//
//  Device.swift
//  mist-ios
//
//  Created by Adam Monterey on 9/3/22.
//

import Foundation

struct Device: Codable {
    var estimatedSessionTime: Int = 20
    
    enum CodingKeys: String, CodingKey {
        case estimatedSessionTime
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        estimatedSessionTime = try values.decodeIfPresent(Int.self, forKey: .estimatedSessionTime) ?? 20
    }
    
    init() {
        estimatedSessionTime = 20
    }
    
}
