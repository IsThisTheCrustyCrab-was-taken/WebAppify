//
//  ActionViewController.swift
//  AddToWebAppifyAction
//
//  Created by Bennet Kampe on 13.02.24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers


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
        print(extensionItem.attachments)

        let urlDataType = UTType.url.identifier
        if itemProvider.hasItemConformingToTypeIdentifier(urlDataType) {
            print("item has url data type")
            itemProvider.loadItem(forTypeIdentifier: urlDataType) { (providedURL, error) in
                print("itemProvider loaded")
                if let error {
                    print("loading error")
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


//class ActionViewController: UIViewController {
//
//    @IBOutlet weak var imageView: UIImageView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    
//        // Get the item[s] we're handling from the extension context.
//        
//        // For example, look for an image and place it into an image view.
//        // Replace this with something appropriate for the type[s] your extension supports.
//        var imageFound = false
//        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
//            for provider in item.attachments! {
//                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
//                    // This is an image. We'll load it, then place it in our image view.
//                    weak var weakImageView = self.imageView
//                    provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil, completionHandler: { (imageURL, error) in
//                        OperationQueue.main.addOperation {
//                            if let strongImageView = weakImageView {
//                                if let imageURL = imageURL as? URL {
//                                    strongImageView.image = UIImage(data: try! Data(contentsOf: imageURL))
//                                }
//                            }
//                        }
//                    })
//                    
//                    imageFound = true
//                    break
//                }
//            }
//            
//            if (imageFound) {
//                // We only handle one image, so stop looking for more.
//                break
//            }
//        }
//    }
//
//    @IBAction func done() {
//        // Return any edited content to the host app.
//        // This template doesn't do anything, so we just echo the passed in items.
//        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
//    }
//
//}
