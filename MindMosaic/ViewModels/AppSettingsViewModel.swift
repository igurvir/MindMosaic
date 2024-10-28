import Foundation
import Combine
import FirebaseFirestore

class AppSettingsViewModel: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var darkModeEnabled: Bool = false
    private let db = Firestore.firestore()

    init() {
        fetchStreak()
    }
    
    // Fetch user's streak from Firestore
    private func fetchStreak() {
        db.collection("user_settings").document("streak").getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                self.currentStreak = data["streakCount"] as? Int ?? 0
            } else {
                print("Streak document does not exist: \(error?.localizedDescription ?? "No error")")
            }
        }
    }

    // Update the streak in Firestore
    func updateStreak(didLogToday: Bool) {
        if didLogToday {
            currentStreak += 1
        } else {
            currentStreak = 0
        }
        
        db.collection("user_settings").document("streak").setData(["streakCount": currentStreak]) { error in
            if let error = error {
                print("Error updating streak: \(error)")
            } else {
                print("Streak updated successfully")
            }
        }
    }
    
    // Toggle dark mode
    func toggleDarkMode() {
        darkModeEnabled.toggle()
        // Save darkModeEnabled preference as needed
    }
}
