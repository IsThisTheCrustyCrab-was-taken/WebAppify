//
//  WebsiteEntry.swift
//  WebAppify
//
//  Created by Bennet Kampe on 15.02.24.
//

import Foundation
import SwiftUI
import AppIntents
import CoreData

let entries = Array<WebsiteEntry>(rawValue: (UserDefaults(suiteName: "group.com.bk.WebAppify")!.string(forKey: "websiteEntries") ?? "[]"))!

struct WebsiteEntry: AppEntity, Identifiable, Codable, Hashable {

    var id = UUID()
    var url: URL
    var name: String
    var thumbnailURL: URL?

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "websiteEntry")

    var displayRepresentation: DisplayRepresentation {
      DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name))
    }

    static var typeDisplayName: LocalizedStringResource = "Book"

    static var defaultQuery = WebsiteQuery()
}

struct WebsiteQuery: EntityQuery {
  func entities(for identifiers: [UUID]) async throws -> [WebsiteEntry] {
    identifiers.compactMap { identifier in
        WebsiteEntry(id: UUID(), url: URL(string: "")!, name: "")
    }
  }
}


struct WebsiteEntryEntity: Identifiable, Hashable, Equatable, AppEntity {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Website-entry")
    typealias DefaultQuery = IntentWebsiteEntityQuery
    static var defaultQuery: IntentWebsiteEntityQuery = IntentWebsiteEntityQuery()

    var id: UUID

    @Property(title: "Name")
    var name: String
    @Property(title: "URL")
    var url: URL
    @Property(title: "faviconURL")
    var faviconURL: URL?

    init(id: UUID, name: String, url: URL, faviconURL: URL? = nil) {
        self.id = id
        self.name = name
        self.url = url
        self.faviconURL = faviconURL
    }

    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(title: "\(name)", subtitle: "\(url.absoluteString)")
    }

}

extension WebsiteEntryEntity {
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }

    static func ==(lhs: WebsiteEntryEntity, rhs: WebsiteEntryEntity) -> Bool {
        return lhs.id == rhs.id
    }
}

struct IntentWebsiteEntityQuery: EntityPropertyQuery {
    func entities(for identifiers: [UUID]) async throws -> [WebsiteEntryEntity] {
        return identifiers.compactMap { identifier in
            if let match = entries.first(where: { $0.id == identifier }) {
                return WebsiteEntryEntity(id: match.id, name: match.name, url: match.url, faviconURL: match.thumbnailURL)
            } else {
                return nil
            }
        }
    }

    func suggestedEntities() async throws -> [WebsiteEntryEntity] {
        return entries.map { entry in
            WebsiteEntryEntity(id: entry.id, name: entry.name, url: entry.url, faviconURL: entry.thumbnailURL)
        }
    }

    func entities(matching query: String) async throws -> [WebsiteEntryEntity] {
        let matchingEntries = entries.filter {
            return ($0.name.localizedStandardContains(query) || $0.url.absoluteString.localizedStandardContains(query))
        }

        return matchingEntries.map { entry in
            WebsiteEntryEntity(id: entry.id, name: entry.name, url: entry.url, faviconURL: entry.thumbnailURL)
        }
    }

    static var properties = EntityQueryProperties<WebsiteEntryEntity, NSPredicate> {
        Property(\WebsiteEntryEntity.$name) {
            EqualToComparator { NSPredicate(format: "name = %@", $0 as String)}
            ContainsComparator { NSPredicate(format: "name CONTAINS %@", $0 as String)}

        }
        Property(\WebsiteEntryEntity.$url) {
            EqualToComparator { NSPredicate(format: "url = %@", $0.absoluteString as String)}
        }
        Property(\WebsiteEntryEntity.$faviconURL) {
            EqualToComparator { NSPredicate(format: "faviconURL = %@", $0?.absoluteString ?? "" as String) }
        }
    }

    static var sortingOptions = SortingOptions {
        SortableBy(\WebsiteEntryEntity.$name)
        SortableBy(\WebsiteEntryEntity.$url)
    }

    func entities(matching comparators: [NSPredicate], mode: ComparatorMode, sortedBy: [EntityQuerySort<WebsiteEntryEntity>], limit: Int?) async throws -> [WebsiteEntryEntity] {
        let predicate = NSCompoundPredicate(type: mode == .and ? .and : .or, subpredicates: comparators)
        var matching = entries
        //MARK: THIS MIGHT BREAK STUFF
        return matching.map { entry in
            WebsiteEntryEntity(id: entry.id, name: entry.name, url: entry.url, faviconURL: entry.thumbnailURL)
        }
    }
}
