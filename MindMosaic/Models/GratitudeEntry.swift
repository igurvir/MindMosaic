import Foundation
import FirebaseFirestore

struct GratitudeEntry: Identifiable {
    var id: String // This will be the date (document ID) from Firestore
    var entries: [String]
    var timestamp: Date
    
    // Initialize from Firestore data
    init?(id: String, data: [String: Any]) {
        self.id = id
        self.entries = data["entries"] as? [String] ?? []
        if let timestamp = data["timestamp"] as? Timestamp {
            self.timestamp = timestamp.dateValue()
        } else {
            return nil
        }
    }
}
