Project Overview

Introduction
MindMosaic is a mobile application designed to promote mental well-being through the practice of daily gratitude journaling. The purpose of this app is to help users build a habit of mindfulness by encouraging them to reflect on positive aspects of their life and express gratitude regularly. By doing so, users can cultivate a sense of mindfulness leading to improved mental clarity and emotional well-being over time.

Target Audience
The app is aimed at individuals seeking to improve their mental health and well-being through daily mindfulness practices. People who are interested in self-reflection, personal growth and developing a consistent gratitude practice. Whether used by busy professionals, students, or anyone looking to foster a more positive outlook on life, MindMosaic is designed to be simple, intuitive and flexible to fit into a variety of lifestyles.

Important Features
MindMosaic offers several key features aimed at promoting gratitude and well-being:
•	Daily Gratitude Logging: Users can enter three things they are grateful for each day, with validation to ensure meaningful input. Multiple submissions a day is also allowed.
•	Push Notifications: Daily reminders to prompt users to log their gratitude entries, reinforcing positive habit formation.
•	Motivational Quotes: Integrated with the ZenQuotes API, the app displays a daily motivational quote related to mindfulness and well-being.
•	Wellness Tips: A collection of wellness tips is provided, randomly refreshed each time the user opens the tips page/ app. Refresh button can be used to refresh the tips if user wants and a star button to save any tip they like.
•	Streak and Entry Tracking: The app tracks how many consecutive days the user has logged entries.
•	Dark Mode: Users can toggle between light and dark themes, providing personalized and visually appealing interface.

Services and Functionalities Provided
MindMosaic provides several valuable services to users:
•	Real-time Data Storage: Gratitude entries are stored in Cloud Firestore.
•	Daily Motivational Support: The app provides inspiration through quotes fetched from the ZenQuotes API, helping users stay motivated in their mindfulness journey.
•	Wellness Enhancement: The app’s wellness tips serve as helpful suggestions for users looking to improve through mental and emotional health.
•	Tracking Progress: The app allows users to monitor their streak of daily gratitude entries, encouraging consistency and helping users build long-term positive habits.



Development Environment
MindMosaic is being developed using Swift and SwiftUI for iOS, ensuring modern and responsive UI components. The app utilizes Firebase as the backend to store user entries.
Push notifications are implemented using UserNotifcations framework to remind users to log their entries daily. For third-party API integration, the app uses ZenQuotes API to dynamically fetch and display motivational quotes. 
The app is designed following the MVC model (Model-View-Controller) architecture, ensuring clean and separation of concerns, maintainability, and scalability. The development environment includes the following-
•	Xcode IDE: for writing, testing, debugging
•	Firebase Console: for managing Firestore database and push notification services.
•	ZenQuotes API: for fetching motivational quotes in real time
•	Core Data: for managing tips stored locally within the application

With these technologies, MindMosaic offers a feature-rich experience that promotes positive mindset and mental well-being.







User Interface Wireframes

Main View 


This is the primary interface where users can log their daily entries. The screen prompts the user and offers three input fields for different entries. Multiple submissions per day is allowed.
After filling, the user submits which stores their entries in Firestore and triggers a submission notification. Additionally, the bottom part of the screen displays a randomly fetched motivational/inspirational quote from ZenQuotes API.

![image](https://github.com/user-attachments/assets/c1a6e746-a6b9-4133-b709-55e905aacb15)




 









Journal Log View


The Log allows users to revisit their past gratitude entries, which are grouped by the date of submissions. Dates with logged entries are fetched from Firestore and presented as a list. When a user selects a date, the entries for that specific day are displayed in an overlay or expanded view. This page is for viewing purposes, with no editing or deletion functionality, to support the app’s focus on reflection!



 
![image](https://github.com/user-attachments/assets/8f99e4a1-4b8c-4871-beea-41b66875006e)












Wellness Tips View

In the Wellness Tips section, users can access a list of randomly generated wellness tips from a JSON file stored in Core Data. This is designed to promote mindfulness and personal well-being. The content refreshes every time the user accesses this page. This view is simple and provides value through actionable suggestions, with no user input required.


 


![image](https://github.com/user-attachments/assets/28fc703e-bbcf-42e1-ab2c-dd448ddc7dff)












Settings View


The Settings page allows user to manage app preferences and view their journaling statistics. Users can toggle dark mode for a personalized theme, view their total gratitude entries, and check their current streak of consecutive journaling days. Links to important app information like Terms and Conditions, Privacy Policy and Contact Us are provided. All data is fetched in real time from Firestore for this page!



 


![image](https://github.com/user-attachments/assets/88376cef-5915-4498-93d2-0e04cf5e07e8)










Work Assignments

Development responsibilities for this application are UI design, business logic and data management.
Developer for this application- Gurvir Singh (991675538)

•	Presentation (UI)- Implementation of views such as Main View, Journal Log View, Wellness Tips View and Settings View. These will be designed with SwiftUI.

•	Business Logic- Developing the core logic that handles user interactions and data processing. This also includes validation checks for entries, trigger push notifications upon submissions, calculating statistics. Managing flow of data between UI and Firestore (backend database) and fetching and displaying quotes from ZenQuotes API.

•	Data- Managing and storing, retrieving user data including gratitude entries, streak tracking, and wellness tips. Firestore will be used to fetch and display entries while Core Data will be used to display Tips.

