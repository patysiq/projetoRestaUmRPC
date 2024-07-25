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
    @AppStorage("yourName") var yourName = ""
    @StateObject var game = GameService()

    var body: some Scene {
        WindowGroup {
            if yourName.isEmpty {
                YourNameView()
            } else {
                StartView(yourName: yourName)
                    .environmentObject(game)
            }
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


