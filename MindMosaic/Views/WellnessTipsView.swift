import SwiftUI
import CoreData

struct WellnessTipsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: WellnessTipsViewModel

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: WellnessTipsViewModel(context: context))
    }

    var body: some View {
        VStack {
            Text("Wellness Tips")
                .font(.largeTitle)
                .padding(.top)
            
            // List of 10 random wellness tips
            List(viewModel.tips.prefix(10), id: \.self) { tip in
                Text(tip.name ?? "Unknown Tip")
            }
            
            // Button to refresh tips
            Button(action: viewModel.refreshTips) {
                Text("Refresh Tips")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchTips()
        }
    }
}

#Preview {
    WellnessTipsView(context: PersistenceController.preview.container.viewContext)
}
