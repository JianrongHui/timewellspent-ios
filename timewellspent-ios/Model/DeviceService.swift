//
//  DeviceService.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/19.
//

import Foundation

class DeviceService: NSObject {
    
    static var shared = DeviceService()
    private let LOCAL_FILE_APPENDING_PATH = "device.json"
    private var localFileLocation: URL!
    private var device: Device!
    
    //MARK: - Initializer
    
    //private initializer because there will only ever be one instance of UserService, the singleton
    private override init() {
        super.init()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        localFileLocation = documentsDirectory.appendingPathComponent(LOCAL_FILE_APPENDING_PATH)
        if FileManager.default.fileExists(atPath: localFileLocation.path) {
            loadFromFilesystem()
        } else {
            device = Device()
            Task { await saveToFilesystem() }
        }
    }
    
    //MARK: - Getters
    
    func getNotificationSetting() -> Bool? {
        return AppGroupData.userDefaults?.value(forKey: AppGroupData.notificationSettingKey) as? Bool
    }
    
    func getUserSelectedSessionTime() -> Int {
        return device.estimatedSessionTime
    }
    
    func getVariedSessiontime() -> Int {
        let variance = device.estimatedSessionTime / 10
        return device.estimatedSessionTime + Int.random(in: -variance...variance)
    }
    
    func hasRatedApp() -> Bool { return device.hasRatedApp }
    
    func getMindfulnessDuration() -> Int {
        return device.mindfulnessDuration
    }
    
    func getLastReceivedNewUpdateAlertVersion() -> String {
        return device.lastReceivedNewUpdateAlertVersion
    }
    
    //MARK: - Setters
    
    func updateNotificationSetting(to newValue: Bool) {
        AppGroupData.userDefaults?.setValue(newValue, forKey: AppGroupData.notificationSettingKey)
    }
    
    func setEstimatedSessionTime(to newTime: Int) {
        device.estimatedSessionTime = newTime
        Task { await saveToFilesystem() }
    }
    
    func setMindfulnessDuration(to newTime: Int) {
        device.mindfulnessDuration = newTime
        Task { await saveToFilesystem() }
    }
    
    func didRateApp() {
        device.hasRatedApp = true
        Task { await saveToFilesystem() }
    }
    
    func didReceiveNewUpdateAlert(forVersion version: String) {
        device.lastReceivedNewUpdateAlertVersion = version
        Task { await saveToFilesystem() }
    }
    
    //MARK: - Filesystem
    
    func saveToFilesystem() async {
        do {
            let encoder = JSONEncoder()
            let data: Data = try encoder.encode(device)
            let jsonString = String(data: data, encoding: .utf8)!
            try jsonString.write(to: self.localFileLocation, atomically: true, encoding: .utf8)
        } catch {
            print("COULD NOT SAVE: \(error)")
        }
    }

    func loadFromFilesystem() {
        do {
            let data = try Data(contentsOf: self.localFileLocation)
            device = try JSONDecoder().decode(Device.self, from: data)
        } catch {
            print("COULD NOT LOAD: \(error)")
        }
    }
    
    func eraseData() {
        do {
            try FileManager.default.removeItem(at: self.localFileLocation)
        } catch {
            print("\(error)")
        }
    }
}
