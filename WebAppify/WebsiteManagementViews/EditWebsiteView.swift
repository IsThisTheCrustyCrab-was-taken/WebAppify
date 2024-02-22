//
//  EditWebsiteView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 17.02.24.
//

import SwiftUI
import FaviconFinder
import WidgetKit

struct EditWebsiteView: View {
    enum SaveImageStates {
        case notSaved
        case saved
        case savedAgain
    }
    @AppStorage("websiteEntries", store: UserDefaults(suiteName: "group.com.bk.WebAppify")) var websiteEntries: [WebsiteEntry] = []
    @Binding var element: WebsiteEntry
    @State var urlString = ""
    @State var canSaveFaviconImage = false
    @State var saveImageState = SaveImageStates.notSaved
    @State var showSaveAgainConfirmationDialog = false
    @State var showAddToShortcutsSheet = false
    @State var saveable = false
    @State var iconLoadedState: IconLoadedStates = .notLoaded
    var saveImageText: String {
        switch saveImageState {
        case .notSaved:
            "Save Image"
        case .saved:
            "Saved!"
        case .savedAgain:
            "Saved again!"
        }
    }

    var body: some View {
        List{
            VStack{
                HStack{
                    FaviconViewProvidingImage(thumbnailURL: $element.thumbnailURL, iconLoadedState: $iconLoadedState, siteName: element.name)
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
            HStack{
                Button(action: {
                    Task{
                        switch(saveImageState){
                        case .notSaved:
                            await saveImage()
                            withAnimation(.spring){
                                saveImageState = .saved
                            }
                        default:
                            showSaveAgainConfirmationDialog = true
                        }
                    }
                }, label: {
                    Text(saveImageText)
                })
                .disabled(iconLoadedState == .notLoaded)
                .confirmationDialog("Are you sure you want to save the icon again?", isPresented: $showSaveAgainConfirmationDialog){
                    Button("Save Again"){
                        Task{
                            await saveImage()
                            showSaveAgainConfirmationDialog = false
                        }
                        withAnimation(.spring){
                            saveImageState = .savedAgain
                        }
                    }
                    Button("Cancel", role: .cancel){
                        showSaveAgainConfirmationDialog = false
                    }
                } message: {
                    Text("Are you sure you want to save the icon again?")
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
                    element.name = getUniqueName(name: element.name, existingNames: websiteEntries.filter({$0.id != element.id}).map({$0.name}))
                    element.url = url!
                    element.thumbnailURL = faviconURL
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }

    }
    @MainActor
    func saveImage() async {
        switch iconLoadedState {
        case .loadedURL:
            UIImageWriteToSavedPhotosAlbum(ImageRenderer(content: FaviconCache.shared.forURL[element.thumbnailURL]).uiImage!, nil, nil, nil)
        case .loadedName:
            UIImageWriteToSavedPhotosAlbum(ImageRenderer(content: 
                                                            FaviconCache.shared.forName[element.name]
                                                                .foregroundStyle(.primary, .fill)
                                                                .font(.system(size: 144))
                                                                .frame(width: 180, height: 180)
                                                        ).uiImage!, nil, nil, nil)
        default:
            _ = "how did we get here"
        }
    }
}
#Preview {
    EditWebsiteView(element: Binding.constant(WebsiteEntry(url: URL(string: "https://www.example.com")!, name: "Example")))
}
