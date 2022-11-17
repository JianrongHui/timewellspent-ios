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

public struct Session: Codable {
    let beforeRating: Int
    let afterRating: Int
    let timestamp: Date
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}


// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.

struct AppGroupData {
    static let appGroup = "group.leaveylabs.screentime"
    static let consecutiveTime = "consecutiveTime"
}

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    let store = ManagedSettingsStore(named: ManagedSettingsStore.Name(rawValue: "discouraged"))
        
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        let userDefaults = UserDefaults(suiteName: AppGroupData.appGroup)
        
        //we need to make sure the hour is this hour
        //the event might be auto called if it was the previous hour
        print("Starting monitoring. Hour is: ", Calendar.current.dateComponents([.hour, .minute], from: Date()).hour!)

//        guard
//            let eventHour = Int(event.rawValue),
//            let nowHour = Calendar.current.dateComponents([.hour], from: Date()).hour
//        else { return }
//
//        userDefaults?.set(eventHour, forKey: "eventHour")
//        userDefaults?.set(nowHour, forKey: "nowHour")
//
//        if eventHour == nowHour {
        
        //THATS FUCKING CRAZY IT WORKRREDDDDDDDD
            FirebaseApp.configure()
            let db = Firestore.firestore()
            let currentSession = Session(beforeRating: 0, afterRating: 0, timestamp: Date())
            db.collection("session").document(UUID().uuidString).setData(currentSession.dictionary)
        
            ManagedSettingsStore().shield.applicationCategories = .all()
            ManagedSettingsStore().shield.webDomainCategories = .all()
//        }

        
        //TODO:
        //ask to send a notification
//        let url = URL(string: "\(BASE_URL)/photos/random")!
//        var urlRequest = URLRequest(url: url)
//        urlRequest.setValue("Client-ID \(ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
//        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if let data = data {
//                //we have data
//                userDefaults?.set("yes", forKey: "diditwork")
////                print("WE GOT DATA data \(data)")
//            }
//        }.resume()
        
        
        //ALTERNATE APPROACH
        
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
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
    }
    
}
