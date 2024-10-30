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
        request.predicate = NSPredicate(format: "saved == NO") // Fetch only unsaved tips

        do {
            tips = try viewContext.fetch(request)
            if tips.isEmpty { addInitialTips() } // If no unsaved tips, populate initial ones
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
        tip.saved.toggle() // Toggle saved status
        saveContext()
        fetchSavedTips() // Refresh saved tips list
        fetchTips()      // Refresh unsaved tips list
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
            newTip.saved = false // Default saved state
            newTip.id = UUID() // Unique ID for each tip
        }
        
        saveContext()
        fetchTips() // Refresh after saving
    }
    
    // Refresh only unsaved tips and preserve saved tips
    func refreshTips() {
        let unsavedTips = tips.filter { !$0.saved }
        unsavedTips.forEach { viewContext.delete($0) } // Delete only unsaved tips
        addInitialTips()   // Re-add initial unsaved tips
        fetchTips()        // Refresh unsaved tips list
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
