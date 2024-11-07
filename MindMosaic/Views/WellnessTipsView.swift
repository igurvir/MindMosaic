// WellnessTipsView.swift
// MindMosaic
// Created by Gurvir Singh on 2024-10-28.

import SwiftUI
import CoreData

struct WellnessTipsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: WellnessTipsViewModel
    @State private var showSavedTipsOverlay = false

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: WellnessTipsViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.tips.prefix(10), id: \.self) { tip in
                        HStack {
                            Text(tip.name ?? "Unknown Tip")
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)

                            Button(action: {
                                withAnimation {
                                    viewModel.toggleSave(for: tip)
                                }
                            }) {
                                Image(systemName: tip.saved ? "heart.fill" : "heart")
                                    .foregroundColor(tip.saved ? .red : .gray)
                                    .padding()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Wellness Tips")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSavedTipsOverlay = true
                    }) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            viewModel.refreshTips()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .sheet(isPresented: $showSavedTipsOverlay) {
            SavedTipsOverlay(savedTips: viewModel.savedTips)
        }
        .onAppear {
            viewModel.fetchTips()
            viewModel.fetchSavedTips()
        }
    }
}

// Saved Tips Overlay View
struct SavedTipsOverlay: View {
    var savedTips: [WellnessTip]

    var body: some View {
        NavigationView {
            List {
                ForEach(savedTips, id: \.self) { tip in
                    Text(tip.name ?? "Unknown Tip")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .padding(.vertical, 4)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Saved Tips")
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

#Preview {
    WellnessTipsView(context: PersistenceController.preview.container.viewContext)
}
