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
        NavigationView {
            VStack(spacing: 20) {
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
                
                // Navigation link to Journal Log
                NavigationLink(destination: JournalLogView()) {
                    Text("View Journal Log")
                        .font(.headline)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.top)
                
                // Navigation link to Wellness Tips with Core Data context
                NavigationLink(destination: WellnessTipsView(context: viewContext)) {
                    Text("View Wellness Tips")
                        .font(.headline)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.top)
            }
            .onAppear {
                requestNotificationPermission()
            }
            .padding()
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

#Preview {
    ContentView()
}
