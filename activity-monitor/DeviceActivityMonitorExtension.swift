//
//  DeviceActivityMonitorExtension.swift
//  activity-monitor
//
//  Created by Adam Novak on 2022/11/11.
//

import DeviceActivity
import ManagedSettings
import Foundation

import FirebaseCore
import FirebaseFirestore
import UserNotifications

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    //PROPERTIES
    let store = ManagedSettingsStore(named: ManagedSettingsStore.Name(rawValue: "discouraged"))
    let userDefaults = UserDefaults(suiteName: AppGroupData.appGroupName)!

    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        //FLAGS
        let shouldResetDailyDefaults: Bool

        //PERFORM CHECKS
        let thisHour = (Calendar.current.dateComponents([.hour], from: Date()).hour)!
        let activityHour = activity.rawValue

        //Check: in case a schedule is auto called for a previous hour
        guard String(thisHour) == activityHour || String(thisHour-1) == activityHour else { return } //activityHour 22 covers both 22 and 23 o'clock

        //Check: if today is a new day, reset all userDefaults
        if let userDefaultsDate = userDefaults.object(forKey: AppGroupData.savedDataDateKey) as? Date {
            let diff = Calendar.current.dateComponents([.day], from: Date(), to: userDefaultsDate)
            shouldResetDailyDefaults = diff.day != 0
        } else {
            shouldResetDailyDefaults = false
        }

        //Check: we haven't already displayed a shield for this hour today
        if !shouldResetDailyDefaults { //if we should reset daily defaults, then we don't need to worry abt it being the same day
            let didAlreadyRunToday = userDefaults.object(forKey: activityHour) as? Bool
            if let didAlreadyRunToday, didAlreadyRunToday == true { return }
        }
        
        
        //BLOCK ALL APPS
        //NOTE: this cannot go in its own function. My own custom functions can't be called in this extension... but somehow, Firebase's "FirebaseApp.configure() does work?
        ManagedSettingsStore().shield.webDomainCategories = .all()
        ManagedSettingsStore().shield.applicationCategories = .all()

        
        //PREPARE NOTIFICATION
        if
            let notifsOn = userDefaults.object(forKey: AppGroupData.notificationSettingKey) as? Bool,
            notifsOn == true {
            let content = UNMutableNotificationContent()
            content.title = "Have a mindberry"
            content.subtitle = "Tap to start a mindfulness break"
            content.sound = nil
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) //show this 0.6 seconds from now
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }

        
        //PREPARE MINDFUL BREAK
        let rightNow = Calendar.current.dateComponents([.hour, .minute, .second], from: .now)
        var fifteenMinutesFromNow = rightNow
        fifteenMinutesFromNow.minute! += 40 //must be at least 15 min interval. both must be in the future
        let warningBeforehand = DateComponents(minute: 35)
        let fifteenMinuteSchedule = DeviceActivitySchedule(intervalStart: rightNow,
                                                           intervalEnd: fifteenMinutesFromNow,
                                                           repeats: false,
                                                           warningTime: warningBeforehand)
        do {
            try DeviceActivityCenter().startMonitoring(.mindfulBreak,
                                                     during: fifteenMinuteSchedule)
        } catch {
            
        }
    
        //PERSIST CHANGES TO USER DEFAULTS
        Task {
            if shouldResetDailyDefaults {
                for x in 0..<24 {
                    userDefaults.set(false, forKey: String(x)) // erase all the previous day's data
                }
            }
            userDefaults.set(Date(), forKey: AppGroupData.savedDataDateKey)
            userDefaults.set(true, forKey: activityHour)
        }
        
        
        
        //ALTERNATE APPROACH, CREATING EVENTS TO DETECT CUMULATION AS IT BUILDS UP
        
        //we either need:
        //20 different intervals throughout the day, each for each hour
            //have 1 20 minute threshold in each hour
        //20 different intervals throughout the day, each for each hour
            //have 12 different 5 minute intervals in each hour
        //ORRRR 1 interval for the whole day
            //have like 40 different 5 minute intervals
        
        //create a schedule for all day long
        //create a repeating event for every single minute
        //every time the event goes off, we add a minute to the data store
        
        //partially failed idea: detect events for usage every 5 seconds, and once we've had 25 seconds of continuous usage, then show the shield
        //this worked a couple times...
//        if userDefaults?.object(forKey: event.rawValue) != nil {
//            //do nothing
//        } else {
//            userDefaults?.set(Date(), forKey: event.rawValue)
//            let prevEventIndex = Int(event.rawValue)! - 1
//            guard prevEventIndex >= 0 else { return }
//            let prevEventDate = userDefaults?.object(forKey: String(prevEventIndex)) as! Date
//            let elapsedMinutes = Int(prevEventDate.timeIntervalSinceNow) // % 60 doing elapsed seconds for now
//
//            if elapsedMinutes < 2 {
//                let newConsecutiveTime = userDefaults?.object(forKey: AppGroupData.consecutiveTime) as! Int + 5
//                userDefaults?.set(newConsecutiveTime, forKey: AppGroupData.consecutiveTime)
//                if newConsecutiveTime >= 10 {
//                    store.shield.applicationCategories = .all()
//                    store.shield.webDomainCategories = .all()
//                }
//            }
//        }
    }
    
    //the function below means that...
    //either a) the interval recently started and the user is just now turning on their phone,
    //or b) the user is using their phone and the interval just started
    //now, do something (e.g. turn on shields, maybe more?) related to the activity name
    //e.g., if they created an interval called "DISTRACTINGAPPS" from 10am to 5pm, then we should have associated a ManagedSettingsStore with that interval, and we should turn on that ManagedSettingStore's sheild right now
    //or... maybe we could do even more
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
    }
    
    //the user is casually using iMessage
    //suddenly, it's hit 10pm, and their restriction interval has ended
    //our extension will be called for "interval did end", and we should remove the shield associated with the activity
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)

        //if activity == .mindfulBreak { //unecessary check rn bc warnings are only generated for mindfulBreak
        ManagedSettingsStore().clearAllSettings()
        
//        do {
//            try DeviceActivityCenter().startMonitoring(String(thisHour), during: DeviceActivitySchedule(intervalStart: DateComponents(hour: thisHour, minute: 0), intervalEnd: DateComponents(hour: thisHour, minute: 59), repeats: true))
//        } catch {
//
//        }
        //old code from above
        //        DeviceActivityCenter().stopMonitoring([DeviceActivityName(String(thisHour))])

    }
    
}
