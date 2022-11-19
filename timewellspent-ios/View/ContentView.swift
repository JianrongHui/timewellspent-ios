//
//  ContentView.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/12.
//

import SwiftUI
import ManagedSettings

struct ContentView: View {
    
    //i guess we need a check for when they meditated
    //well... no we don't want that
    // we want to really make sure that the shield doesn't present itself during the rest of that hour
    //this gets complicated...
    
    @Environment(\.scenePhase) var scenePhase
    @State var isMeditationInProgress: Bool = ManagedSettingsStore().isShieldOpen

    var body: some View {
        if !isMeditationInProgress {
            HomeView(myManagedSettings: MyManagedSettings.shared)
        } else {
            HomeView(myManagedSettings: MyManagedSettings.shared)
//            MeditationView().frame(maxWidth: .infinity, maxHeight: .infinity).environment(\.meditation, $isMeditationInProgress)
        }
        Text("")
            .hidden()
            .onChange(of: scenePhase) { newValue in
                switch newValue{
                case .active, .background:
                    isMeditationInProgress = ManagedSettingsStore().isShieldOpen
                default:
                    break
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
