import Foundation
import Combine
import FirebaseFirestore
import SwiftUI

class AppSettingsViewModel: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var totalEntries: Int = 0
    @AppStorage("isDarkMode") var darkModeEnabled: Bool = false
    private let db = Firestore.firestore()

    init() {
        fetchStreak()
        updateTotalEntries()
    }
    
    // Fetch user's streak from Firestore or create it if it doesn't exist
    func fetchStreak() {
        let documentRef = db.collection("user_settings").document("streak")
        documentRef.getDocument { document, error in
            if let document = document, document.exists {
                self.currentStreak = document.data()?["streakCount"] as? Int ?? 0
            } else {
                print("Streak document does not exist. Initializing with 0.")
                documentRef.setData(["streakCount": 0]) { error in
                    if let error = error {
                        print("Error initializing streak document: \(error)")
                    } else {
                        self.currentStreak = 0
                    }
                }
            }
        }
    }

    // Fetch entries by date and calculate streak
    func updateStreak(didLogToday: Bool) {
        db.collection("gratitude_entries").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching entries: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Extract submission dates and sort them
            let submissionDates = documents.compactMap { document -> Date? in
                let timestamp = document.data()["timestamp"] as? Timestamp
                return timestamp?.dateValue()
            }.sorted()
            
            // Calculate streak
            self.currentStreak = self.calculateStreak(from: submissionDates, didLogToday: didLogToday)
            
            // Save the updated streak
            self.saveStreak()
        }
    }

    // Calculate the current streak based on submission dates
    private func calculateStreak(from dates: [Date], didLogToday: Bool) -> Int {
        guard !dates.isEmpty else { return 0 }

        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())

        // Check if today's log is included
        if didLogToday && dates.contains(where: { Calendar.current.isDate($0, inSameDayAs: currentDate) }) {
            streak += 1
        } else {
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }
        
        // Loop backward through consecutive dates
        for date in dates.reversed() {
            if Calendar.current.isDate(date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        return streak
    }

    // Save the updated streak count to Firestore
    private func saveStreak() {
        db.collection("user_settings").document("streak").setData(["streakCount": currentStreak]) { error in
            if let error = error {
                print("Error updating streak: \(error)")
            } else {
                print("Streak updated successfully to \(self.currentStreak)")
            }
        }
    }

    // Fetch and update total entries count
    func updateTotalEntries() {
        db.collection("gratitude_entries").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching total entries: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.totalEntries = documents.count
        }
    }
    
    // Toggle dark mode in AppStorage
    func toggleDarkMode(isEnabled: Bool) {
        darkModeEnabled = isEnabled
        UserDefaults.standard.set(isEnabled, forKey: "isDarkMode")
    }
}
