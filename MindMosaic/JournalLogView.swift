import SwiftUI
import FirebaseFirestore

struct JournalLogView: View {
    @State private var entriesByDate: [String: [String]] = [:] // Dictionary to store dates and entries
    let db = Firestore.firestore() // Firestore database reference

    var body: some View {
        NavigationView {
            List {
                ForEach(entriesByDate.keys.sorted(), id: \.self) { date in
                    NavigationLink(destination: EntriesView(date: date, entries: entriesByDate[date] ?? [])) {
                        Text(date)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Journal Log")
            .onAppear(perform: fetchEntries)
        }
    }

    func fetchEntries() {
        db.collection("gratitude_entries").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            var newEntriesByDate: [String: [String]] = [:]
            for document in documents {
                let date = document.documentID
                let data = document.data()
                if let entries = data["entries"] as? [String] {
                    newEntriesByDate[date] = entries
                }
            }
            entriesByDate = newEntriesByDate
        }
    }
}

struct EntriesView: View {
    var date: String
    var entries: [String]

    var body: some View {
        List(entries, id: \.self) { entry in
            Text(entry)
        }
        .navigationTitle(date)
    }
}

#Preview {
    JournalLogView()
}
