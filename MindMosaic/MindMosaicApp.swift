//
//  MindMosaicApp.swift
//  MindMosaic
//
//  Created by Gurvir Singh on 2024-10-28.
//

import SwiftUI
import Firebase
import UserNotifications

@main
struct MindMosaicApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        FirebaseApp.configure() // Initialize Firebase
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared // Set the notification delegate

        // for dark and light mode
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().unselectedItemTintColor = UIColor.systemGray
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
