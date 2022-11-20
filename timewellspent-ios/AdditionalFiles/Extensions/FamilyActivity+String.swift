//
//  FamilyActivity+String.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/19.
//

import Foundation
import FamilyControls

extension FamilyActivitySelection {
    
    var blockedString: String {
        var string = ""
        if categories.count > 0 {
            string += String(categories.count) + (categories.count == 1 ? " group" : " groups")
        }
        
        let appCount = applications.count + webDomains.count
        if appCount > 0 {
            if categories.count > 0 {
                string += ", "
            }
            string += String(appCount) + (appCount == 1 ? " app" : " apps")
        }
        
        if categories.count == 0 && appCount == 0 {
            string += "0 apps"
        }
        
        return string
    }
}
