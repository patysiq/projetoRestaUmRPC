//
//  oneLeftApp.swift
//  oneLeft
//
//  Created by PATRICIA S SIQUEIRA on 25/07/24.
//

import SwiftUI

@main
struct oneLeftApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
