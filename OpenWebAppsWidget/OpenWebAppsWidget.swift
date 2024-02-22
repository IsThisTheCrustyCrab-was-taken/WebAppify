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
        return WebsiteEntries(
            date: Date(),
            items: [            ]
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> WebsiteEntries {
        let items = WebsiteQuery().entities(for: configuration.sites?.map({$0.id}) ?? [])
        configuration.sites = items
        return WebsiteEntries(
            date: Date(),
            items: configuration.sites
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<WebsiteEntries> {
        let items = WebsiteQuery().entities(for: configuration.sites?.map({$0.id}) ?? [])
        configuration.sites = items
        return Timeline(
            entries:  [WebsiteEntries(date: Date(), items: configuration.sites)],
            policy: .atEnd)
    }
}
struct WebsiteEntries: TimelineEntry {
    let date: Date
    let items: [WebsiteEntry]?
}

struct OpenWebAppsWidgetEntryView : View {
    var entries: WebsiteEntries
    var items: [WebsiteEntry] {
        return entries.items ?? []
    }

    var body: some View {
        ZStack{
            switch items.count {
            case 1:
                OneEntryView(items)
            case 2:
                TwoEntriesView(items)
            case 3:
                ThreeEntriesView(items)
            case 4:
                FourEntriesView(items)
            default:
                VStack{
                    Text("Pick Websites").fontWeight(.bold).foregroundStyle(.primary)
                    Divider()
                    Text("Just tap and hold, then select Edit Widget and add the sites you'd like").font(.footnote)

                }.padding(-10)
            }
        }
        .unredacted()
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

        Link(destination: item.url, label: {
            ZStack{
                if let thumbnailURL = item.thumbnailURL{
                    NetworkImage(url: thumbnailURL)
                        .padding(5)
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.regularMaterial)
                        }

                } else {
                    let letter = item.name.first?.lowercased() ?? "questionmark"
                    Image(systemName: "\(letter).square.fill")
                        .resizable()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.primary, .fill)
                        .font(.system(size: 144))
                        .clipShape(.rect(cornerRadius: 10))
                }

                if item.name != ""
                {
                    Text(item.name).font(.caption)
                        .lineLimit(4)
                        .minimumScaleFactor(0.8)
                        .padding(4)
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.ultraThinMaterial)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
            }
        })
        .padding(-2)
    }
    init(_ item: WebsiteEntry) {
        self.item = item
    }
}
struct IconMedium : View {
    let item: WebsiteEntry
    var body: some View {
        Link(destination: item.url, label: {
            HStack{
                if let thumbnailURL = item.thumbnailURL{
                    NetworkImage(url: thumbnailURL)
                        .padding(5)
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.regularMaterial)
                        }

                } else {
                    let letter = item.name.first?.lowercased() ?? "questionmark"
                    Image(systemName: "\(letter).square.fill")
                        .resizable()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.primary, .fill)
                        .font(.system(size: 144))
                        .clipShape(.rect(cornerRadius: 10))
                }
                Text(item.name)
                    .lineLimit(4)
                    .minimumScaleFactor(0.6)
                    .padding(4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            }.background{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.1))
            }
        })
        .padding(-2)

    }
    init(_ item: WebsiteEntry) {
        self.item = item
    }
}
struct IconLarge : View {
    let item: WebsiteEntry
    var body: some View {
        Link(destination: item.url, label: {
            ZStack{
                if let thumbnailURL = item.thumbnailURL{
                    NetworkImage(url: thumbnailURL)
                        .padding(5)
                        .background{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.regularMaterial)
                        }
                        .padding(-10)
                } else {
                    let letter = item.name.first?.lowercased() ?? "questionmark"
                    Image(systemName: "\(letter).square.fill")
                        .resizable()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.primary, .fill)
                        .font(.system(size: 144))
                        .clipShape(.rect(cornerRadius: 15))
                        .padding(-10)
                }
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
        })

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
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall])
    }
}

extension ConfigurationAppIntent {
}





#Preview(as: .systemSmall) {
    OpenWebAppsWidget()
} timeline: {
    for i in 0...4{
        let items = [WebsiteEntry](repeating: dummyEntry(), count: i)
        WebsiteEntries(date: .now, items: items)
    }
}
