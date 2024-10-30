//
//  ContentView.swift
//  MindMosaic
//
//  Created by Gurvir Singh on 2024-10-28.
//

import SwiftUI
import UserNotifications
import FirebaseFirestore

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = GratitudeEntryViewModel()
    @State private var showAlert = false

    var body: some View {
        TabView {
            // Main Gratitude Entry Tab
            GratitudeEntryView(viewModel: viewModel, showAlert: $showAlert)
                .tabItem {
                    Label("Gratitude", systemImage: "square.and.pencil")
                }

            // Journal Log Tab
            JournalLogView()
                .tabItem {
                    Label("Journal Log", systemImage: "book.fill")
                }

            // Wellness Tips Tab
            WellnessTipsView(context: viewContext)
                .tabItem {
                    Label("Wellness Tips", systemImage: "leaf.fill")
                }

            // Settings Tab
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .onAppear {
            requestNotificationPermission()
            viewModel.fetchQuote() // Fetch the quote only once when the app starts
        }
    }
    
    // Function to request notification permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            } else if granted {
                print("Notification permission granted")
                scheduleDailyNotification()
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    // Function to schedule a daily notification
    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "MindMosaic Reminder"
        content.body = "Don't forget to log in and reflect on your day!"
        content.sound = .default

        // Set the notification trigger for 8:00 AM every day
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Daily notification scheduled.")
            }
        }
    }
}

// Separate Gratitude Entry View
struct GratitudeEntryView: View {
    @ObservedObject var viewModel: GratitudeEntryViewModel
    @Binding var showAlert: Bool

    var body: some View {
        VStack(spacing: 20) {
            // Display the quote fetched from ZenQuotes API
            Text(viewModel.quoteText)
                .font(.subheadline)
                .italic()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if !viewModel.quoteAuthor.isEmpty {
                Text("- \(viewModel.quoteAuthor)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Text("What are you grateful for today?")
                .font(.headline)
                .padding(.top)
            
            // Entry text fields bound to ViewModel properties
            TextField("First entry...", text: $viewModel.entry1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Second entry...", text: $viewModel.entry2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Third entry...", text: $viewModel.entry3)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Submit button triggers ViewModel function
            Button(action: {
                if !viewModel.isValid() {
                    showAlert = true
                } else {
                    viewModel.submitEntries()
                }
            }) {
                Text("Submit")
                    .font(.title2)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Validation Error"),
                    message: Text("Please make sure each entry is unique, non-empty, and does not exceed the character limit."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
    }
}
