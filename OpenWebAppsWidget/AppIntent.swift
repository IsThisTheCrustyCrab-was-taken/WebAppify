//
//  AppIntent.swift
//  OpenWebAppsWidget
//
//  Created by Bennet Kampe on 14.02.24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Open in WebAppify"
    static var description = IntentDescription("Pick websites to open them in WebAppify.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}
