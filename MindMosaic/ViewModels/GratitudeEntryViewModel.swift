import Foundation
import FirebaseFirestore
import Combine

class GratitudeEntryViewModel: ObservableObject {
    @Published var entriesByDate: [String: [String]] = [:] // Data for Journal Log
    @Published var entry1: String = ""
    @Published var entry2: String = ""
    @Published var entry3: String = ""
    private let db = Firestore.firestore()

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

    // Submit entries to Firestore
    func submitEntries() {
        if !isValid() {
            print("Validation error.")
            return
        }

        let entries = [entry1, entry2, entry3].filter { !$0.isEmpty }
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        let data: [String: Any] = ["entries": entries, "timestamp": Timestamp(date: Date())]

        db.collection("gratitude_entries").document(today).setData(data, merge: true) { error in
            if let error = error {
                print("Error saving data: \(error)")
            } else {
                print("Entries saved successfully!")
                self.clearEntries()
            }
        }
    }

    // Clear entries after submission
    private func clearEntries() {
        entry1 = ""
        entry2 = ""
        entry3 = ""
    }
}
