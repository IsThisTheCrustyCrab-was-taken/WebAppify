//
//  WebAppifyApp.swift
//  WebAppify
//
//  Created by Bennet Kampe on 13.02.24.
//

import SwiftUI

@main
struct WebAppifyApp: App {
    @State var webView = WebView()
    @State var openURL = false
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            if openURL{
                ContentView()
                    .onOpenURL(perform: { url in
                        openURL = true
                        let cutUrl = String(url.absoluteString.dropFirst("webappify://".count))
                        WebData.shared.url = URL(string: cutUrl)!
                    })
            } else {
                ListWebsitesView()
                    .onOpenURL(perform: { url in
                        openURL = true
                        let cutUrl = String(url.absoluteString.dropFirst("webappify://".count))
                        WebData.shared.url = URL(string: cutUrl)!
                    })
            }
            //TODO: ADD ACTION PRESS AND HOLD APP ICON TO GET TO LIST VIEW
        }
    }
}
