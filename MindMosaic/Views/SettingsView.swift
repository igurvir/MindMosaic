// SettingsView.swift
// MindMosaic

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var viewModel = AppSettingsViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false // Dark mode setting

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Info")
                    .font(.headline)
                    .foregroundColor(.primary)) {
                    // Total entries counter
                    HStack {
                        Text("Total Entries")
                        Spacer()
                        Text("\(viewModel.totalEntries)")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                    
                    // Streak counter
                    HStack {
                        Text("Current Streak")
                        Spacer()
                        Text("\(viewModel.currentStreak) 🔥")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Preferences")
                    .font(.headline)
                    .foregroundColor(.primary)) {
                    // Dark Mode Toggle
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(isDarkMode ? .yellow : .blue)
                    }
                    .onChange(of: isDarkMode) { newValue in
                        viewModel.toggleDarkMode(isEnabled: newValue)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                viewModel.updateTotalEntries()
                viewModel.fetchStreak()
            }
            .preferredColorScheme(isDarkMode ? .dark : .light) // Dynamically adjust color scheme
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

#Preview {
    SettingsView()
}
