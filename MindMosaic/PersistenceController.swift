import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // Add the preview configuration for SwiftUI Previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        
        // Populate with sample data if needed for previews
        let viewContext = controller.container.viewContext
        for index in 0..<10 {
            let tip = WellnessTip(context: viewContext)
            tip.name = "Sample Tip \(index + 1)"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MindMosaicModel") // Replace with your actual .xcdatamodeld file name
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
