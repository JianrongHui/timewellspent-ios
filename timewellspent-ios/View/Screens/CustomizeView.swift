//
//  CustomizeView.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/18.
//

import SwiftUI

struct CustomizeView: View {
    @ObservedObject var myMSS: MyManagedSettingsService
    @State var isDiscouragedPresented = false
    @State private var isGoToSettingsAlertPresented = false
    @State var estimatedSessionTime = DeviceService.shared.getEstimatedSessionTime()
    
    @State var showDurationPickerSheet: Bool = false
    @State var notificationStatus: Bool = (DeviceService.shared.getNotificationSetting() ?? false)
    
    @Binding var showCustomization: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Rectangle()
                .frame(width: 30, height: 3, alignment: .center)
                .cornerRadius(5)
                .foregroundColor(.black.opacity(0.5))
            Spacer()
            Text("Customize")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.body)
            Spacer()
            Button {
                showDurationPickerSheet = true
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "stopwatch")
                    Text("Approximate Duration")
                    Spacer()
                    Text(String(estimatedSessionTime) + "m")
                    Image(systemName: "chevron.right")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
            }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(Color(.black.withAlphaComponent(0.6)))
                .sheet(isPresented: $showDurationPickerSheet) {
                    DurationPickerView(myMSS: MyManagedSettingsService.shared, showCustomization: $showDurationPickerSheet, selectedMinute: $estimatedSessionTime)
                        .presentationDetents([.medium])
                }
            
            Button {
                isDiscouragedPresented = true
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "shield")
                    Text("App Selection")
                    Spacer()
                    Text(myMSS.managedSettings.selectionToDiscourage.blockedString)
                    Image(systemName: "chevron.right")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
            }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(Color(.black.withAlphaComponent(0.6)))
                .sheet(isPresented: $isDiscouragedPresented, onDismiss: {
                    
                }, content: {
                    AppPickerView(myMSS: myMSS, showDiscouraged: $isDiscouragedPresented)
                })
            Button {
                notificationsSetTo(!notificationStatus)
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "bell")
                    Text("Notification Assist")
                    Spacer()
//                    Text(notificationStatus ? "On" : "Off")
//                    Image(systemName: "chevron.right")
                    Toggle("", isOn: $notificationStatus)
                        .tint(.green)
                        .onChange(of: notificationStatus) { newValue in
                            notificationsSetTo(notificationStatus)
                        }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
            }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(Color(.black.withAlphaComponent(0.6)))
            Spacer()
            Button {
                showCustomization = false
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
        .fontWeight(.light)
        .font(.body)
        .alert(isPresented: $isGoToSettingsAlertPresented) { () -> Alert in
            Alert(title: Text("Share permissions in settings"),
                  message: Text(""),
                  primaryButton: .default(Text("Settings"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
//                    isGoToSettingsAlertPresented(false)
            }), secondaryButton: .destructive(Text("Cancel")))
        }
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
                    notificationStatus = true
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            DeviceService.shared.updateNotificationSetting(to: true)
                            notificationStatus = true
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                default:
                    isGoToSettingsAlertPresented = true
                    notificationStatus = false
                }
            })
        } else {
            DeviceService.shared.updateNotificationSetting(to: false)
            notificationStatus = false
        }
        
    }
}

struct CustomizeView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizeView(myMSS: MyManagedSettingsService.shared, showCustomization: .constant(true))
    }
}
