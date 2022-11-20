//
//  ContentView.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/12.
//

import SwiftUI
import ManagedSettings

struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @State var isMeditationInProgress: Bool = ManagedSettingsStore().isShieldOpen

    var body: some View {
        HomeView(myManagedSettings: MyManagedSettingsService.shared)
            .isHidden(isMeditationInProgress, remove: true)
        
        MeditationView().frame(maxWidth: .infinity, maxHeight: .infinity)
            .isHidden(!isMeditationInProgress, remove: true)
            .environment(\.meditation, $isMeditationInProgress)
            .onChange(of: scenePhase) { newValue in
                isMeditationInProgress = ManagedSettingsStore().isShieldOpen
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
