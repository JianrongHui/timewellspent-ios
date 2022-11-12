//
//  DeviceActivityMonitorExtension.swift
//  activity-monitor
//
//  Created by Adam Novak on 2022/11/11.
//

import DeviceActivity

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
    
    //the function below means that...
    //either a) the interval recently started and the user is just now turning on their phone,
    //or b) the user is using their phone and the interval just started
    //now, do something (e.g. turn on shields, maybe more?) related to the activity name
    //e.g., if they created an interval called "DISTRACTINGAPPS" from 10am to 5pm, then we should have associated a ManagedSettingsStore with that interval, and we should turn on that ManagedSettingStore's sheild right now
    //or... maybe we could do even more
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        //if we had more than one store, we should first....
        //get the activity name, then set shield restrictions for that activity name in particular
//        MyManagedSettings.shared.setShieldRestrictions()
    }
    
    //the user is casually using iMessage
    //suddenly, it's hit 10pm, and their restriction interval has ended
    //our extension will be called for "interval did end", and we should remove the shield associated with the activity
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        print("INTERVAL DID END")

//        let discouragedStore = ManagedSettingsStore(named: .discouraged)
//        discouragedStore.clearAllSettings()
        //store.shield.applications = nil //or you could do this
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        //so you know which event fired for which activity name
        
        print("DID REACH THRESHHOLD")
    }
    
}
