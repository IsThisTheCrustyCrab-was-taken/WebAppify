//
//  OpenWebAppsWidget.swift
//  OpenWebAppsWidget
//
//  Created by Bennet Kampe on 14.02.24.
//

import WidgetKit
import SwiftUI
import AppIntents
import Foundation


func dummyEntry() -> WebsiteEntry {
    return WebsiteEntry(url: URL(string: "https://google.com")!, name: "example")
}


struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> WebsiteEntries {
        WebsiteEntries(
            date: Date(),
            items: [
                dummyEntry()
            ]
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> WebsiteEntries {
        WebsiteEntries(
            date: Date(),
            items: [dummyEntry(),dummyEntry(),dummyEntry()]
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<WebsiteEntries> {
        let entries: [WebsiteEntries] = [WebsiteEntries(date: Date(), items: [dummyEntry(),dummyEntry(),dummyEntry()])]
        return Timeline(entries: entries, policy: .atEnd)
    }
}
struct WebsiteEntries: TimelineEntry {
    let date: Date
    let items: [WebsiteEntry]
}

struct OpenWebAppsWidgetEntryView : View {
    var entries: WebsiteEntries
    var items: [WebsiteEntry] {
        return entries.items
    }

    var body: some View {
        ZStack{
            switch entries.items.count {
            case 1:
                OneEntryView(items)
            case 2:
                TwoEntriesView(items)
            case 3:
                ThreeEntriesView(items)
            case 4:
                FourEntriesView(items)
            default:
                Text("Pick Websites to display here")
            }
        }
    }
}

struct OneEntryView : View {
    var items: [WebsiteEntry]
    var body: some View {
        IconLarge(items[0])
    }
    init(_ items: [WebsiteEntry]) {
        self.items = items
    }
}

struct TwoEntriesView : View {
    var items: [WebsiteEntry]
    var body: some View {
        Grid{
            GridRow{
                IconMedium(items[0])
            }
            GridRow{
                IconMedium(items[1])
            }
        }
    }
    init(_ items: [WebsiteEntry]) {
        self.items = items
    }
}

struct ThreeEntriesView : View {
    var items: [WebsiteEntry]
    var body: some View {
        Grid{
            GridRow{
                IconMedium(items[0])
                    .gridCellColumns(2)
            }
            GridRow{
                IconSmall(items[1])
                IconSmall(items[2])
            }
        }
    }
    init(_ items: [WebsiteEntry]) {
        self.items = items
    }
}

struct FourEntriesView : View {
    var items: [WebsiteEntry]
    var body: some View {
        Grid{
            GridRow{
                IconSmall(items[0])
                IconSmall(items[1])
            }
            GridRow{
                IconSmall(items[2])
                IconSmall(items[3])
            }
        }
    }
    init(_ items: [WebsiteEntry]) {
        self.items = items
    }
}

struct NetworkImage: View {
    let url: URL?

    var body: some View {
        Group {
            if let url = url, let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            else
            {Image(systemName: "questionmark")}
        }
    }
}


struct IconSmall : View {
    let item: WebsiteEntry
    var body: some View {
        ZStack{
            NetworkImage(url: URL(string: "https://www.google.com/favicon.ico"))
                .padding(5)
                .background{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.regularMaterial)
                }
                .scaledToFit()
                .padding(-2)
            if item.name != ""
            {
                Text(item.name).font(.caption)
                    .lineLimit(4)
                    .minimumScaleFactor(0.8)
                    .padding(4)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.thinMaterial)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }

        }
        .widgetURL(URL(string: "webappify://www.google.com")!)
    }
    init(_ item: WebsiteEntry) {
        self.item = item
    }
}
struct IconMedium : View {
    let item: WebsiteEntry
    var body: some View {
        HStack{
            Image(systemName: "globe")
                .resizable()
                .padding(5)
                .background{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.regularMaterial)
                }
                .scaledToFit()
                .padding(-2)
            Text(item.name)
                .lineLimit(4)
                .minimumScaleFactor(0.6)
                .padding(4)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

        }.background{
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .padding(-2)
        }
    }
    init(_ item: WebsiteEntry) {
        self.item = item
    }
}
struct IconLarge : View {
    let item: WebsiteEntry
    var body: some View {
        ZStack{
            Image(systemName: "globe")
                .resizable()
                .padding(10)
                .background{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.regularMaterial)
                }
                .scaledToFit()
                .padding(-2)
            if item.name != ""
            {
                Text(item.name)
                    .lineLimit(4)
                    .minimumScaleFactor(0.8)
                    .padding(4)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.thinMaterial)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }

        }
    }
    init(_ item: WebsiteEntry) {
        self.item = item
    }
}

struct OpenWebAppsWidget: Widget {
    let kind: String = "OpenWebAppsWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            OpenWebAppsWidgetEntryView(entries: entry)
                .containerBackground(.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall])
    }
}

extension ConfigurationAppIntent {
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
    for i in 0...4{
        let items = [WebsiteEntry](repeating: dummyEntry(), count: i)
        WebsiteEntries(date: .now, items: items)
    }
}
