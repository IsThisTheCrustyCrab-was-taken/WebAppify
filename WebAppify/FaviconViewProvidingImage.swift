//
//  FaviconViewProvidingImage.swift
//  WebAppify
//
//  Created by Bennet Kampe on 21.02.24.
//

import SwiftUI

enum IconLoadedStates {
    case notLoaded
    case loadedURL
    case loadedName
}

struct FaviconViewProvidingImage: View {
    @Binding var thumbnailURL: URL?
    @Binding var iconLoadedState: IconLoadedStates
    @State var siteName: String
    var body: some View {
        if let thumbnailURL = thumbnailURL{
            AsyncImage(url: thumbnailURL) { image in
                let img = image
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.regularMaterial)
                    }
                    .onAppear {
                        print("set url \(thumbnailURL)")
                        FaviconCache.shared.forURL[thumbnailURL] = image
                        iconLoadedState = .loadedURL
                    }
                return img
            } placeholder: {
                ProgressView()
            }

        } else {
            let letter = siteName.first?.lowercased() ?? "questionmark"
            let img = Image(systemName: "\(letter).square.fill")
                .resizable()
                .symbolRenderingMode(.palette)
            img
                .foregroundStyle(.primary, .fill)
                .font(.system(size: 144))
                .onAppear{
                    print("set sitename \(siteName)")
                    FaviconCache.shared.forName[siteName] = img
                    iconLoadedState = .loadedName
                }
        }
    }
}

#Preview {
    FaviconViewProvidingImage(thumbnailURL: .constant(nil), iconLoadedState: .constant(.notLoaded), siteName: "")
}
