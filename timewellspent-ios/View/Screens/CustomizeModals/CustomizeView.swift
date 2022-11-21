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
    
    @State var estimatedSessionTime = DeviceService.shared.getUserSelectedSessionTime()
    @State var mindfulnessDuration = DeviceService.shared.getMindfulnessDuration()
    
    @State var showNotificationsSheet: Bool = false
    @State var showDurationPickerSheet: Bool = false
    @State var showMindfulnessPickerSheet: Bool = false
    @State var notificationStatus: Bool = (DeviceService.shared.getNotificationSetting() ?? false)
    
    @Binding var showCustomization: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Rectangle()
                .frame(width: 30, height: 3, alignment: .center)
                .cornerRadius(5)
                .foregroundColor(.black.opacity(0.5))
            Text("Customize")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.body)
                .frame(maxHeight: .infinity)
            VStack(alignment: .center, spacing: 12) {
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
                    .frame(height: 35)
                }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(Color(.black.withAlphaComponent(0.6)))
                    .sheet(isPresented: $isDiscouragedPresented, onDismiss: {
                        
                    }, content: {
                        AppPickerView(myMSS: myMSS, showDiscouraged: $isDiscouragedPresented)
                    })
                
                Button {
                    showDurationPickerSheet = true
                } label: {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "clock.badge.exclamationmark")
                        Text("Continuous Screen Time")
                        Spacer()
                        Text(String(estimatedSessionTime) + "min")
                        Image(systemName: "chevron.right")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 35)
                }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(Color(.black.withAlphaComponent(0.6)))
                    .sheet(isPresented: $showDurationPickerSheet) {
                        DurationPickerView(myMSS: myMSS, showCustomization: $showDurationPickerSheet, selectedMinute: $estimatedSessionTime)
                            .presentationDetents([.medium])
                    }
                Button {
                    showNotificationsSheet = true
                } label: {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "bell")
                        Text("Notification Assist")
                        Spacer()
                        Text(notificationStatus ? "On" : "Off")
                        Image(systemName: "chevron.right")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 35)
                }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(Color(.black.withAlphaComponent(0.6)))
                    .sheet(isPresented: $showNotificationsSheet) {
                        CustomizeNotificationsView(myMSS: myMSS, showSheet: $showNotificationsSheet, notificationStatus: $notificationStatus, isGoToSettingsAlertPresented: $isGoToSettingsAlertPresented)
    //                        .presentationDetents([.medium])
                    }
                
                Button {
                    showMindfulnessPickerSheet = true
                } label: {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "stopwatch")
                        Text("Mindfulness Break")
                        Spacer()
                        Text(String(mindfulnessDuration) + "min")
                        Image(systemName: "chevron.right")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 35)
                }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(Color(.black.withAlphaComponent(0.6)))
                    .sheet(isPresented: $showMindfulnessPickerSheet) {
                        MindfulnessDurationPickerView(myMSS: myMSS, showCustomization: $showMindfulnessPickerSheet, selectedMinute: $mindfulnessDuration)
                            .presentationDetents([.medium])
                    }
            }
            .frame(maxHeight: .infinity)
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
}

struct CustomizeView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizeView(myMSS: MyManagedSettingsService.shared, showCustomization: .constant(true))
    }
}
