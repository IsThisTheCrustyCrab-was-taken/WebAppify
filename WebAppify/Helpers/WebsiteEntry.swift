//
//  WebsiteEntry.swift
//  WebAppify
//
//  Created by Bennet Kampe on 15.02.24.
//

import Foundation
import SwiftUI
import AppIntents


struct WebsiteEntry: AppEntity, Identifiable, Codable, Hashable {

    var id = UUID()
    var url: URL
    var name: String
    var thumbnailURL: URL?

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "websiteEntry")

    var displayRepresentation: DisplayRepresentation {
      DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name))
    }

    static var typeDisplayName: LocalizedStringResource = "Website"

    static var defaultQuery = WebsiteQuery()
}

struct WebsiteQuery: EntityQuery {
    @AppStorage("websiteEntries", store: UserDefaults(suiteName: "group.com.bk.WebAppify")) var entries: [WebsiteEntry] = []
    func entities(for identifiers: [UUID]) -> [WebsiteEntry] {
        identifiers.compactMap { identifier in
            entries.first{$0.id == identifier}
        }
    }
    func suggestedEntities()  -> [WebsiteEntry] {
        entries
    }
}



