//
//  WebsiteEntry.swift
//  WebAppify
//
//  Created by Bennet Kampe on 15.02.24.
//

import Foundation
import SwiftUI

struct WebsiteEntry: Codable, Hashable, Identifiable{
    var id = UUID()
    var url: URL
    var name: String
    var thumbnailURL: URL?
}
