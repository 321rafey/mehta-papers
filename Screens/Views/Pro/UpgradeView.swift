// UpgradeView.swift
// Screens
//
// Premium paywall — shown when a free user tries to access a pro feature.

import SwiftUI

struct UpgradeView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var proManager = ProManager.shared
    @State private var selectedTier: ProTier = .pro
    @State private var showSuccess = false

    let tiers: [TierInfo] = [
        TierInfo(tier: .standard,
                 price: "PKR 2,000",
                 period: "/ month",
                 color: Color(hex: "#5B7CDB"),
                 features: [
                    "Ledger & Bookkeeping",
                    "Advanced Analytics",
                    "Inventory Management",
                    "Rate Alerts",
                    "Price History Charts",
                    "Buyer Credit Scores",
                    "Priority Listing",
                 ]),
        TierInfo(tier: .pro,
                 price: "PKR 5,000",
                 period: "/ month",
                 color: Theme.linkText,
                 features: [
                    "Everything in Standard",
                    "Contract & PDF Generation",
                    "Multi-Staff Access (3 accounts)",
                    "Recurring Orders",
                    "Bulk Order Management",
                    "Priority Support",
                    "Early access to new features",
                 ]),
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── Hero ─────────────────────────────────────────────
                    ZStack {
                        LinearGradient(
                            colors: [Color(hex: "#1A1208"), Color(hex: "#3D2B00")],
                            startPoint: .topLeading, endPoint: .bottomTrailing)

                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Theme.linkText.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                Image(systemName: "star.fill")
                                    .font(.system(size: 34))
                                    .foregroundColor(Theme.linkText)
                            }
                            .padding(.top, 32)

                            Text("Upgrade to Pro")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)

                            Text("Unlock powerful tools built for\nserious paper traders.")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 32)
                        }
                    }
                    .frame(maxWidth: .infinity)

                    // ── Tier cards ───────────────────────────────────────
                    VStack(spacing: 16) {
                        ForEach(tiers) { tier in
                            TierCard(
                                info: tier,
                                isSelected: selectedTier == tier.tier
                            ) {
                                selectedTier = tier.tier
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)

                    // ── Free tier note ───────────────────────────────────
                    HStack(spacing: 6) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 12))
                        Text("Free plan includes basic orders, chat, and 3 receipts/month.")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Theme.subtitleText)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // ── CTA Button ───────────────────────────────────────
                    Button {
                        proManager.upgradeTo(selectedTier)
                        showSuccess = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "star.fill")
                            Text("Upgrade to \(selectedTier.rawValue)")
                                .font(.system(size: 17, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [Theme.linkText, Color(hex: "#5D3A00")],
                                startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)

                    Text("Cancel anytime. No hidden fees.")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.subtitleText)
                        .padding(.top, 10)
                        .padding(.bottom, 40)
                }
            }
            .background(Color(hex: "#F8F8F8"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                        .foregroundColor(Theme.linkText)
                }
            }
            .alert("Welcome to Pro! 🎉", isPresented: $showSuccess) {
                Button("Let's Go!") { dismiss() }
            } message: {
                Text("You now have access to all \(selectedTier.rawValue) features. Start exploring your new tools.")
            }
        }
    }
}

// MARK: - Tier Info Model
struct TierInfo: Identifiable {
    let id = UUID()
    let tier: ProTier
    let price: String
    let period: String
    let color: Color
    let features: [String]
}

// MARK: - Tier Card
struct TierCard: View {
    let info: TierInfo
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {

                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(info.tier.rawValue)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            if info.tier == .pro {
                                Text("BEST VALUE")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(info.color)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color.white)
                                    .cornerRadius(6)
                            }
                        }
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            Text(info.price)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            Text(info.period)
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
                            .frame(width: 28, height: 28)
                        if isSelected {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 18, height: 18)
                        }
                    }
                }
                .padding(18)
                .background(info.color)

                // Features
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(info.features, id: \.self) { feature in
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 15))
                                .foregroundColor(info.color)
                            Text(feature)
                                .font(.system(size: 14))
                                .foregroundColor(Theme.titleText)
                        }
                    }
                }
                .padding(18)
                .background(Color.white)
            }
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? info.color : Color.clear, lineWidth: 2.5)
            )
            .shadow(color: isSelected ? info.color.opacity(0.3) : .black.opacity(0.06),
                    radius: isSelected ? 12 : 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}
