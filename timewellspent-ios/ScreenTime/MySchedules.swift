//
//  MySchedules.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/11.
//

import Foundation
import ManagedSettings
import DeviceActivity
import FamilyControls

//NOTE: every DeviceActivityName should correspond to a ManagedSettingsStore.Name
//every DeviceActivityName corresponds with a schedule.
//we want every schedule the user sets to have a corresponding ManagedSettingsStore (ie app restrictions)

//but for now... they'll just have one schedule

extension DeviceActivityName {
    static let discouraged = Self("discouraged") //NOTE: if allowing for more than one, we should let the user generate the name on their end
//    static let social = Self("social")
}

extension ManagedSettingsStore.Name {
    static let discouraged = Self("discouraged")
//    static let social = Self("social")
}

let discouragedSchedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 0, minute: 0), intervalEnd: DateComponents(hour: 23, minute: 59), repeats: true)

extension DeviceActivityEvent.Name {
    static let mindfulnessInterruption = Self("mindfulnessInterruption")
}

//need to make a model which has a set of appplication tokens
let mindfulnessInterruptionEvents: [DeviceActivityEvent.Name: DeviceActivityEvent] = [.mindfulnessInterruption: DeviceActivityEvent(applications: MyManagedSettings.shared.selectionToDiscourage.applicationTokens, categories: MyManagedSettings.shared.selectionToDiscourage.categoryTokens, webDomains: MyManagedSettings.shared.selectionToDiscourage.webDomainTokens, threshold: DateComponents(minute: 1))] //after 1 minute, the "eventDidReachThreshold" should be called

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

func startMonitoringScreentime() {
    print("Starting monitoring. Hour is: ", Calendar.current.dateComponents([.hour, .minute], from: Date()).hour!)
    let deviceActivityCenter = DeviceActivityCenter()
    do {
        try deviceActivityCenter.startMonitoring(.discouraged, during: discouragedSchedule, events: mindfulnessInterruptionEvents)
//        try deviceActivityCenter.stopMonitoring(
    } catch {
        
    }
}
