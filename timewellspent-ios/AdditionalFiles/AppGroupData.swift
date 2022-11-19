//
//  AppGroupData.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/17.
//

import Foundation

struct AppGroupData {
    static let appGroup = "group.leaveylabs.screentime"
    static let consecutiveTime = "consecutiveTime"
    static var notificationSetting = "notificationSetting"
    
    static func updateNotificationSetting(to newValue: Bool) {
        let userDefaults = UserDefaults(suiteName: AppGroupData.appGroup)
        userDefaults?.setValue(newValue, forKey: notificationSetting)
    }
}
