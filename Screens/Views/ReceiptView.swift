// ReceiptView.swift
// Screens
//
// Receipt tab — shows receipts + Ledger (Pro) tab.

import SwiftUI

struct ReceiptView: View {
    @ObservedObject private var proManager = ProManager.shared
    @State private var selectedTab = 0   // 0 = Receipts, 1 = Ledger
    @State private var showUpgrade = false

    let receipts = SampleData.receipts

    var body: some View {
        VStack(spacing: 0) {

            // ── Header ───────────────────────────────────────────────────
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(selectedTab == 0 ? "Receipts" : "Ledger")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Theme.titleText)
                    Text(selectedTab == 0 ? "Completed order receipts" : "Bookkeeping & accounts")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.subtitleText)
                }
                Spacer()
                if selectedTab == 0 {
                    Button {} label: {
                        Image(systemName: "arrow.down.doc")
                            .font(.system(size: 16))
                            .foregroundColor(Theme.subtitleText)
                            .frame(width: 36, height: 36)
                            .background(Theme.iconBackground)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 12)
            .background(Theme.cardBackground)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

            // ── Tab Switcher ─────────────────────────────────────────────
            HStack(spacing: 0) {
                ReceiptTabPill(label: "Receipts", isSelected: selectedTab == 0) { selectedTab = 0 }
                ReceiptTabPill(
                    label: "Ledger",
                    isSelected: selectedTab == 1,
                    isLocked: !proManager.isPro
                ) {
                    if proManager.isPro { selectedTab = 1 }
                    else { showUpgrade = true }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Theme.cardBackground)

            // ── Content ──────────────────────────────────────────────────
            if selectedTab == 0 {
                ReceiptListContent(receipts: receipts)
            } else {
                LedgerView()
            }
        }
        .background(Theme.screenBackground)
        .navigationBarHidden(true)
        .sheet(isPresented: $showUpgrade) { UpgradeView() }
    }
}

private struct ReceiptTabPill: View {
    let label: String
    let isSelected: Bool
    var isLocked: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if isLocked {
                    Image(systemName: "lock.fill").font(.system(size: 10))
                }
                Text(label).font(.system(size: 14, weight: isSelected ? .semibold : .regular))
            }
            .foregroundColor(isSelected ? Theme.linkText : Theme.subtitleText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(isSelected ? Theme.linkText.opacity(0.08) : Color.clear)
            .cornerRadius(10)
        }
    }
}

// MARK: - Receipt List
private struct ReceiptListContent: View {
    let receipts: [ReceiptItem]

    var body: some View {
        Group {
            if receipts.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "doc.text")
                        .font(.system(size: 44))
                        .foregroundColor(Theme.subtitleText.opacity(0.3))
                    Text("No receipts yet")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.subtitleText)
                    Text("Receipts appear here once an order is marked completed")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.subtitleText.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Spacer()
                }
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        ForEach(receipts) { receipt in
                            ReceiptCard(receipt: receipt)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    Spacer(minLength: 40)
                }
            }
        }
        .background(Theme.screenBackground)
    }
}

// MARK: - Receipt Card
struct ReceiptCard: View {
    let receipt: ReceiptItem

    var body: some View {
        VStack(spacing: 0) {

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(receipt.orderTitle)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Theme.titleText)
                    Text(receipt.date)
                        .font(.system(size: 11))
                        .foregroundColor(Theme.subtitleText)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    Text(receipt.totalAmount)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.linkText)
                    HStack(spacing: 4) {
                        Circle().fill(Color.green).frame(width: 5, height: 5)
                        Text("Completed")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)

            Divider().padding(.horizontal, 16)

            HStack(spacing: 0) {
                RcptStatCell(label: "Buyer",   value: receipt.buyerName)
                RcptStatCell(label: "Paper",   value: receipt.paperType)
                RcptStatCell(label: "Qty",     value: "\(receipt.quantity) reels")
                RcptStatCell(label: "Type",    value: receipt.orderType)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Divider().padding(.horizontal, 16)

            HStack {
                Label("GSM: \(receipt.weightGSM)  •  Size: \(receipt.size)", systemImage: "doc.plaintext")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.subtitleText)
                    .lineLimit(1)
                Spacer()
                Button {} label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.circle").font(.system(size: 12))
                        Text("Download")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(Theme.linkText)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Theme.cardBackground)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Stat cell
struct RcptStatCell: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(Theme.subtitleText)
            Text(value)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Theme.titleText)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
