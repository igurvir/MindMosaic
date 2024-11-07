//  JournalLogView.swift
//  MindMosaic
//  Created by Gurvir Singh on 2024-10-28.
//  Student Id-991675538

import SwiftUI

struct JournalLogView: View {
    @StateObject private var viewModel = GratitudeEntryViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.entriesByDate.keys.sorted(), id: \.self) { date in
                    NavigationLink(destination: EntriesView(date: date, entries: viewModel.entriesByDate[date] ?? [])) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            Text(date)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                }
            }
            .navigationTitle("Journal Log")
            .listStyle(InsetGroupedListStyle())
            .onAppear {
                viewModel.fetchEntries()
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

struct EntriesView: View {
    var date: String
    var entries: [String]

    var body: some View {
        List(entries, id: \.self) { entry in
            VStack(alignment: .leading, spacing: 8) {
                Text(entry)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.vertical, 6)
                    .padding(.horizontal)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .navigationTitle(date)
        .listStyle(PlainListStyle()) // Minimalist look for the list
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview {
    JournalLogView()
}
