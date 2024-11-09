import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), latestEntry: "Sample gratitude entry")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = fetchWidgetData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = fetchWidgetData()

        // Update the widget every hour
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: entry.date)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))

        completion(timeline)
    }

    private func fetchWidgetData() -> SimpleEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.com.MindMosaic")
        let latestEntry = sharedDefaults?.string(forKey: "latestGratitudeEntry") ?? "No recent entries"

        return SimpleEntry(date: Date(), latestEntry: latestEntry)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let latestEntry: String
}

struct MindMosaicWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
                Text("MindMosaic")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 2)

            Text("\"\(entry.latestEntry)\"")
                .font(.body)
                .italic()
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .minimumScaleFactor(0.7)
                .padding(.bottom, 6)
                .padding(.horizontal)
                .lineLimit(3)

            Spacer()

            Text("Tap to add more")
                .font(.footnote)
                .foregroundColor(.blue)
                .padding(.top, 6)
        }
        .padding()
        .containerBackground(.regularMaterial, for: .widget)
        .cornerRadius(12)
    }
}

struct MindMosaicWidget: Widget {
    let kind: String = "MindMosaicWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MindMosaicWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("MindMosaic")
        .description("Displays the latest gratitude entry.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct MindMosaicWidgetBundle: WidgetBundle {
    var body: some Widget {
        MindMosaicWidget()
    }
}

#Preview(as: .systemSmall) {
    MindMosaicWidget()
} timeline: {
    SimpleEntry(date: .now, latestEntry: "Sample gratitude entry for preview")
}
