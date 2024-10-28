import SwiftUI

struct JournalLogView: View {
    @StateObject private var viewModel = GratitudeEntryViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.entriesByDate.keys.sorted(), id: \.self) { date in
                    NavigationLink(destination: EntriesView(date: date, entries: viewModel.entriesByDate[date] ?? [])) {
                        Text(date)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Journal Log")
            .onAppear {
                viewModel.fetchEntries()
            }
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
