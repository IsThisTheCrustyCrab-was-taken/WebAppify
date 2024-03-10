//
//  StoreKitData.swift
//  WebAppify
//
//  Created by Bennet Kampe on 28.02.24.
//

import Foundation
import StoreKit

@Observable
class StoreItems {
    // Products
    let normalTipID = "com.bk.webappify.tinytip"
    let largeTipID = "com.bk.webappify.normalTip"
    let hugeTipID = "com.bk.webappify.hugeTip"
    static var shared = StoreItems()
    var products: [Product] = []
    var normalTip: Product?
    var largeTip: Product?
    var hugeTip: Product?
    func loadProducts() async throws {
        self.normalTip = try await Product.products(for: [normalTipID]).first
        self.largeTip = try await Product.products(for: [largeTipID]).first
        self.hugeTip = try await Product.products(for: [hugeTipID]).first
    }
    // Check Entitlements
    var purchasedProductIDs = Set<String>()
}


@MainActor
class PurchaseManager: ObservableObject {
    init() {
        updates = observeTransactionUpdates()
    }
    deinit {
        updates?.cancel()
    }
    private var updates: Task<Void, Never>? = nil
    func refreshPurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            if transaction.revocationDate == nil {
                StoreItems.shared.purchasedProductIDs.insert(transaction.productID)
            } else {
                StoreItems.shared.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    public enum PurchaseResult {
        case sucess(VerificationResult<Transaction>)
        case userCancelled
        case pending
    }

    func purchase(_ product: Product) async throws -> Product.PurchaseResult? {
        let result = try await product.purchase()
        print("resultttt")
        switch result {
        case .success(.verified(let transaction)):
            print("successBalls")
            await transaction.finish()
            await self.refreshPurchasedProducts()
        case .success(.unverified(_, let error)):
            break
        case .userCancelled:
            break
        case .pending:
            break
        @unknown default:
            break
        }
        return result
    }

    func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verificationResult in Transaction.updates {
                print("benis")
                await self.refreshPurchasedProducts()
            }
        }
    }
}
