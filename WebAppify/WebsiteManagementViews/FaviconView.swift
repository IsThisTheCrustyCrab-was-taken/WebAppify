//
//  FaviconView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 17.02.24.
//

import SwiftUI

struct FaviconView: View {
    @Binding var thumbnailURL: URL?
    @State var siteName: String
    var body: some View {
        if let thumbnailURL = thumbnailURL{
            AsyncImage(url: thumbnailURL) { image in
                image
                    .resizable()
                    .padding(5)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.regularMaterial)
                    }
            } placeholder: {
                ProgressView()
            }

        } else {
            let letter = siteName.first?.lowercased() ?? "questionmark"
            Image(systemName: "\(letter).square.fill")
                .resizable()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.primary, .fill)
                .font(.system(size: 144))
        }
    }
}

#Preview {
    FaviconView(thumbnailURL: Binding.constant(nil), siteName: "Example")
        .frame(width: 160, height: 160)
}
