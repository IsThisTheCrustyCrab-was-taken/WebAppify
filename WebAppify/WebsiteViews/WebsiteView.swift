//
//  ContentView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 13.02.24.
//

import SwiftUI
struct WebsiteView: View {
    @State var webView: WebView?
    @Binding var loaded: Bool
    var showError: Binding<Bool> {
        return .constant(WebData.shared.error != nil)
    }

    var body: some View {
        if loaded{
            if let webView = webView
            {
                webView
                .background(ignoresSafeAreaEdges: .bottom)
                .ignoresSafeArea(edges: .bottom)
                .task{
                    await webView.loadURL(WebData.shared.url)
                    loaded = true
                }
                .onChange(of: WebData.shared.url) { _, newValue in
                    Task {
                        loaded = false
                        await webView.loadURL(newValue)
                        loaded = true
                    }
                }
                .fullScreenCover(isPresented: .constant(false), content: {
                    VStack{
                        Text("Error loading \(webView.wkWebView.url?.absoluteString ?? "")")
                            .font(.title)
                            .padding(.bottom)
                        if let error = WebData.shared.error {
                            Text(error.localizedDescription)
                                .font(.caption)
                        } else {
                            Text("loading Error wasn't specified :/")
                                .font(.caption)
                        }
                        Button(action: {}, label: {
                            Image(systemName: "arrow.clockwise")
                                .foregroundStyle(.primary)
                        })
                    }
                })
            }
        } else {
            ProgressView("loading \(WebData.shared.url.absoluteString)")
            .background(ignoresSafeAreaEdges: .bottom)
            .ignoresSafeArea(edges: .bottom)
            .task{
                webView = WebView()
                await webView!.loadURL(WebData.shared.url)
                loaded = true
            }
            .onChange(of: WebData.shared.url) { _, newValue in
                Task {
                    guard let webView else {return}
                    await webView.loadURL(newValue)
                    loaded = true
                }
            }
        }

    }
    func loadWebView() async {

    }
}

#Preview {
    WebsiteView(loaded: .constant(false))
}
