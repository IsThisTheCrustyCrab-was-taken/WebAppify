//
//  PreferencesView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 22.02.24.
//

import SwiftUI
import StoreKit

struct MainPreferencesView: View {
    @State var showDeleteAllConfirmation = false
    @State var showDeletedAllAlert = false
    @AppStorage("websiteEntries", store: UserDefaults(suiteName: "group.com.bk.WebAppify")) var websiteEntries: [WebsiteEntry] = []
    var body: some View {
            List{
                Section("Settings ⚙️"){
                    Button(role: .destructive, action: {
                        showDeleteAllConfirmation.toggle()
                    }, label: {
                        Text("Delete all saved sites")
                    })
                    .confirmationDialog("Delete all?", isPresented: $showDeleteAllConfirmation) {
                        Button("YES, DELETE EVERYTHING", role: .destructive){
                            websiteEntries = []
                            showDeletedAllAlert.toggle()
                        }
                        Button("Cancel", role: .cancel){showDeleteAllConfirmation.toggle()}
                    } message: {
                        Text("Are you sure?")
                    }
                    .alert("Removed all saved sites", isPresented: $showDeletedAllAlert){
                        Button("OK", role: .cancel){showDeletedAllAlert.toggle()}
                    }


                }
                Section("Donations & Unlocks \(StoreItems.shared.purchasedProductIDs.isEmpty ? "🔒" : "🔓")"){
                    VStack{
                        NavigationLink {
                            PurchaseOptionsView()
                        } label: {
                            VStack{
                                Text("Buy me a coffee ☕️")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                let unlockCaption = StoreItems.shared.purchasedProductIDs.isEmpty ?
                                "and unlock unlimited saved sites ✨" :
                                "you've already unlocked unlimited saves, but I always appreciate more money being thrown my way 😋"
                                Text(unlockCaption)
                                    .font(.caption2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    Button(action: {
                        Task {
                                do {
                                    try await AppStore.sync()
                                } catch {
                                    print(error)
                                }
                            }
                    }, label: {
                        Text("Restore purchases 🔄")
                    })
                }
                Section("About ℹ️"){
                    Text("Terms of use")
                    Text("Privacy Policy")
                    Text("FAQ")
                    Text("Licenses")
                }

                Section("Thanks for teaching me how to do this 🙏"){
                    Link("Paul Hudson", destination: URL(string: "https://hackingwithswift.com")!)
                    Link("Sean Allen", destination: URL(string: "https://seanallen.teachable.com")!)
                    Link("tundsdev", destination: URL(string: "https://tunds.dev")!)
                }
            }
            .navigationTitle("Preferences")
    }
}

#Preview {
    NavigationStack{
        MainPreferencesView()
    }
}
