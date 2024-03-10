//
//  ShareViewController.swift
//  AddToWebAppify
//
//  Created by Bennet Kampe on 13.02.24.
//

import UIKit
import Social
import UniformTypeIdentifiers
import SwiftUI

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first else {
            print("issue with extensionItem or itemProvider")
            close()
            return
        }

        let urlDataType = UTType.url.identifier
        if itemProvider.hasItemConformingToTypeIdentifier(urlDataType) {
            print("item has url data type")
            itemProvider.loadItem(forTypeIdentifier: urlDataType) { (providedURL, error) in
                let url = (providedURL as! NSURL).absoluteURL!
                var urlString = url.absoluteString
                if urlString.starts(with: "https://") {urlString.removeFirst("https://".count)}
                else if urlString.starts(with: "http://") {urlString.removeFirst("http://".count)}
                let openURL = URL(string: "webappify://\(url.absoluteString)")!
                self.open(url: openURL)
                self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
            }

        } else {
            print("issue with typeIdentifier")
            close()
            return
        }

    }

    private func open(url: URL) {
        var responder: UIResponder? = self as UIResponder
        let selector = #selector(openURL(_:))

        while responder != nil {
            if responder!.responds(to: selector) && responder != self {
                responder!.perform(selector, with: url)
                return
            }
            responder = responder?.next
        }
    }

    @objc
    private func openURL(_ url: URL) {return}

    func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

}
