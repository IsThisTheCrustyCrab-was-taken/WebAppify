//
//  ListWebsitesView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 15.02.24.
//

import SwiftUI
import FaviconFinder
import SwiftSoup
import WidgetKit

struct ListWebsitesView: View {
    @AppStorage("websiteEntries", store: UserDefaults(suiteName: "group.com.bk.WebAppify")) var websiteEntries: [WebsiteEntry] = []
    @State private var showAddSheet = false
    @Binding var path: NavigationPath
    var body: some View {
        NavigationStack(path: $path){
            List {
                ForEach(websiteEntries) {entry in
                    NavigationLink(value: entry) {
                        WebsitePreviewView(entry)
                    }
                }
                .onMove{ indexSet, offset in
                    websiteEntries.move(fromOffsets: indexSet, toOffset: offset)
                }
                .onDelete{ indexSet in
                    websiteEntries.remove(atOffsets: indexSet)
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            .toolbar{
                ToolbarItem{
                    EditButton()
                }
                ToolbarItem{
                    Button(action: {
                        showAddSheet = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .navigationDestination(for: WebsiteEntry.self) { element in
                let el = $websiteEntries.first(where: { el in
                    el.id == element.id
                })!
                EditWebsiteView(element: el)
            }
            .navigationDestination(for: String.self) { urlString in
                AddWebsiteFullscreenView(urlString: urlString, path: $path)
            }
            .navigationTitle("Saved Sites")
        }
        .sheet(isPresented: $showAddSheet){
            AddWebsiteView(showSheet: $showAddSheet)
                .presentationDetents([.fraction(0.2)])
                .presentationCornerRadius(20)
                .presentationContentInteraction(.resizes)
                .presentationBackgroundInteraction(.disabled)
        }
    }
}

#Preview {
    ListWebsitesView(path: Binding.constant(NavigationPath()))
}
