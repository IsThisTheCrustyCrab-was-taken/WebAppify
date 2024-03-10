//
//  ContentView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 21.02.24.
//

import SwiftUI
import RevenueCat

struct ContentView: View {
    @Binding var path: NavigationPath
    @Binding var openURL: Bool
    @Binding var correctSiteLoaded: Bool
    @EnvironmentObject var sceneDelegate: SceneDelegate
    var body: some View {
        ListWebsitesView(path: $path)
            .fullScreenCover(isPresented: $openURL, content: {
                WebsiteView(loaded: $correctSiteLoaded)
            })
            .onChange(of: WebData.shared.showWebView) { _, newValue in
                if openURL == newValue {return}
                openURL = newValue
            }
            .onChange(of: openURL) { _, newValue in
                if WebData.shared.showWebView == newValue {return}
                WebData.shared.showWebView = newValue
            }
    }
}

#Preview {
    ContentView(path: .constant(NavigationPath()), openURL: .constant(false), correctSiteLoaded: .constant(false))
}
