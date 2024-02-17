//
//  NetworkImage.swift
//  WebAppify
//
//  Created by Bennet Kampe on 15.02.24.
//

import SwiftUI

struct NetworkImage: View {
    let url: URL?

    var body: some View {
        Group {
            if let url = url, let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            else
            {Image(systemName: "questionmark")}
        }
    }
}

#Preview {
    NetworkImage(url: URL(string: "https://google.com/favicon.ico")!)
}
