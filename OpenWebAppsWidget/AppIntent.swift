//
//  AppIntent.swift
//  OpenWebAppsWidget
//
//  Created by Bennet Kampe on 14.02.24.
//

import WidgetKit
import AppIntents





struct ConfigurationAppIntent: WidgetConfigurationIntent {

    private struct EntryOptionsProvider: DynamicOptionsProvider {
        func results() async throws -> [String] {
            print("count: \(entries.count)")
            return entries.map { $0.name }
        }
    }

    static var title: LocalizedStringResource = "Open in WebAppify"
    static var description = IntentDescription("Pick websites to open them in WebAppify.")
    @Parameter(title: "First site", optionsProvider: EntryOptionsProvider()) var first: String
    @Parameter(title: "Second site", optionsProvider: EntryOptionsProvider()) var second: String
    @Parameter(title: "Third site", optionsProvider: EntryOptionsProvider()) var third: String
    

}

//struct FirstQuery: EntityStringQuery {
//    func results() async throws -> [WebsiteEntry] {
//        ["a"]
//    }
//    func entities(matching string: String) async throws -> [WebsiteEntry] {
//        entries.filter{$0.name.contains(string)}
//    }
//    func entities(for identifiers: [WebsiteEntry.ID]) async throws -> [WebsiteEntry] {
//        entries.filter{identifiers.contains($0.id)}
//    }
//    func suggestedEntities() async throws ->  [WebsiteEntry]{
//        return entries
//    }
//}

