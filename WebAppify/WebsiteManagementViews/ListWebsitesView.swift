//
//  ListWebsitesView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 15.02.24.
//

import SwiftUI
import FaviconFinder
import SwiftSoup

struct ListWebsitesView: View {
    @AppStorage("websiteEntries", store: UserDefaults(suiteName: "group.com.bk.WebAppify")) var websiteEntries: [WebsiteEntry] = []
    @State private var showAddSheet = false
    var body: some View {
        NavigationStack {
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
                let _ = print(element)
                EditWebsiteView(
                    element: $websiteEntries.first(where: { el in
                        el.id == element.id
                    })!
                )
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
    ListWebsitesView()
}
