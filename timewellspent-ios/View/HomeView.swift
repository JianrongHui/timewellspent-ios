//
//  SelectAppsToLimit.swift
//  pause
//
//  Created by Adam Novak on 2022/11/10.
//

import Foundation
import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings
import UserNotifications

struct HomeView: View {
    @ObservedObject var myManagedSettings: MyManagedSettings //ObservedObject is like a StateObject, except instead of being managed by the SwiftUI View, it's a separate entity
    @State private var isGoToSettingsAlertPresented = false
    @State var notifsEnabled: Bool = UserDefaults(suiteName: AppGroupData.appGroup)?.object(forKey: AppGroupData.notificationSetting) as? Bool ?? false
    @State var showCustomization: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                Rectangle()
                    .frame(height: 25)
                    .foregroundColor(.clear)
                VStack(spacing: 10) {
                    Text("Mindberry")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                    Text("Mindfulness Interruptions")
                        .font(.body)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                Spacer()
                Image("smileberry").resizable().frame(width: 200, height: 200, alignment: .center)
                Spacer()
                Button {
                    toggleMonitoringPresed()
                } label: {
                    Text(myManagedSettings.isActive ? "Enabled" : "Disabled")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .foregroundColor( myManagedSettings.isActive ? .green : .red)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .sheet(isPresented: $showCustomization) {
                        CustomizeView(myManagedSettings: MyManagedSettings.shared)
                            .presentationDetents([.medium])
                    }
                Button {
                    selectAppsPressed()
                } label: {
                    Text("Customize")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .foregroundColor(.accentColor)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .sheet(isPresented: $showCustomization) {
                        CustomizeView(myManagedSettings: MyManagedSettings.shared)
                            .presentationDetents([.medium])
                    }
            }
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 0, leading: 25, bottom: 25, trailing: 25))
            .background(.tint)
            .alert(isPresented: $isGoToSettingsAlertPresented) { () -> Alert in
                Alert(title: Text("Share screen time in settings"),
                      message: Text(""),
                      primaryButton: .default(Text("Settings"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
//                    isGoToSettingsAlertPresented(false)
                }), secondaryButton: .destructive(Text("Cancel")))
            }
        }
    }
    
    func toggleMonitoringPresed() {
        let shouldMonitor = !myManagedSettings.isActive
        myManagedSettings.isActive = shouldMonitor
        switch AuthorizationCenter.shared.authorizationStatus {
        case .notDetermined:
            requestScreentimeAuthorization {
                self.selectAppsPressed()
            }
        case .approved:
            myManagedSettings.toggleMonitoringScreentime(to: shouldMonitor)
            break
        default:
            isGoToSettingsAlertPresented = true
            break
        }
    }
    
    func selectAppsPressed() {
        switch AuthorizationCenter.shared.authorizationStatus {
        case .notDetermined:
            requestScreentimeAuthorization {
                self.selectAppsPressed()
            }
        case .approved:
            showCustomization = true
        default:
            isGoToSettingsAlertPresented = true
            break
        }
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(myManagedSettings: MyManagedSettings.shared)
    }
}
