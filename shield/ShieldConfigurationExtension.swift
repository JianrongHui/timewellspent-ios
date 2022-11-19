//
//  ShieldConfigurationExtension.swift
//  shield
//
//  Created by Adam Novak on 2022/11/11.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    let bgColor = UIColor(hex: "#8C567A")
    let title = "Have a mindberry"
    let body = "Open Mindberry for a short mindfulness break."
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
//        let appName = "your name" //application.localizedDisplayName ?? "your phone"
        return ShieldConfiguration(backgroundBlurStyle: .regular,
                                   backgroundColor: bgColor,
                                   icon: UIImage(named: "smileberry.png"),
                                   title: ShieldConfiguration.Label(text: title, color: .white),
                                   subtitle: ShieldConfiguration.Label(text: body, color: .white),
                                   primaryButtonLabel: ShieldConfiguration.Label(text: "Close", color: bgColor),
                                   primaryButtonBackgroundColor: .white,
                                   secondaryButtonLabel: nil)
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        return ShieldConfiguration(backgroundBlurStyle: .regular,
                                   backgroundColor: bgColor,
                                   icon: UIImage(named: "smileberry.png"),
                                   title: ShieldConfiguration.Label(text: title, color: .white),
                                   subtitle: ShieldConfiguration.Label(text: body, color: .white),
                                   primaryButtonLabel: ShieldConfiguration.Label(text: "Close", color: bgColor),
                                   primaryButtonBackgroundColor: .white,
                                   secondaryButtonLabel: nil)
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        return ShieldConfiguration(backgroundBlurStyle: .regular,
                                   backgroundColor: bgColor,
                                   icon: UIImage(named: "smileberry.png"),
                                   title: ShieldConfiguration.Label(text: title, color: .white),
                                   subtitle: ShieldConfiguration.Label(text: body, color: .white),
                                   primaryButtonLabel: ShieldConfiguration.Label(text: "Close", color: bgColor),
                                   primaryButtonBackgroundColor: .white,
                                   secondaryButtonLabel: nil)
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        return ShieldConfiguration(backgroundBlurStyle: .regular,
                                   backgroundColor: bgColor,
                                   icon: UIImage(named: "smileberry.png"),
                                   title: ShieldConfiguration.Label(text: title, color: .white),
                                   subtitle: ShieldConfiguration.Label(text: body, color: .white),
                                   primaryButtonLabel: ShieldConfiguration.Label(text: "Close", color: bgColor),
                                   primaryButtonBackgroundColor: .white,
                                   secondaryButtonLabel: nil)
    }
    
}

public extension UIColor {
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
