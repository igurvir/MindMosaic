![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![iOS](https://img.shields.io/badge/iOS-16.0%2B-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-Firestore-yellow.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

# MindMosaic  
MindMosaic is a Swift-based iOS application designed to help users cultivate mindfulness, gratitude, and personal growth. Through a sleek, Apple-like UI, the app encourages daily reflection, tracks progress, and motivates users with inspirational quotes and wellness tips.

---

## Table of Contents  
1. [Features](#features)  
2. [Tech Stack](#tech-stack)  
3. [Firebase Setup](#firebase-setup)  
4. [ZenQuotes API](#zenquotes-api)  
5. [Widget Integration](#widget-integration)  
6. [How to Run](#how-to-run)  
7. [Connect with Me](#connect-with-me)  
8. [License](#license)

---

## Features  

### Journal Entry  
<img src="https://github.com/igurvir/MindMosaic/blob/main/screenshots/home_screen.jpeg" alt="Home Screen" width="300">

- Submit up to three or more gratitude entries daily.

- Entries are validated for uniqueness, length, and non-emptiness.
  
### Inspirational Quotes  


- Displays random motivational quotes fetched from the ZenQuotes API.
  
- Refreshes dynamically on each app launch.

### Journal Log

<img src="https://github.com/igurvir/MindMosaic/blob/main/screenshots/logs.jpeg" alt="Home Screen" width="300">

- View past entries organized by date, synced in real-time with Firestore.



### Wellness Tips  
<img src="https://github.com/igurvir/MindMosaic/blob/main/screenshots/wellness_tips.jpeg" alt="Home Screen" width="300">

- Offers a curated list of 100 wellness tips.
- Save favorite tips for future reference.  
- Tips are stored locally for offline access

### Streak Tracking  
<img src="https://github.com/igurvir/MindMosaic/blob/main/screenshots/settings.jpeg" alt="Home Screen" width="300">

- Tracks consecutive days of gratitude entries.

- Displays current streak and total entries in the settings page.



### Notifications  
<img src="https://github.com/igurvir/MindMosaic/blob/main/screenshots/notification.jpeg" alt="Home Screen" width="300">

- Sends daily reminders to encourage journaling.
- Provides a success notification after an entry is saved.

### Widget Integration 
<img src="https://github.com/igurvir/MindMosaic/blob/main/screenshots/widget.jpeg" alt="Home Screen" width="300">

- A home screen widget displays the latest gratitude entry.
  
- Prompts users to open the app for adding new entries.
  
- Dynamically syncs data via App Groups.

### Real-Time Syncing  
- Entries are stored in Firestore for real-time updates across sessions.

### Adaptive Design  
- Fully supports light and dark modes.
- Clean, Apple-like aesthetic with intuitive navigation.

---

## Tech Stack  

- **Swift (SwiftUI)**: Leveraging SwiftUI for the app’s modern and elegant UI.  
- **Firebase Firestore**: Stores gratitude entries in the cloud.
- **CoreData**: Stores wellness tips locally using core data model.  
- **ZenQuotes API**: Fetches motivational quotes.  
- **UserNotifications**: Handles daily reminders and success notifications.  
- **WidgetKit**: Enables home screen widget functionality.  
- **App Groups**: Syncs data between the app and the widget.

---

## Firebase Setup  

1. Set up Firebase for iOS and download the `GoogleService-Info.plist` file.  
2. Add the plist to your Xcode project.  
3. Enable Firestore in Firebase Console for real-time syncing.

---

## ZenQuotes API  

- Sign up at [ZenQuotes API](https://zenquotes.io/) to fetch random motivational quotes.  
- Replace API credentials in the code if needed.

---

## Widget Integration  

### Features:
- Displays the most recent gratitude entry with a prompt to add more.
- Dynamically syncs data from the app using App Groups.  

To enable the widget:
1. Add the App Group **`group.com.MindMosaic`** in your project settings for both the app and widget targets.  
2. The widget updates hourly or upon user interaction.

---

## How to Run  

1. Clone the repository:  
   ```bash  
   git clone https://github.com/igurvir/MindMosaic.git
2. Open the project in Xcode.
   
3. Ensure your system is running iOS 16.0+ with Swift 5.0 support.

4. Run the app on a simulator or a physical device.

## Connect with Me  

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://www.linkedin.com/in/gurvir-singh5/)


---

## License  

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

