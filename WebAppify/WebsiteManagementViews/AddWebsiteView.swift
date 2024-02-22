//
//  AddWebsiteView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 17.02.24.
//

import SwiftUI
import FaviconFinder
import WidgetKit

struct AddWebsiteView: View {
    @AppStorage("websiteEntries", store: UserDefaults(suiteName: "group.com.bk.WebAppify")) var websiteEntries: [WebsiteEntry] = []
    enum FocusedFields {
        case url, name
    }
    @FocusState var focusedField: FocusedFields?
    @Binding var showSheet: Bool
    @State var urlString = ""
    @State var actualURL: URL?
    @State var siteName = ""
    @State var getSiteNameTask: Task<Void, Never>? = nil
    @State var faviconURL: URL?
    @State var getFaviconURLTask: Task<Void, Never>? = nil
    @State var validItem = false
    var favicon:NetworkImage? {
        if let faviconURL {
            return NetworkImage(url: faviconURL)
        }
        return nil
    }
    var body: some View {
        VStack{
            HStack{
                if validItem{
                    FaviconView(thumbnailURL: $faviconURL, siteName: siteName)
                        .frame(width: 80, height: 80)
                }
                VStack{
                    if validItem{
                        TextField("", text: $siteName)
                            .focused($focusedField, equals: .name)
                        Divider()
                    }
                    TextField("enter the website's url", text: $urlString)
                        .focused($focusedField, equals: .url)
                        .keyboardType(.URL)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .onAppear {
                            focusedField = .url
                        }
                        .onChange(of: urlString) { _, newValue in
                            checkValidURL(urlString: newValue)
                        }
                }

            }
            Button(action: saveAndDismiss, label: {
                Text("Add")
            })
            .disabled(!validItem)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    func checkValidURL(urlString: String){
        guard let url = URL(string: urlString) else {
            invalidateItem()
            return
        }
        if UIApplication.shared.canOpenURL(url){
            fetchDataAndAllowSave(url: url)
            return
        }
        let httpsUrl = URL(string: "https://\(url.absoluteString)")!
        if UIApplication.shared.canOpenURL(httpsUrl){
            fetchDataAndAllowSave(url: httpsUrl)
            return
        }
        invalidateItem()
    }
    func fetchDataAndAllowSave(url: URL){
        getFaviconURLTask?.cancel()
        getFaviconURLTask = Task {
            await fetchIconAndAllowSaveAsync(url:url)
        }
    }
    func fetchIconAndAllowSaveAsync(url: URL) async {
        do {
            let (_, _) = try await URLSession.shared.data(from: url)
            siteName = extractDomainName(from: url, urlString: urlString)
            withAnimation(.default){
                actualURL = url
                validItem = true
            }
        } catch {
            invalidateItem()
            return
        }
        do {
            let largestURL = try await FaviconFinder(url: url)
                .fetchFaviconURLs()
                .download()
                .largest()
                .url
                .source
            faviconURL = largestURL
        } catch {
            faviconURL = nil
            print("error fetching favicons for \(url.absoluteString)")
        }
    }
    func saveAndDismiss() {
        siteName = getUniqueName(name: siteName, existingNames: websiteEntries.map{$0.name})
        websiteEntries.insert(WebsiteEntry(url: actualURL!, name: siteName, thumbnailURL: faviconURL), at: 0)
        UserDefaults(suiteName: "group.com.bk.WebAppify")?.set(websiteEntries.rawValue, forKey: "websiteEntries")
        showSheet = false
    }
    func invalidateItem(){
        withAnimation(.default){
            actualURL = nil
            faviconURL = nil
            validItem = false
        }
    }
}

#Preview {
    AddWebsiteView(showSheet: Binding.constant(true))
}
