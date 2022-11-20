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

@MainActor
class MyManagedSettingsService: NSObject, ObservableObject {
    
    static let shared = MyManagedSettingsService()
    private let LOCAL_FILE_APPENDING_PATH = "managedsettings.json"
    private var localFileLocation: URL!
    @Published var managedSettings: MyManagedSettings!
        
    private override init() {
        super.init()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        localFileLocation = documentsDirectory.appendingPathComponent(LOCAL_FILE_APPENDING_PATH)
                
        if FileManager.default.fileExists(atPath: localFileLocation.path) {
            loadFromFilesystem()
        } else {
            managedSettings = MyManagedSettings()
            Task { await saveToFilesystem() }
        }
    }
    
    func refreshMonitoringScreentime() {
        toggleMonitoringScreentime(to: managedSettings.isActive)
    }
    
    //NOTE: The maximum number of activities that can be monitored at one time by an app and its extensions is twenty.
    func toggleMonitoringScreentime(to shouldMonitor: Bool) {
        managedSettings.isActive = shouldMonitor
        managedSettings.hasBeenActivatedOnce = true
        ManagedSettingsStore().clearAllSettings()
        let deviceActivityCenter = DeviceActivityCenter()
        deviceActivityCenter.stopMonitoring()

        //this takes a second to start 20 schedules
        Task {
            if shouldMonitor {
                for i in 5..<23 {
                    let hourSchedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: i, minute: 0),
                                                              intervalEnd: DateComponents(hour: i, minute: 59),
                                                              repeats: true)
                    do {
                        try deviceActivityCenter.startMonitoring(DeviceActivityName(String(i)),
                                                                 during: hourSchedule,
                                                                 events: managedSettings.mindfulnessInterruptionEvent)
                    } catch {
                        print("ERROR TRYING TO MONITOR A SCHEDULE", error.localizedDescription)
                    }
                }
            }
        }
        Task { await saveToFilesystem() }
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
    
    static func requestScreentimeAuthorization(callback: @escaping () -> Void) {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                callback()
            } catch {
                print("Failed to enroll Aniyah with error: \(error)")
            }
        }
    }
    
}

//MARK: - Filesystem

extension MyManagedSettingsService {
        
    private func saveToFilesystem() async {
        do {
            let encoder = JSONEncoder()
            let data: Data = try encoder.encode(managedSettings)
            let jsonString = String(data: data, encoding: .utf8)!
            try jsonString.write(to: self.localFileLocation, atomically: true, encoding: .utf8)
        } catch {
            print("COULD NOT SAVE: \(error)")
        }
    }

    private func loadFromFilesystem() {
        do {
            let data = try Data(contentsOf: self.localFileLocation)
            managedSettings = try JSONDecoder().decode(MyManagedSettings.self, from: data)
        } catch {
            print("COULD NOT LOAD: \(error)")
        }
    }
    
    private func eraseData() {
        do {
            try FileManager.default.removeItem(at: self.localFileLocation)
        } catch {
            print("\(error)")
        }
    }
    
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
