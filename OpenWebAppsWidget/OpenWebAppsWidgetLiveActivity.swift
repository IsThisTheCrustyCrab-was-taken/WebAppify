//
//  OpenWebAppsWidgetLiveActivity.swift
//  OpenWebAppsWidget
//
//  Created by Bennet Kampe on 14.02.24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct OpenWebAppsWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct OpenWebAppsWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OpenWebAppsWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension OpenWebAppsWidgetAttributes {
    fileprivate static var preview: OpenWebAppsWidgetAttributes {
        OpenWebAppsWidgetAttributes(name: "World")
    }
}

extension OpenWebAppsWidgetAttributes.ContentState {
    fileprivate static var smiley: OpenWebAppsWidgetAttributes.ContentState {
        OpenWebAppsWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: OpenWebAppsWidgetAttributes.ContentState {
         OpenWebAppsWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: OpenWebAppsWidgetAttributes.preview) {
   OpenWebAppsWidgetLiveActivity()
} contentStates: {
    OpenWebAppsWidgetAttributes.ContentState.smiley
    OpenWebAppsWidgetAttributes.ContentState.starEyes
}
