//  Created by Gurvir Singh on 2024-10-28.
//  Student Id-991675538
import Foundation
import FirebaseFirestore

struct GratitudeEntry: Identifiable {
    var id: String 
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
