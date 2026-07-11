// ReceiptView.swift
// Screens
//
// Receipt tab — shows receipts generated from completed orders.
// Placeholder until real backend is connected.

import SwiftUI

struct ReceiptView: View {
    let receipts = SampleData.receipts

    var body: some View {
        VStack(spacing: 0) {

            // ── Header ───────────────────────────────────────────────────
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Receipts")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Theme.titleText)
                    Text("Completed order receipts")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.subtitleText)
                }
                Spacer()
                Button {} label: {
                    Image(systemName: "arrow.down.doc")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.subtitleText)
                        .frame(width: 36, height: 36)
                        .background(Color(hex: "#F2F2F2"))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

            if receipts.isEmpty {
                // Empty state
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
        .background(Color(hex: "#F8F8F8"))
        .navigationBarHidden(true)
    }
}

// MARK: - Receipt Card
struct ReceiptCard: View {
    let receipt: ReceiptItem

    var body: some View {
        VStack(spacing: 0) {

            // ── Top row ──────────────────────────────────────────────────
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

            // ── Stats row ────────────────────────────────────────────────
            HStack(spacing: 0) {
                RcptStatCell(label: "Buyer",   value: receipt.buyerName)
                RcptStatCell(label: "Paper",   value: receipt.paperType)
                RcptStatCell(label: "Qty",     value: "\(receipt.quantity) reels")
                RcptStatCell(label: "Type",    value: receipt.orderType)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Divider().padding(.horizontal, 16)

            // ── Footer ───────────────────────────────────────────────────
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
        .background(Color.white)
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
