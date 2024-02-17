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
                print("itemProvider loaded")
                if let error {
                    print("loading error \(error.localizedDescription)")
                    self.close()
                    return
                }
                if let url = providedURL as? URL {
                    DispatchQueue.main.async {
                        let text = url.absoluteString
                        let addToWebAppifyView = UIHostingController(rootView: AddToWebAppifyView(text: text))
                        self.addChild(addToWebAppifyView)
                        self.view.addSubview(addToWebAppifyView.view)

                        addToWebAppifyView.view.translatesAutoresizingMaskIntoConstraints = false
                        addToWebAppifyView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                        addToWebAppifyView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
                        addToWebAppifyView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                        addToWebAppifyView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
                    }
                } else {
                    self.close()
                    return
                }
            }

        } else {
            print("issue with typeIdentifier")
            close()
            return
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name("close"), object: nil, queue: nil) { _ in
            DispatchQueue.main.async {
                self.close()
            }
        }


    }
    func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

}
