//
//  WebData.swift
//  WebAppify
//
//  Created by Bennet Kampe on 13.02.24.
//

import Foundation
import SwiftUI

@Observable
class WebData {
    static let shared = WebData()
    private var _url: URL = URL(string: "https://example.com")!
    var error: Error?
    var showWebView = false
    var saveable: Bool = false
    var url: URL {
        get {
            return self._url
        }
        set {
            _url = processURL(newValue)
        }
    }
    func processURL(_ url: URL) -> URL {
        if UIApplication.shared.canOpenURL(url){return url}
        let httpsUrl = URL(string: "https://\(url.absoluteString)")!
        if UIApplication.shared.canOpenURL(httpsUrl){return httpsUrl}
        return url
    }
}

@Observable
class FaviconCache {
    static let shared = FaviconCache()
    var forURL: Dictionary<URL?, Image> = [:]
    var forName: Dictionary<String, Image> = [:]
}
