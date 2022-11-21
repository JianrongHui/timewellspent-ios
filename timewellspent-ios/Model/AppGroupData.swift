//
//  AppGroupData.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/17.
//

import Foundation

enum AppGroupData {
    static let appGroupName = "group.leaveylabs.screentime"
//    static let consecutiveTimeKey = "consecutiveTime"
    static let notificationSettingKey = "notificationSetting"
    static let savedDataDateKey = "savedDataDate"
    
    static let userDefaults = UserDefaults(suiteName: AppGroupData.appGroupName)
}
