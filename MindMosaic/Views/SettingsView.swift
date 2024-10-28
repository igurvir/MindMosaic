//
//  SettingsView.swift
//  MindMosaic
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var viewModel = AppSettingsViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false // Dark mode setting

    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.largeTitle)
                .padding(.top)

            // Total entries counter
            HStack {
                Text("Total Entries:")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.totalEntries)")
                    .font(.body)
            }
            .padding()

            // Streak counter
            HStack {
                Text("Current Streak:")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.currentStreak) 🔥")
                    .font(.body)
            }
            .padding()

            // Dark Mode Toggle
            Toggle(isOn: $isDarkMode) {
                Text("Dark Mode")
                    .font(.headline)
            }
            .onChange(of: isDarkMode) { newValue in
                viewModel.toggleDarkMode(isEnabled: newValue)
            }
            .padding()

            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.updateTotalEntries()
            viewModel.fetchStreak()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light) // Dynamically adjust color scheme
    }
}

#Preview {
    SettingsView()
}
