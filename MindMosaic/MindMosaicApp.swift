//
//  MindMosaicApp.swift
//  MindMosaic
//
//  Created by Gurvir Singh on 2024-10-28.
//

import SwiftUI

@main
struct MindMosaicApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
