//
//  MyManagedSettings.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/19.
//

import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls

struct MyManagedSettings: Codable {
    
    var selectionToDiscourage: FamilyActivitySelection = FamilyActivitySelection()
    var isActive: Bool = false
    var hasBeenActivatedOnce: Bool = false
    
    var mindfulnessInterruptionEvent: [DeviceActivityEvent.Name: DeviceActivityEvent] {
        [.mindfulnessInterruption: DeviceActivityEvent(applications: selectionToDiscourage.applicationTokens,
                                                       categories: selectionToDiscourage.categoryTokens,
                                                       webDomains: selectionToDiscourage.webDomainTokens,
                                                       threshold: DateComponents(second: 10))]
    } //computed property so that we get the updated tokens
    
    enum CodingKeys: String, CodingKey {
        case selectionToDiscourage
        case isActive
        case hasBeenActivatedOnce
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        selectionToDiscourage = try values.decodeIfPresent(FamilyActivitySelection.self, forKey: .selectionToDiscourage) ?? .init()
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
        hasBeenActivatedOnce = try values.decodeIfPresent(Bool.self, forKey: .hasBeenActivatedOnce) ?? false
    }
    
    init() {
        selectionToDiscourage = .init()
        isActive = false
        hasBeenActivatedOnce = false
    }
}
