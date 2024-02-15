//
//  ContentView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 13.02.24.
//

import SwiftUI
struct ContentView: View {
    @State var webView: WebView = WebView()
    
    var body: some View {
        webView
            .ignoresSafeArea(.all)
            .onAppear{
                webView.loadURL(WebData.shared.url)
            }
            .onChange(of: WebData.shared.url) { _, newValue in
                webView.loadURL(newValue)
            }
    }
}

#Preview {
    ContentView()
}
