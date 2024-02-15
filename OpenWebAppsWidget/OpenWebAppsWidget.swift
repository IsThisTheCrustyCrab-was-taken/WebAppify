//
//  OpenWebAppsWidget.swift
//  OpenWebAppsWidget
//
//  Created by Bennet Kampe on 14.02.24.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct OpenWebAppsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Link("example", destination: URL(string: "webappify://connect.prusa.com")!)
    }

}

struct OpenWebAppsWidget: Widget {
    let kind: String = "OpenWebAppsWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            OpenWebAppsWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

struct DemoAppIntent: AppIntent {
    static var title: LocalizedStringResource = "title"
    static var description = IntentDescription("description")
    func perform() async throws -> some IntentResult {
        let _ = print("intent")
        return .result()
    }
}



#Preview(as: .systemSmall) {
    OpenWebAppsWidget()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}
