import SwiftUI
import CoreData

struct WellnessTipsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: WellnessTipsViewModel
    @State private var showSavedTipsOverlay = false

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: WellnessTipsViewModel(context: context))
    }

    var body: some View {
        VStack {
            Text("Wellness Tips")
                .font(.largeTitle)
                .padding(.top)
            
            List(viewModel.tips.prefix(10), id: \.self) { tip in
                HStack {
                    Text(tip.name ?? "Unknown Tip")
                    Spacer()
                    Button(action: { viewModel.toggleSave(for: tip) }) {
                        Image(systemName: tip.saved ? "star.fill" : "star")
                            .foregroundColor(tip.saved ? .yellow : .gray)
                    }
                }
            }
            
            Button(action: {
                showSavedTipsOverlay = true
            }) {
                Text("View Saved Tips")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $showSavedTipsOverlay) {
                SavedTipsOverlay(savedTips: viewModel.savedTips)
            }
            
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
            viewModel.fetchSavedTips()
        }
    }
}

// Saved Tips Overlay View
struct SavedTipsOverlay: View {
    var savedTips: [WellnessTip]

    var body: some View {
        VStack {
            Text("Saved Tips")
                .font(.headline)
                .padding()

            List(savedTips, id: \.self) { tip in
                Text(tip.name ?? "Unknown Tip")
            }
            .padding()
        }
    }
}

#Preview {
    WellnessTipsView(context: PersistenceController.preview.container.viewContext)
}
