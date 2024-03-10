//
//  WebAppifyApp.swift
//  WebAppify
//
//  Created by Bennet Kampe on 13.02.24.
//

import SwiftUI

@main
struct WebAppifyApp: App {
    @State var openURL = false
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor var delegate:AppDelegate
    @EnvironmentObject var sceneDelegate: SceneDelegate
    @State var path = NavigationPath()
    @State var correctSiteLoaded = false
    @StateObject private var purchaseManager = PurchaseManager()
    var body: some Scene {
        WindowGroup {
            ContentView(path: $path, openURL: $openURL, correctSiteLoaded: $correctSiteLoaded)
                .onOpenURL(perform: {handleURL(url: $0)})
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.refreshPurchasedProducts()
                }
        }
    }
    func handleURL(url: URL){
        correctSiteLoaded = false
        if url.absoluteString.starts(with: "webappify://") {
            launchPrefilledAddView(url: url)
        } else {
            openURL(url: url)
        }
    }

    func openURL(url: URL){
        openURL = true
        WebData.shared.url = url
    }

    func launchPrefilledAddView(url: URL){
        var urlString = url.absoluteString
        urlString.removeFirst("webappify://".count)
        if urlString.starts(with: "open/https://") {
            urlString.removeFirst("open/https://".count)
            openURL(url: URL(string: "https://\(urlString)")!)
            return
        }
        if urlString.starts(with: "open/http://") {
            urlString.removeFirst("open/http://".count)
            openURL(url: URL(string: "http://\(urlString)")!)
            return
        }
        openURL = false
        let startIndex = urlString.startIndex
        let httpsIndex = urlString.index(startIndex, offsetBy: "https://".count)
        let httpIndex = urlString.index(startIndex, offsetBy: "http://".count)
        if urlString.starts(with: "https//"){
            urlString = urlString.replacingOccurrences(of: "https//", with: "https://", range: startIndex..<httpsIndex)
        } else if urlString.starts(with: "http//"){
            urlString = urlString.replacingOccurrences(of: "http//", with: "http://", range: startIndex..<httpIndex)
        }
        path.append(urlString)
    }

}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
      ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
      }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        handleShortcutItem(shortcutItem)
        completionHandler(true)
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let shortcutItem = connectionOptions.shortcutItem {
            handleShortcutItem(shortcutItem)
        }
    }

    func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) {
        print(shortcutItem.type)
        if shortcutItem.type == "listSites" {
            WebData.shared.showWebView = false
        }
    }
}

import AppIntents

struct OpenInWebAppifyAppIntent: ForegroundContinuableIntent {
    static var title: LocalizedStringResource = "Open in WebAppify"
    static var description = IntentDescription("open one of your added websites in WebAppify")
    static var openAppWhenRun = true
    @Parameter(title: "Website shortcut")
    var site: WebsiteEntry
    @MainActor
    func perform() async throws -> some IntentResult {
        await UIApplication.shared.open(URL(string: "webappify://open/\(site.url.absoluteString)")!)
        return .result()
    }
}
