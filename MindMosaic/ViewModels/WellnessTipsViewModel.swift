//  Created by Gurvir Singh on 2024-10-28.
//  Student Id-991675538

import Foundation
import CoreData
import SwiftUI

class WellnessTipsViewModel: ObservableObject {
    @Published var tips: [WellnessTip] = []         // All unsaved wellness tips
    @Published var savedTips: [WellnessTip] = []     // Only saved tips
    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchTips()        // Fetch unsaved tips
        fetchSavedTips()   // Fetch saved tips
    }
    
    // Fetch all unsaved wellness tips from Core Data
    func fetchTips() {
        let request: NSFetchRequest<WellnessTip> = WellnessTip.fetchRequest()
        request.predicate = NSPredicate(format: "saved == NO")

        do {
            tips = try viewContext.fetch(request)
            if tips.isEmpty { addInitialTips() }
        } catch {
            print("Error fetching wellness tips: \(error)")
        }
    }

    // Fetch only saved tips from Core Data
    func fetchSavedTips() {
        let request: NSFetchRequest<WellnessTip> = WellnessTip.fetchRequest()
        request.predicate = NSPredicate(format: "saved == YES") // Only saved tips
        do {
            savedTips = try viewContext.fetch(request)
        } catch {
            print("Error fetching saved wellness tips: \(error)")
        }
    }
    
    // Toggle the saved state of a wellness tip
    func toggleSave(for tip: WellnessTip) {
        tip.saved.toggle()
        saveContext()
        fetchSavedTips() // Refresh saved tips list
        fetchTips()
    }

    // Populate Core Data with initial wellness tips
    private func addInitialTips() {
        let initialTips = [
            "Take a deep breath and relax.",
            "Spend time in nature.",
            "Stay hydrated.",
            "Get a good night's sleep.",
            "Practice gratitude daily.",
            "Take breaks from screen time.",
            "Eat a balanced diet.",
            "Exercise regularly.",
            "Connect with friends or family.",
            "Read a book you enjoy.",
            "Listen to calming music.",
            "Stretch for 5-10 minutes.",
            "Write down three things you're thankful for.",
            "Try a new hobby or activity.",
            "Meditate for at least 10 minutes.",
            "Declutter your workspace or room.",
            "Take a walk and enjoy the fresh air.",
            "Drink herbal tea to relax.",
            "Smile, even if you're feeling low.",
            "Set small, achievable goals for the day.",
            "Limit your social media usage.",
            "Focus on deep, intentional breathing.",
            "Engage in a creative activity like drawing or crafting.",
            "Take a moment to enjoy a favorite snack.",
            "Practice positive affirmations.",
            "Organize your thoughts in a journal.",
            "Learn something new, like a fun fact or skill.",
            "Watch a funny video or show.",
            "Compliment someone genuinely.",
            "Try progressive muscle relaxation.",
            "Plan a short-term goal and visualize achieving it.",
            "Reduce caffeine intake after midday.",
            "Take a moment to appreciate a small detail around you.",
            "Do something kind for someone else.",
            "Avoid multitasking for a more mindful experience.",
            "Focus on the present moment.",
            "Write a letter to your future self.",
            "Spend time with a pet or an animal.",
            "Practice a random act of kindness.",
            "Create a playlist of your favorite songs.",
            "Enjoy a tech-free hour.",
            "Light a candle or use an essential oil diffuser.",
            "Spend time with a loved one without distractions.",
            "Reflect on your accomplishments, big or small.",
            "Take a power nap if you're feeling tired.",
            "Visualize a peaceful scene or memory.",
            "Do a quick workout or some jumping jacks.",
            "Look at old photos that make you smile.",
            "Plan a day trip or activity to look forward to.",
            "Drink water first thing in the morning.",
            "Celebrate small victories throughout the day.",
            "Break a big task into smaller, manageable parts.",
            "Practice a grounding exercise to relieve anxiety.",
            "Color in an adult coloring book or doodle.",
            "Learn a few words in a new language.",
            "Reconnect with an old friend or family member.",
            "Create a vision board for your dreams.",
            "Make a list of your favorite quotes or affirmations.",
            "Treat yourself to something you enjoy."
        ]
        
        initialTips.forEach { tipText in
            let newTip = WellnessTip(context: viewContext)
            newTip.name = tipText
            newTip.saved = false
            newTip.id = UUID()
        }
        
        saveContext()
        fetchTips() // Refresh after saving
    }
   
    func refreshTips() {
        let unsavedTips = tips.filter { !$0.saved }
        unsavedTips.forEach { viewContext.delete($0) } // Delete only unsaved tips
        addInitialTips()
        fetchTips()
    }

    // Save changes to Core Data
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving wellness tips: \(error)")
        }
    }
}
