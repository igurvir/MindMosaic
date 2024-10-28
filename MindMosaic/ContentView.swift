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
    // States for entries and alert
    @State private var entry1: String = ""
    @State private var entry2: String = ""
    @State private var entry3: String = ""
    @State private var showAlert = false
    let db = Firestore.firestore()  // Firestore database reference

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("What are you grateful for today?")
                    .font(.headline)
                    .padding(.top)
                
                // Entry text fields
                TextField("First entry...", text: $entry1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Second entry...", text: $entry2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Third entry...", text: $entry3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Submit button
                Button(action: submitEntries) {
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
                
                // Navigation link to Wellness Tips
                NavigationLink(destination: WellnessTipsView()) {
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
    
    // Function to handle entry submission with validation
    func submitEntries() {
        // Collect non-empty entries and ensure uniqueness and character limit
        let entries = [entry1, entry2, entry3].filter { !$0.isEmpty }
        let uniqueEntries = Set(entries)
        
        if entries.count != uniqueEntries.count || entries.isEmpty || entries.contains(where: { $0.count > 100 }) {
            showAlert = true
        } else {
            // Save to Firestore
            let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
            let data = ["entries": entries, "timestamp": Timestamp(date: Date())] as [String : Any]
            
            db.collection("gratitude_entries").document(today).setData(data, merge: true) { error in
                if let error = error {
                    print("Error saving data: \(error)")
                } else {
                    print("Entries saved successfully!")
                }
            }
        }
    }
    
    // Function to request notification permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            } else if granted {
                print("Notification permission granted")
                scheduleDailyNotification() // Schedule the notification once permission is granted
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
        dateComponents.hour = 8 // Adjust this for your preferred hour
        dateComponents.minute = 0 // Adjust this for your preferred minute
        
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
