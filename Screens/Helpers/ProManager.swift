// ProManager.swift
// Screens
//
// Manages pro subscription state across the entire app.
// In production this would connect to StoreKit / your backend.

import Combine

import SwiftUI

enum ProTier: String, CaseIterable {
    case free     = "Free"
    case standard = "Standard"
    case pro      = "Pro"
}

class ProManager: ObservableObject {
    static let shared = ProManager()

    @Published var isPro: Bool = false
    @Published var currentTier: ProTier = .free

    func upgradeTo(_ tier: ProTier) {
        currentTier = tier
        isPro = tier != .free
    }

    func downgrade() {
        currentTier = .free
        isPro = false
    }

    // Feature gate helper — returns true if user can access a pro feature
    func canAccess(_ feature: ProFeature) -> Bool {
        switch feature {
        case .ledger, .analytics, .inventory, .rateAlerts,
             .priceHistory, .recurringOrders, .buyerCredit:
            return isPro
        case .contractGeneration, .multiStaff:
            return currentTier == .pro
        case .priorityListing:
            return isPro
        }
    }
}

enum ProFeature {
    case ledger
    case analytics
    case inventory
    case rateAlerts
    case priceHistory
    case recurringOrders
    case buyerCredit
    case contractGeneration
    case multiStaff
    case priorityListing
}

// MARK: - Pro Gate View
// Wrap any pro screen with this — shows upgrade prompt if not pro
struct ProGateView<Content: View>: View {
    let feature: ProFeature
    let content: Content
    @ObservedObject var proManager = ProManager.shared
    @State private var showUpgrade = false

    init(feature: ProFeature, @ViewBuilder content: () -> Content) {
        self.feature = feature
        self.content = content()
    }

    var body: some View {
        Group {
            if proManager.canAccess(feature) {
                content
            } else {
                ProLockedView(showUpgrade: $showUpgrade)
            }
        }
        .sheet(isPresented: $showUpgrade) {
            UpgradeView()
        }
    }
}

// MARK: - Locked placeholder
struct ProLockedView: View {
    @Binding var showUpgrade: Bool

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Theme.linkText.opacity(0.1))
                    .frame(width: 100, height: 100)
                Image(systemName: "lock.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Theme.linkText)
            }
            VStack(spacing: 8) {
                Text("Pro Feature")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Theme.titleText)
                Text("Upgrade to unlock this feature\nand grow your trading business.")
                    .font(.system(size: 15))
                    .foregroundColor(Theme.subtitleText)
                    .multilineTextAlignment(.center)
            }
            Button {
                showUpgrade = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                    Text("Upgrade to Pro")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Theme.linkText)
                .cornerRadius(14)
            }
            .padding(.horizontal, 40)
            Spacer()
        }
        .background(Theme.screenBackground)
    }
}
