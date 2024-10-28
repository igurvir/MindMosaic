import Foundation
import FirebaseFirestore
import Combine
import UserNotifications

class GratitudeEntryViewModel: ObservableObject {
    @Published var entriesByDate: [String: [String]] = [:] // Data for Journal Log
    @Published var entry1: String = ""
    @Published var entry2: String = ""
    @Published var entry3: String = ""
    private let db = Firestore.firestore()

    init() {
        requestNotificationPermission() // Request permission when initializing the ViewModel
    }

    // Fetch entries from Firestore and organize them by date
    func fetchEntries() {
        db.collection("gratitude_entries").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            var newEntriesByDate: [String: [String]] = [:]
            for document in documents {
                let date = document.documentID
                if let entries = document.data()["entries"] as? [String] {
                    newEntriesByDate[date] = entries
                }
            }
            self.entriesByDate = newEntriesByDate
        }
    }

    // Validate entries to ensure they're unique, non-empty, and within character limit
    func isValid() -> Bool {
        let entries = [entry1, entry2, entry3].filter { !$0.isEmpty }
        let uniqueEntries = Set(entries)
        return entries.count == uniqueEntries.count && !entries.isEmpty && !entries.contains(where: { $0.count > 100 })
    }

    // Submit entries to Firestore and append if they exist on the same day
    func submitEntries() {
        if !isValid() {
            print("Validation error.")
            return
        }

        let entries = [entry1, entry2, entry3].filter { !$0.isEmpty }
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        let documentRef = db.collection("gratitude_entries").document(today)

        // Check if today's document already exists
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists, var existingData = document.data() {
                // Retrieve existing entries and append new ones
                var allEntries = existingData["entries"] as? [String] ?? []
                allEntries.append(contentsOf: entries) // Append new entries to existing ones

                // Update Firestore with the combined entries
                documentRef.setData(["entries": allEntries, "timestamp": Timestamp(date: Date())], merge: true) { error in
                    if let error = error {
                        print("Error saving data: \(error)")
                    } else {
                        print("Entries saved successfully!")
                        self.clearEntries()
                        self.scheduleSaveNotification()
                    }
                }
            } else {
                // If no existing document, create a new one
                let newEntryData: [String: Any] = ["entries": entries, "timestamp": Timestamp(date: Date())]
                documentRef.setData(newEntryData) { error in
                    if let error = error {
                        print("Error saving data: \(error)")
                    } else {
                        print("Entries saved successfully!")
                        self.clearEntries()
                        self.scheduleSaveNotification()
                    }
                }
            }
        }
    }

    // Clear entries after submission
    private func clearEntries() {
        entry1 = ""
        entry2 = ""
        entry3 = ""
    }

    // Request notification permission
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            } else if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }

    // Schedule a notification to notify user of successful save
    private func scheduleSaveNotification() {
        let content = UNMutableNotificationContent()
        content.title = "MindMosaic"
        content.body = "Yay! Your gratitude entry has been saved successfully! 🤩"
        content.sound = .default

        // Trigger notification immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Save notification scheduled successfully.")
            }
        }
    }
}
