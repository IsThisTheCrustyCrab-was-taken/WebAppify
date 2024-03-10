//
//  PurchaseOptionsView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 27.02.24.
//

import SwiftUI
import StoreKit

struct PurchaseOptionsView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack{
                OptionView(
                    title: "Normal Tip",
                    message: "Buy me a coffee and get unlimited saves. win-win!",
                    icon: "☕️",
                    backgroundColor: .gray,
                    product: StoreItems.shared.normalTip
                )
                OptionView(
                    title: "Large Tip",
                    message: "Get unlimited saves and make my day!",
                    icon: "🌭",
                    backgroundColor: .orange,
                    product: StoreItems.shared.largeTip
                )
                OptionView(
                    title: "Huge Tip",
                    message: "Get unlimited saves and make my week!",
                    icon: "🍾",
                    backgroundColor: .mint,
                    product: StoreItems.shared.hugeTip
                )
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(60, for: .scrollContent)
    }
}

struct OptionView: View {
    let title: String
    let message: String
    let icon: String
    let backgroundColor: Color
    var product: Product?
    @EnvironmentObject private var purchaseManager: PurchaseManager
    var body: some View {
        VStack{
            VStack {
                Text(title)
                    .font(.system(size: 60, weight: .black, design: .rounded))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1, reservesSpace: true)
                Text(message)
                    .font(.caption.bold())
                    .lineLimit(2, reservesSpace: true)
                    Text(icon)
                        .font(.system(size: 140))
                        .minimumScaleFactor(0.8)
                        .lineLimit(1, reservesSpace: true)
                        .shadow(radius: 6, y: 8)
            }
            .padding()
            .background(backgroundColor.gradient)
            .clipShape(.rect(cornerRadius: 20))
            .shadow(radius: 4, y: 2)
            .padding(4)
            Button(action: {
                Task{
                    guard let product = product else {return}
                    do {
                        let result = try await purchaseManager.purchase(product)
                        switch result {
                        case .success(.verified(let transaction)):
                            print("Succies")
                        case .success(.unverified(_, let error)):
                            break
                        case .userCancelled:
                            break
                        case .pending:
                            break
                        case .none:
                            break
                        @unknown default:
                            break
                        }
                    } catch {

                    }
                }
            }, label: {
                if let product = product
                    {
                        Text("Buy for \(product.displayPrice)")
                    }
                else
                {
                    Text("Error when getting product price")
                }
            })
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .font(.system(.title, design: .rounded).weight(.heavy))
            .padding(.horizontal)
            .buttonStyle(.borderedProminent)
            .clipShape(.rect(cornerRadius: 20))
            .shadow(radius: 4, y: 2)
        }
        .containerRelativeFrame(.horizontal)
    }
}

#Preview {
    NavigationStack{
        PurchaseOptionsView()
    }
}
