//
//  timewellspent_iosApp.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/03.
//

import SwiftUI

@main
struct timewellspent_iosApp: App {

    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

//    @StateObject var model = MyModel.shared
//    @StateObject var store = ManagedSettingsStore() //here, with @StateObject, you initialize the object once for the entire app. this is one recommended way of going about this from apple
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
}
