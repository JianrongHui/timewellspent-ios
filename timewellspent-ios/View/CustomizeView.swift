//
//  CustomizeView.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/18.
//

import SwiftUI

struct CustomizeView: View {
    @ObservedObject var myManagedSettings: MyManagedSettings
    @State var isDiscouragedPresented = false
    @State private var isGoToSettingsAlertPresented = false

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Customize")
            Button {
                
            } label: {
                Text("Approximate Duration")
            }
            
            Button {
                
            } label: {
                Text("App Selection")
            }
            .familyActivityPicker(isPresented: $isDiscouragedPresented, selection: $myManagedSettings.selectionToDiscourage).onChange(of: myManagedSettings.selectionToDiscourage) { newSelection in
                //handled in the didset in MyManagedSettings
            }
            
            Button {
//                notificationsButtonPressed(to: <#T##Bool#>)
            } label: {
                Text("Notifications")
            }
//            Toggle(isOn: $notifsEnabled) {
//                Text(notifsEnabled ? "Notifications Active" : "Notifications Inactive")
//                    .fontWeight(.bold)
//            }.onChange(of: notifsEnabled) { newValue in
//                enableNotificationsPressed(to: newValue)
//            }
            
            Button {
                
            } label: {
                Text("Save")
            }
        }
        .alert(isPresented: $isGoToSettingsAlertPresented) { () -> Alert in
            Alert(title: Text("Share permissions in settings"),
                  message: Text(""),
                  primaryButton: .default(Text("Settings"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
//                    isGoToSettingsAlertPresented(false)
            }), secondaryButton: .destructive(Text("Cancel")))
        }
    }
    
    func notificationsButtonPressed(to shouldNotify: Bool) {
        if shouldNotify {
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    AppGroupData.updateNotificationSetting(to: true)
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            AppGroupData.updateNotificationSetting(to: true)
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                default:
                    isGoToSettingsAlertPresented = true
                }
            })
        } else {
            AppGroupData.updateNotificationSetting(to: false)
        }
        
    }
}

struct CustomizeView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizeView(myManagedSettings: MyManagedSettings.shared)
    }
}
