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
import StoreKit

struct HomeView: View {
    @ObservedObject var myManagedSettings: MyManagedSettingsService //ObservedObject is like a StateObject, except instead of being managed by the SwiftUI View, it's a separate entity
    @State private var isGoToSettingsAlertPresented = false
    @State var notifsEnabled: Bool = DeviceService.shared.getNotificationSetting() ?? false
    @State var showCustomization: Bool = false
    @State var showDemo: Bool = !MyManagedSettingsService.shared.managedSettings.hasBeenActivatedOnce
    @State var showOptions: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                Rectangle()
                    .frame(height: 15)
                    .foregroundColor(.clear)
                VStack(spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {
                        Button {
                            
                        } label: {
                            Image(systemName: "questionmark.circle")
                        }.hidden()
                        .sheet(isPresented: $showDemo) {
                            DemoView(showDemo: $showDemo)
                        }
                        Spacer()
                        Text("Mindberry")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.body)
                        Button {
                            showOptions = true
                        } label: {
                            Image(systemName: "questionmark.circle")
                        }
                        .confirmationDialog("More", isPresented: $showOptions, titleVisibility: .hidden) {
                            Button {
                                 showDemo = true
                            } label: {
                                Text("How Mindberry works")
                            }
                            Button {
                                UIApplication.shared.open(Constants.feedbackLink as URL)
                            } label: {
                                Text("Provide us feedback")
                            }
//                            Button {
//                                UIApplication.shared.open(Constants.feedbackLink as URL)
//                            } label: {
//                                Text("Leave a review")
//                            }
                            Button {
                                UIApplication.shared.open(Constants.privacyPageLink as URL)
                            } label: {
                                Text("Privacy")
                            }
                        }
                        Spacer()
                    }
                    Text("Mindfulness Interruptions")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                .onAppear {
                    print(AuthorizationCenter.shared.authorizationStatus)
                }
                Spacer()
                Image("smileberry-xl")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                Spacer()
                Button {
                    toggleMonitoringPresed()
                } label: {
                    Text(myManagedSettings.managedSettings.isActive ? "Enabled" : "Disabled")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
                    .buttonStyle(.borderedProminent)
                    .tint(myManagedSettings.managedSettings.isActive ? .green.opacity(0.8) : .red.opacity(0.8))
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.heavy)
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
                    .sheet(isPresented: $showCustomization, onDismiss: {
                        MyManagedSettingsService.shared.refreshMonitoringScreentime() //to save the settings
                    }, content: {
                        CustomizeView(myMSS: MyManagedSettingsService.shared, showCustomization: $showCustomization)
                            .presentationDetents([.medium])
                    })
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
            .padding(EdgeInsets(top: 0, leading: 25, bottom: 25, trailing: 25))
            .alert(isPresented: $isGoToSettingsAlertPresented) { () -> Alert in
                Alert(title: Text("Share screen time in settings"),
                      message: Text(""),
                      primaryButton: .default(Text("Settings"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
//                    isGoToSettingsAlertPresented(false)
                }), secondaryButton: .destructive(Text("Cancel")))
            }
            .background(.tint)
            .foregroundColor(.white)
        }
    }
    
    func toggleMonitoringPresed() {
        switch AuthorizationCenter.shared.authorizationStatus {
        case .notDetermined:
            MyManagedSettingsService.requestScreentimeAuthorization {
                self.toggleMonitoringPresed()
            }
        case .approved:
            let shouldMonitor = !myManagedSettings.managedSettings.isActive
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
            MyManagedSettingsService.requestScreentimeAuthorization {
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
        HomeView(myManagedSettings: MyManagedSettingsService.shared)
    }
}
