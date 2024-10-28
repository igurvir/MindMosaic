import SwiftUI
import CoreData

struct WellnessTipsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: WellnessTip.entity(), sortDescriptors: []) var wellnessTips: FetchedResults<WellnessTip>

    var body: some View {
        VStack {
            Text("Wellness Tips")
                .font(.largeTitle)
                .padding(.top)
            
            // List of 10 random wellness tips
            List(wellnessTips.prefix(10), id: \.self) { tip in
                Text(tip.name ?? "Unknown Tip")
            }
            
            // Button to refresh tips
            Button(action: saveNewTips) {
                Text("Refresh Tips")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear(perform: checkAndAddInitialTips)
    }

    // Check and add initial tips if empty
    private func checkAndAddInitialTips() {
        if wellnessTips.isEmpty {
            saveNewTips()
        }
    }

    // Function to add predefined wellness tips to Core Data
    private func saveNewTips() {
        let tips = [
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

        // Clear current tips and add new ones
        wellnessTips.forEach { viewContext.delete($0) }
        tips.forEach { tipText in
            let newTip = WellnessTip(context: viewContext)
            newTip.name = tipText
        }

        // Save changes
        do {
            try viewContext.save()
        } catch {
            print("Error saving wellness tips: \(error.localizedDescription)")
        }
    }
}

#Preview {
    WellnessTipsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
