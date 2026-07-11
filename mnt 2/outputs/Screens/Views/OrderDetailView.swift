// OrderDetailView.swift
// Screens
//
// Full detail of a seller-created order.
// Seller can manually update status: Ongoing → Completed or Cancelled.

import SwiftUI

struct OrderDetailView: View {
    @Binding var order: SellerOrder
    @Environment(\.dismiss) private var dismiss

    var statusColor: Color {
        switch order.status {
        case .ongoing:   return Color(hex: "#F39C12")
        case .cancelled: return Color(hex: "#E74C3C")
        case .completed: return Color(hex: "#27AE60")
        }
    }

    var body: some View {
        VStack(spacing: 0) {

            // ── Nav Bar ──────────────────────────────────────────────────
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.titleText)
                        .frame(width: 36, height: 36)
                        .background(Color(hex: "#F2F2F2"))
                        .cornerRadius(10)
                }
                Spacer()
                Text("Order Details")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Theme.titleText)
                Spacer()
                Color.clear.frame(width: 36, height: 36)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // ── Status / Title Card ──────────────────────────────
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(order.title)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Theme.titleText)
                            Text(order.date)
                                .font(.system(size: 12))
                                .foregroundColor(Theme.subtitleText)
                        }
                        Spacer()
                        HStack(spacing: 5) {
                            Circle().fill(statusColor).frame(width: 7, height: 7)
                            Text(order.status.rawValue)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(statusColor)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(statusColor.opacity(0.1))
                        .cornerRadius(20)
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

                    // ── Order Info ───────────────────────────────────────
                    VStack(spacing: 0) {
                        ODRow(label: "Buyer",       value: order.buyerName)
                        Divider().padding(.horizontal, 16)
                        ODRow(label: "Order Type",  value: order.orderType)
                        Divider().padding(.horizontal, 16)
                        ODRow(label: "Paper Type",  value: order.paperType)
                        Divider().padding(.horizontal, 16)
                        ODRow(label: "Size",        value: order.size)
                        Divider().padding(.horizontal, 16)
                        ODRow(label: "GSM Weight",  value: order.weightGSM)
                        Divider().padding(.horizontal, 16)
                        ODRow(label: "Quantity",    value: "\(order.quantity) reels")
                        Divider().padding(.horizontal, 16)
                        ODRow(label: "Rate",        value: "PKR \(Int(order.pricePerKg))/kg")
                        Divider().padding(.horizontal, 16)
                        ODRow(label: "Total",       value: order.totalAmount, highlight: true)
                    }
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

                    // ── Update Status (only for ongoing orders) ──────────
                    if order.status == .ongoing {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Update Order Status")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Theme.subtitleText)

                            HStack(spacing: 12) {
                                Button {
                                    withAnimation { order.status = .completed }
                                } label: {
                                    Text("Mark Completed")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 46)
                                        .background(Color(hex: "#27AE60"))
                                        .cornerRadius(12)
                                }

                                Button {
                                    withAnimation { order.status = .cancelled }
                                } label: {
                                    Text("Cancel Order")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 46)
                                        .background(Color(hex: "#E74C3C"))
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(14)
                        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                    }

                    // ── Completed — receipt note ─────────────────────────
                    if order.status == .completed {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "#27AE60"))
                            Text("Receipt has been sent to the chat and saved in the Receipts tab.")
                                .font(.system(size: 13))
                                .foregroundColor(Theme.subtitleText)
                        }
                        .padding(14)
                        .background(Color(hex: "#27AE60").opacity(0.08))
                        .cornerRadius(12)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .background(Color(hex: "#F8F8F8"))
        }
        .navigationBarHidden(true)
        .background(Color(hex: "#F8F8F8"))
    }
}

// MARK: - Row helper
struct ODRow: View {
    let label: String
    let value: String
    var highlight = false

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(Theme.subtitleText)
            Spacer()
            Text(value)
                .font(.system(size: highlight ? 15 : 14, weight: highlight ? .bold : .semibold))
                .foregroundColor(highlight ? Theme.linkText : Theme.titleText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }
}
