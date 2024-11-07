// JournalLogView.swift
// MindMosaic
// Created by Gurvir Singh on 2024-10-28.
// Student Id-991675538

import SwiftUI

struct JournalLogView: View {
    @StateObject private var viewModel = GratitudeEntryViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.entriesByDate.keys.sorted(), id: \.self) { date in
                        NavigationLink(destination: EntriesView(date: date, entries: viewModel.entriesByDate[date] ?? [])) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.blue)
                                Text(date)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.secondarySystemBackground)))
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(UIColor.separator), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
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
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(entries, id: \.self) { entry in
                    Text(entry)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(UIColor.separator), lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(date)
    }
}

#Preview {
    JournalLogView()
}
