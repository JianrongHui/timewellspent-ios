//
//  CustomizeNotificationsView.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/20.
//

import Foundation
import SwiftUI
import FamilyControls

struct CustomizeNotificationsView: View {
    @ObservedObject var myMSS: MyManagedSettingsService
    @Binding var showSheet: Bool
    @Binding var notificationStatus: Bool
    @Binding var isGoToSettingsAlertPresented: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Text("Notification Assist")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.body)
            Text("Easily open the app via a banner notification alongside the interruption.\n\nMake sure your notifications are turned on.\n")
                .multilineTextAlignment(.center)
                .lineLimit(5)
                .minimumScaleFactor(0.8)
            Spacer()
            Toggle(isOn: $notificationStatus) {
                Text(notificationStatus ? "Enabled" : "Disabled")
                    .font(.title2)
                    .fontWeight(.bold)
            }
                .onChange(of: notificationStatus) { newValue in
                    notificationsSetTo(newValue)
                }
                .padding([.leading, .trailing], 20)
            Image("notifications-demo")
                .resizable()
                .scaledToFit()
            Spacer()
            Button {
                showSheet = false
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .fontWeight(.bold)
            }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.accentColor)
                .tint(.white)
                .cornerRadius(40)
        }
        .font(.body)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(EdgeInsets(top: 8, leading: 15, bottom: 20, trailing: 15))
        .foregroundColor(.white)
        .background(.tint)
    }
    
    func notificationsSetTo(_ shouldNotify: Bool) {
        if shouldNotify {
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    DeviceService.shared.updateNotificationSetting(to: true)
                    print("UPDATE TO TRUE")
                    
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            DeviceService.shared.updateNotificationSetting(to: true)
                        } else {
                            notificationStatus = false
                        }
                    }
                default:
                    isGoToSettingsAlertPresented = true
                    notificationStatus = false
                }
            })
        } else {
            DeviceService.shared.updateNotificationSetting(to: false)
        }
    }
    
}

struct CustomizeNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizeNotificationsView(myMSS: MyManagedSettingsService.shared, showSheet: .constant(true), notificationStatus: .constant(true), isGoToSettingsAlertPresented: .constant(false))
    }
}
