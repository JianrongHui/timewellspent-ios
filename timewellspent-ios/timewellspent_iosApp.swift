//
//  timewellspent_iosApp.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/03.
//

import SwiftUI

@main
struct timewellspent_iosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
