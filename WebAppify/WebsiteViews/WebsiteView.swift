//
//  ContentView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 13.02.24.
//

import SwiftUI
struct WebsiteView: View {
    @State var webView: WebView = WebView()
    
    var body: some View {
        webView
            .onAppear{
                webView.loadURL(WebData.shared.url)
            }
            .onChange(of: WebData.shared.url) { _, newValue in
                webView.loadURL(newValue)
            }
            .ignoresSafeArea(.all)
    }
}

#Preview {
    WebsiteView()
}
