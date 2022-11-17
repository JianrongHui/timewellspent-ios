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

extension DeviceActivityEvent.Name {
    static let mindfulnessInterruption = Self("mindfulnessInterruption")
}

//need to make a model which has a set of appplication tokens
let mindfulnessInterruptionEvent: [DeviceActivityEvent.Name: DeviceActivityEvent] = [.mindfulnessInterruption: DeviceActivityEvent(applications: MyManagedSettings.shared.selectionToDiscourage.applicationTokens, categories: MyManagedSettings.shared.selectionToDiscourage.categoryTokens, webDomains: MyManagedSettings.shared.selectionToDiscourage.webDomainTokens, threshold: DateComponents(second: 5))] //after 5 seconds, the "didreachthreshold" is called



//OLD APPROACH:::::

//fuckkk ok so....
///we can only limit them by "threshold"
///we can create a monitor, which monitors them 24/7 for X apps, and then blocks all apps when that hits
///but.... we can only create threshold
///we could... create a threshold which maxes them out to 30 minutes each day
///or... but we can only

//OOH SHITTTT: this means like...
//if you have used ANY SINGLE app for more than 2 minutes , block all apps
//well, before blocking, we need to do the computation
//ohhhh thats why they usually do like
//it's easy to detect "if they have used social media for 20 minutes total"
//we definitely can't do this for "used any app for too long", because ev
//what we'd need to do is... they choose X apps which they want to use less

extension DeviceActivityEvent.Name {
    static let one = Self("1")
    static let two = Self("2")
    static let three = Self("3")
    static let four = Self("4")
    static let five = Self("5")
    static let six = Self("6")
    static let seven = Self("7")
    static let eight = Self("8")
    static let nine = Self("9")
    static let ten = Self("10")
    static let eleven = Self("11")
    static let twelve = Self("12")
}

//either create: 25 
let fiveMinuteIntervalEvents: [DeviceActivityEvent.Name: DeviceActivityEvent] =
    [.one: DeviceActivityEvent(applications: MyManagedSettings.shared.selectionToDiscourage.applicationTokens,
                               categories: MyManagedSettings.shared.selectionToDiscourage.categoryTokens,
                               webDomains: MyManagedSettings.shared.selectionToDiscourage.webDomainTokens,
                               threshold: DateComponents(second: 5)),]
//     .two: DeviceActivityEvent(applications: MyManagedSettings.shared.selectionToDiscourage.applicationTokens,
//                                categories: MyManagedSettings.shared.selectionToDiscourage.categoryTokens,
//                                webDomains: MyManagedSettings.shared.selectionToDiscourage.webDomainTokens,
//                                threshold: DateComponents(second: 10)),
//     .three: DeviceActivityEvent(applications: MyManagedSettings.shared.selectionToDiscourage.applicationTokens,
//                                categories: MyManagedSettings.shared.selectionToDiscourage.categoryTokens,
//                                webDomains: MyManagedSettings.shared.selectionToDiscourage.webDomainTokens,
//                                threshold: DateComponents(second: 15)),
//     .four: DeviceActivityEvent(applications: MyManagedSettings.shared.selectionToDiscourage.applicationTokens,
//                                categories: MyManagedSettings.shared.selectionToDiscourage.categoryTokens,
//                                webDomains: MyManagedSettings.shared.selectionToDiscourage.webDomainTokens,
//                                threshold: DateComponents(second: 20)),
//     .five: DeviceActivityEvent(applications: MyManagedSettings.shared.selectionToDiscourage.applicationTokens,
//                                categories: MyManagedSettings.shared.selectionToDiscourage.categoryTokens,
//                                webDomains: MyManagedSettings.shared.selectionToDiscourage.webDomainTokens,
//                                threshold: DateComponents(second: 25)),
//     .six: DeviceActivityEvent(applications: MyManagedSettings.shared.selectionToDiscourage.applicationTokens,
//                                categories: MyManagedSettings.shared.selectionToDiscourage.categoryTokens,
//                                webDomains: MyManagedSettings.shared.selectionToDiscourage.webDomainTokens,
//                                threshold: DateComponents(second: 30)),
//     .seven: DeviceActivityEvent(applications: MyManagedSettings.shared.selectionToDiscourage.applicationTokens,
//                                categories: MyManagedSettings.shared.selectionToDiscourage.categoryTokens,
//                                webDomains: MyManagedSettings.shared.selectionToDiscourage.webDomainTokens,
//                                threshold: DateComponents(second: 35)),
//     .eight: DeviceActivityEvent(applications: MyManagedSettings.shared.selectionToDiscourage.applicationTokens,
//                                categories: MyManagedSettings.shared.selectionToDiscourage.categoryTokens,
//                                webDomains: MyManagedSettings.shared.selectionToDiscourage.webDomainTokens,
//                                threshold: DateComponents(second: 40)),
//     .nine: DeviceActivityEvent(applications: MyManagedSettings.shared.selectionToDiscourage.applicationTokens,
//                                categories: MyManagedSettings.shared.selectionToDiscourage.categoryTokens,
//                                webDomains: MyManagedSettings.shared.selectionToDiscourage.webDomainTokens,
//                                threshold: DateComponents(second: 45)),
//     .ten: DeviceActivityEvent(applications: MyManagedSettings.shared.selectionToDiscourage.applicationTokens,
//                                categories: MyManagedSettings.shared.selectionToDiscourage.categoryTokens,
//                                webDomains: MyManagedSettings.shared.selectionToDiscourage.webDomainTokens,
//                                threshold: DateComponents(second: 50)),]
