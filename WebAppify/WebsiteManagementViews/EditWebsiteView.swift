//
//  EditWebsiteView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 17.02.24.
//

import SwiftUI
import FaviconFinder

struct EditWebsiteView: View {
    @Binding var element: WebsiteEntry
    @State var urlString = ""
    var body: some View {
        List{
            VStack{
                HStack{
                    FaviconView(thumbnailURL: $element.thumbnailURL, siteName: element.name)
                        .frame(width: 80, height: 80)
                    VStack{
                        TextField("Name", text: $element.name)
                        Divider()
                        TextField("url", text: $urlString)
                            .keyboardType(.URL)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                    }
                    .onAppear{
                        urlString = element.url.absoluteString
                    }

                }
            }
        }
        .onDisappear {
            Task{
                var url:URL?
                var faviconURL:URL?
                do {
                    guard let tryUrl = URL(string: urlString) else {return}
                    let (_,_) = try await URLSession.shared.data(from: tryUrl)
                    url = tryUrl
                } catch {
                    do {
                        guard let httpsUrl = URL(string: "https://\(urlString)") else {return}
                        let (_,_) = try await URLSession.shared.data(from: httpsUrl)
                        url = httpsUrl
                    } catch {
                        return
                    }
                }
                do {
                    let largestURL = try await FaviconFinder(url: url!)
                        .fetchFaviconURLs()
                        .download()
                        .largest()
                        .url
                        .source
                    faviconURL = largestURL
                } catch {
                    faviconURL = nil
                    print("error fetching favicons for \(url!.absoluteString)")
                }
                DispatchQueue.main.async {
                    element.url = url!
                    element.thumbnailURL = faviconURL
                }
            }
        }

    }
}
#Preview {
    EditWebsiteView(element: Binding.constant(WebsiteEntry(url: URL(string: "https://www.example.com")!, name: "Example")))
}
