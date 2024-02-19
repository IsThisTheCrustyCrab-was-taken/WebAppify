//
//  WebsitePreviewView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 17.02.24.
//

import SwiftUI

struct WebsitePreviewView: View {
    let element: WebsiteEntry
    var body: some View {
        HStack{
            FaviconView(thumbnailURL: Binding.constant(element.thumbnailURL), siteName: element.name)
                .frame(width: 40, height: 40)
            VStack{
                Text(element.name != "" ? element.name : element.url.host() ?? element.url.absoluteString)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(element.url.absoluteString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }
    }
    init(_ element: WebsiteEntry) {
        self.element = element
    }
}


#Preview {
    List{
        WebsitePreviewView(WebsiteEntry(url: URL(string: "https://www.example.com")!, name: "Example"))
    }
}
