//
//  ContentView.swift
//  MindMosaic
//
//  Created by Gurvir Singh on 2024-10-28.
//  Student Id-991675538

import SwiftUI
import UserNotifications
import FirebaseFirestore

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = GratitudeEntryViewModel()
    @State private var showAlert = false

    var body: some View {
        TabView {
            // Gratitude Entry Tab
            GratitudeEntryView(viewModel: viewModel, showAlert: $showAlert)
                .tabItem {
                    Label("Gratitude", systemImage: "heart.text.square.fill")
                        .foregroundColor(.blue)
                }

            // Journal Log Tab
            JournalLogView()
                .tabItem {
                    Label("Journal Log", systemImage: "book.closed.fill")
                        .foregroundColor(.green)
                }

            // Wellness Tips Tab
            WellnessTipsView(context: viewContext)
                .tabItem {
                    Label("Wellness Tips", systemImage: "leaf.fill")
                        .foregroundColor(.teal)
                }

            // Settings Tab
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                        .foregroundColor(.gray)
                }
        }
        .onAppear {
            requestNotificationPermission()
            viewModel.fetchQuote() // Fetch the quote
        }
        .accentColor(.blue)
    }
    
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
    //notification scheduler
    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "MindMosaic Reminder"
        content.body = "Don't forget to log in and reflect on your day!"
        content.sound = .default

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

//gratitude entry
struct GratitudeEntryView: View {
    @ObservedObject var viewModel: GratitudeEntryViewModel
    @Binding var showAlert: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //display
                Text(viewModel.quoteText)
                    .font(.title3)
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color(UIColor.secondarySystemBackground)))
                    .shadow(radius: 5)
                
                if !viewModel.quoteAuthor.isEmpty {
                    Text("- \(viewModel.quoteAuthor)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Text("What are you grateful for today?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)

                // Entry fields
                TextField("First entry...", text: $viewModel.entry1)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                    .shadow(radius: 3)
                    .padding(.horizontal)
                
                TextField("Second entry...", text: $viewModel.entry2)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                    .shadow(radius: 3)
                    .padding(.horizontal)
                
                TextField("Third entry...", text: $viewModel.entry3)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                    .shadow(radius: 3)
                    .padding(.horizontal)
                
                // Submit button
                Button(action: {
                    if !viewModel.isValid() {
                        showAlert = true
                    } else {
                        viewModel.submitEntries()
                    }
                }) {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("Submit")
                            .fontWeight(.bold)
                    }
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
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
}
