import Foundation
import FirebaseFirestore
import Combine
import UserNotifications

class GratitudeEntryViewModel: ObservableObject {
    @Published var entriesByDate: [String: [String]] = [:]
    @Published var entry1: String = ""
    @Published var entry2: String = ""
    @Published var entry3: String = ""
    @Published var quoteText: String = ""   // Stores the fetched quote text
    @Published var quoteAuthor: String = "" // Stores the fetched quote author

    private let db = Firestore.firestore()
    private let appSettingsViewModel = AppSettingsViewModel()
    private let quoteService = QuoteService() // Instance of QuoteService

    init() {
        requestNotificationPermission()
        fetchQuote() // Fetch a quote upon initialization
    }

    // Fetch entries from Firestore
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

    // Validate entries
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
        let documentRef = db.collection("gratitude_entries").document(today)

        documentRef.getDocument { (document, error) in
            if let document = document, document.exists, let existingData = document.data() {
                var allEntries = existingData["entries"] as? [String] ?? []
                allEntries.append(contentsOf: entries)

                documentRef.setData(["entries": allEntries, "timestamp": Timestamp(date: Date())], merge: true) { error in
                    if error == nil {
                        self.clearEntries()
                        self.scheduleSaveNotification()
                        print("Calling updateStreak")
                        self.appSettingsViewModel.updateStreak()
                    }
                }
            } else {
                let newEntryData: [String: Any] = ["entries": entries, "timestamp": Timestamp(date: Date())]
                documentRef.setData(newEntryData) { error in
                    if error == nil {
                        self.clearEntries()
                        self.scheduleSaveNotification()
                        print("Calling updateStreak")
                        self.appSettingsViewModel.updateStreak()
                    }
                }
            }
        }
    }

    // Fetch a random quote from ZenQuotes API
    func fetchQuote() {
        quoteService.fetchRandomQuote { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let quote):
                    self.quoteText = quote.q
                    self.quoteAuthor = quote.a
                case .failure(let error):
                    print("Error fetching quote: \(error)")
                    self.quoteText = "Stay positive and keep moving forward!"
                    self.quoteAuthor = "Unknown"
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
            if granted {
                print("Notification permission granted")
            }
        }
    }

    // Schedule a notification after successful save
    private func scheduleSaveNotification() {
        let content = UNMutableNotificationContent()
        content.title = "MindMosaic"
        content.body = "Your gratitude entry has been saved successfully!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
