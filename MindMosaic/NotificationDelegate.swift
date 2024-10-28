//
//  NotificationDelegate.swift
//  MindMosaic
//
//  Created by Gurvir Singh on 2024-10-28.
//

import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate() // Singleton instance

    private override init() {
        super.init()
    }

    // This function is called when a notification is received while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Display the notification as a banner and play the sound while the app is in the foreground
        completionHandler([.banner, .sound])
    }

    // This function is called when the user interacts with the notification (e.g., tapping it)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle any custom behavior when the notification is tapped, if needed
        print("Notification tapped: \(response.notification.request.content.body)")
        completionHandler()
    }
}
