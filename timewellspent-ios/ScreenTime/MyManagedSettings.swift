//
//  MyManagedSettings.swift
//  pause
//
//  Created by Adam Novak on 2022/11/10.
//

import Foundation
import SwiftUI
import ManagedSettings
import DeviceActivity //device activity center
import FamilyControls

class MyManagedSettings: ObservableObject {
    
    static let shared = MyManagedSettings(applicationTokens: .init())
    
    @Published var selectionToDiscourage: FamilyActivitySelection {
        didSet {
            isActive = true
        }
    }
    @Published var isActive: Bool = false
    
    var mindfulnessInterruptionEvent: [DeviceActivityEvent.Name: DeviceActivityEvent] {
        [.mindfulnessInterruption: DeviceActivityEvent(applications: selectionToDiscourage.applicationTokens,
                                                       categories: selectionToDiscourage.categoryTokens,
                                                       webDomains: selectionToDiscourage.webDomainTokens,
                                                       threshold: DateComponents(second: 10))]
    } //computed property so that we get the updated tokens

    
    private init(applicationTokens: Set<ApplicationToken>) {
        self.selectionToDiscourage = FamilyActivitySelection()
    }
    
    //When we set shield restirctions, we're doing it from the ActivityMonitorExtension
//    func setShieldRestrictions() {
//        let discouragedWebDomains = selectionToDiscourage.webDomainTokens
//        let discouragedApplications = selectionToDiscourage.applicationTokens
//        let discouragedCategories = selectionToDiscourage.categoryTokens
//
//        let discouragedStore = ManagedSettingsStore(named: .discouraged)
////
////        discouragedStore.shield.applicationCategories = .all()
////        discouragedStore.shield.webDomainCategories = .all()
////        discouragedStore.shield.webDomains = .some(discouragedWebDomains)
////        discouragedStore.shield.applications = .some(discouragedApplications)
////        discouragedStore.shield.applicationCategories = .specific(discouragedCategories)
//    }
    
    //NOTE: The maximum number of activities that can be monitored at one time by an app and its extensions is twenty.
    func toggleMonitoringScreentime(to shouldMonitor: Bool) {
        print("TOGGLING")
        ManagedSettingsStore().clearAllSettings()
        let deviceActivityCenter = DeviceActivityCenter()
        deviceActivityCenter.stopMonitoring()

        if shouldMonitor {
            for i in 5..<23 {
                let hourSchedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: i, minute: 0),
                                                          intervalEnd: DateComponents(hour: i, minute: 59),
                                                          repeats: true)
                do {
                    try deviceActivityCenter.startMonitoring(DeviceActivityName(String(i)),
                                                             during: hourSchedule,
                                                             events: mindfulnessInterruptionEvent)
                } catch {
                    print("ERROR TRYING TO MONITOR A SCHEDULE", error.localizedDescription)
                }
            }
        }
    }
    
    func pauseUntilNextHour() {
        ManagedSettingsStore().clearAllSettings() //gets rid of shield
        
        //TODO: make sure we don't put shield back on for an hour
        
        //ALSO TODO: even if they don't meditate, we need to turn off the shield 5 minutes from now...
        //OOOOH idea: the "warning" event can be
        //no we can't do that... because
        
        //what if you could integrate screen time limits with your calendar
        //import google calendar
        //press "sync" button
        //you won't be able to use your phone during those times
    }
    
}

func requestScreentimeAuthorization(callback: @escaping () -> Void) {
    Task {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            callback()
        } catch {
            print("Failed to enroll Aniyah with error: \(error)")
        }
    }
}

extension ManagedSettingsStore {
    
    var isShieldOpen: Bool {
        return shield.applicationCategories != nil || shield.applications != nil || shield.webDomainCategories != nil || shield.webDomains != nil
    }
}
