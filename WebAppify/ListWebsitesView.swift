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
    @AppStorage("websiteEntries") var websiteEntries: [WebsiteEntry] = []
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

    func refreshWithDummyItems(){
        var entries = [WebsiteEntry]()
        for i in 0..<40 {
            let url = URL(string: "https://google.com")!
            let faviconURL:URL? = nil

            entries.append(WebsiteEntry(url: url, name: "Google \(i)", thumbnailURL: faviconURL))
        }
        websiteEntries = entries
    }
}

struct AddWebsiteView: View {
    @AppStorage("websiteEntries") var websiteEntries: [WebsiteEntry] = []
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
            siteName = extractDomainName(from: url)
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
        websiteEntries.insert(WebsiteEntry(url: actualURL!, name: siteName, thumbnailURL: faviconURL), at: 0)
        showSheet = false
    }
    func invalidateItem(){
        withAnimation(.default){
            actualURL = nil
            faviconURL = nil
            validItem = false
        }
    }
    func extractDomainName(from url: URL) -> String {
        guard let host = url.host else {
            return urlString
        }
        let name = host.components(separatedBy: ".").first?.capitalized
        return name ?? host
    }
}


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
                print("disappearing")
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
    ListWebsitesView()
}
