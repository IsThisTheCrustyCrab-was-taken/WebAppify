//
//  AppIntent.swift
//  OpenWebAppsWidget
//
//  Created by Bennet Kampe on 14.02.24.
//

import WidgetKit
import AppIntents
import SwiftUI





struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Open in WebAppify"
    static var description = IntentDescription("Pick websites to open them in WebAppify.")
    @Parameter(title: "Website shortcuts", size: 4)
    var sites: [WebsiteEntry]?
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

