//
//  SelectAppsToLimit.swift
//  pause
//
//  Created by Adam Novak on 2022/11/10.
//

import Foundation
import SwiftUI
import FamilyControls

struct HomeView: View {
    @ObservedObject var myManagedSettings: MyManagedSettings //ObservedObject is like a StateObject, except instead of being managed by the SwiftUI View, it's a separate entity
    @State var isDiscouragedPresented = false
    @State private var isGoToSettingsAlertPresented = false

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 30) {
                Spacer()
//                CircleImageUIView()
//                    .offset(y: -130)
//                    .padding(.bottom, -130)
//                if myManagedSettings.isActive {
//                    Text("is active!")
//                } else {
//                    Text("is not active!")
//                }
                Image("smileberry").resizable().frame(width: 200, height: 200, alignment: .center)
                Spacer()
                Button {
                    selectAppsPressed()
                } label: {
                    Text("Select Apps to Discourage")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .foregroundColor(.accentColor)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .familyActivityPicker(isPresented: $isDiscouragedPresented, selection: $myManagedSettings.selectionToDiscourage).onChange(of: myManagedSettings.selectionToDiscourage) { newSelection in
                        myManagedSettings.setShieldRestrictions()
                    }

                Toggle(isOn: $myManagedSettings.isActive) {
                    Text(myManagedSettings.isActive ? "Monitoring Active" : "Monitoring Inactive")
                        .fontWeight(.bold)
                }.onChange(of: myManagedSettings.isActive) { newValue in
                    toggleMonitoringPresed()
                }
            }
            .foregroundColor(.black)
            .padding(EdgeInsets(top: 0, leading: 25, bottom: 25, trailing: 25))
            .navigationTitle("Mindberry")
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
//        let userDefaults = UserDefaults(suiteName: "group.leaveylabs.screentime") //not sure if this would be reliable
//        let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.leaveylabs.screentime") //this one should work.
        //basically, each extension acts as its own independent app, a sandbox
        //i can save info to the appGroupURL and read it in the sandboxes. that's all the extra data i can get from the sandboxes
        
        switch AuthorizationCenter.shared.authorizationStatus {
        case .notDetermined:
            requestScreentimeAuthorization {
                self.selectAppsPressed()
            }
        case .approved:
            //toggle myManagedSettings activation
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
            isDiscouragedPresented = true
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
