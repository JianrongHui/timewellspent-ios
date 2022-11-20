//
//  ManagedSettings.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/19.
//

import Foundation
import ManagedSettings

extension ManagedSettingsStore {
    
    var isShieldOpen: Bool {
        return shield.applicationCategories != nil || shield.applications != nil || shield.webDomainCategories != nil || shield.webDomains != nil
    }
}
