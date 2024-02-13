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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    let cutUrl = String(url.absoluteString.dropFirst("webappify://".count))
                    WebData.shared.url = URL(string: cutUrl)!
                })
        }
    }
}
