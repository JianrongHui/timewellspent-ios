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
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        
        let appName = application.localizedDisplayName ?? "this app"
        
        return ShieldConfiguration(backgroundBlurStyle: .dark,
                                   backgroundColor: .tintColor,
                                   icon: UIImage(named: "smileberry"),
                                   title: ShieldConfiguration.Label(text: appName, color: .white),
                                   subtitle: ShieldConfiguration.Label(text: "yoo", color: .red),
                                   primaryButtonLabel: ShieldConfiguration.Label(text: "yoo", color: .red),
                                   primaryButtonBackgroundColor: .purple,
                                   secondaryButtonLabel: ShieldConfiguration.Label(text: "yoo", color: .red))
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
    
}
