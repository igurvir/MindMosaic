//  Created by Gurvir Singh on 2024-10-28.
//  Student Id-991675538
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
    
    func fetchStreak() {
        let documentRef = db.collection("user_settings").document("streak")
        documentRef.getDocument { document, error in
            if let document = document, document.exists {
                self.currentStreak = document.data()?["streakCount"] as? Int ?? 0
                print("Fetched existing streak: \(self.currentStreak)")
            } else {
                print("Streak document does not exist. Initializing with 0.")
                documentRef.setData(["streakCount": 0]) { error in
                    if let error = error {
                        print("Error initializing streak document: \(error)")
                    } else {
                        self.currentStreak = 0
                        print("Initialized streak to 0")
                    }
                }
            }
        }
    }

    func updateStreak() {
        db.collection("gratitude_entries").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching entries: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let submissionDates = documents.compactMap { document -> Date? in
                let timestamp = document.data()["timestamp"] as? Timestamp
                return timestamp?.dateValue()
            }.sorted()
            
            self.currentStreak = self.calculateStreak(from: submissionDates)
            self.saveStreak()
        }
    }

    private func calculateStreak(from dates: [Date]) -> Int {
        guard !dates.isEmpty else { return 0 }
        
        var streak = 1
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        print("Today's Date:", currentDate)
        print("Submission Dates for calculation:", dates)

        if !dates.contains(where: { Calendar.current.isDate($0, inSameDayAs: currentDate) }) {
            streak = 0
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }

        for date in dates.reversed() {
            if Calendar.current.isDate(date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        print("Final calculated streak:", streak)
        return streak
    }

    private func saveStreak() {
        db.collection("user_settings").document("streak").setData(["streakCount": currentStreak]) { error in
            if let error = error {
                print("Error updating streak: \(error)")
            } else {
                print("Streak saved successfully: \(self.currentStreak)")
            }
        }
    }

    func updateTotalEntries() {
        db.collection("gratitude_entries").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching total entries: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.totalEntries = documents.count
            print("Total entries updated: \(self.totalEntries)")
        }
    }
    
    func toggleDarkMode(isEnabled: Bool) {
        darkModeEnabled = isEnabled
        UserDefaults.standard.set(isEnabled, forKey: "isDarkMode")
    }
}
