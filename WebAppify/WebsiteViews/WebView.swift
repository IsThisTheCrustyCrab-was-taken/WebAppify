//
//  WebView.swift
//  SptfySpacial
//
//  Created by Bennet Kampe on 12.02.24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var wkWebView: WKWebView
    

    func makeUIView(context: Context) -> WKWebView {
        self.wkWebView.navigationDelegate = context.coordinator
        self.wkWebView.allowsBackForwardNavigationGestures = true
        self.wkWebView.allowsLinkPreview = true

        return wkWebView
    }

    func updateUIView(_ wkWebView: WKWebView, context: Context) {

    }

    init() {
        self.wkWebView = WKWebView(frame: .zero)
    }

    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }

    func loadURL(_ url:URL) async {
        await wkWebView.load(URLRequest(url: url))
    }

    class WebViewCoordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            WebData.shared.error = nil
            decisionHandler(.allow)
        }
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
            
        }
    }
}
