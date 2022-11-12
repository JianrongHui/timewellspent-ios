//
//  MyManagedSettings.swift
//  pause
//
//  Created by Adam Novak on 2022/11/10.
//

import Foundation
import SwiftUI
import ManagedSettings
import FamilyControls

class MyManagedSettings: ObservableObject {
    
    static let shared = MyManagedSettings(applicationTokens: .init())
    
    @Published var selectionToDiscourage: FamilyActivitySelection
    @Published var isActive: Bool = false
    
    private init(applicationTokens: Set<ApplicationToken>) {
        self.selectionToDiscourage = FamilyActivitySelection()
    }
    
    func setShieldRestrictions() {
//        let store = ManagedSettingsStore() this is the default store
        
        let discouragedWebDomains = selectionToDiscourage.webDomainTokens
        let discouragedApplications = selectionToDiscourage.applicationTokens
        let discouragedCategories = selectionToDiscourage.categoryTokens
        
        let discouragedStore = ManagedSettingsStore(named: .discouraged)
        
        discouragedStore.shield.webDomains = .some(discouragedWebDomains)
        discouragedStore.shield.applications = .some(discouragedApplications)
        discouragedStore.shield.applicationCategories = .specific(discouragedCategories)
    }
}

struct Model: Identifiable, Codable { //identifiable protocol is available, auto id's items in List
    let id: Int
    let friend: String
}
