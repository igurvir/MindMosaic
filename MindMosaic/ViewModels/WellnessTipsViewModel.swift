import Foundation
import CoreData
import SwiftUI

class WellnessTipsViewModel: ObservableObject {
    @Published var tips: [WellnessTip] = []
    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchTips()
    }
    
    // Fetch wellness tips from Core Data
    func fetchTips() {
        let request: NSFetchRequest<WellnessTip> = WellnessTip.fetchRequest()
        do {
            tips = try viewContext.fetch(request)
            if tips.isEmpty { addInitialTips() } // If no tips, populate initial ones
        } catch {
            print("Error fetching wellness tips: \(error)")
        }
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
            "Read a book you enjoy."
        ]
        
        initialTips.forEach { tipText in
            let newTip = WellnessTip(context: viewContext)
            newTip.name = tipText
        }
        
        saveContext()
        fetchTips() // Refresh after saving
    }
    
    // Refresh wellness tips with new entries
    func refreshTips() {
        tips.forEach { viewContext.delete($0) }
        addInitialTips()
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
