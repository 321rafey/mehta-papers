// ReorderPickerView.swift
// Screens
//
// Re-order flow (presented as a sheet from Step 1 when Re-order is selected):
//   1. Pick a contact from chat history
//   2. See all completed past orders with that contact
//   3. Select one → sends a re-order card to the chat with that contact

import SwiftUI

struct ReorderPickerView: View {
    let onComplete: (Conversation) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var selectedContact: Conversation? = nil
    @State private var showOrderList = false

    var pastOrders: [SellerOrder] {
        guard let contact = selectedContact else { return [] }
        return SampleData.sellerOrders.filter {
            $0.buyerName == contact.name && $0.status == .completed
        }
    }

    var body: some View {
        VStack(spacing: 0) {

            // ── Header ───────────────────────────────────────────────────
            HStack {
                if showOrderList {
                    Button { withAnimation { showOrderList = false } } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Theme.titleText)
                    }
                } else {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Theme.titleText)
                    }
                }
                Spacer()
                Text(showOrderList ? "Past Orders" : "Select Contact")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.titleText)
                Spacer()
                Color.clear.frame(width: 24, height: 24)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)

            Divider()

            if !showOrderList {
                // ── Contact List ─────────────────────────────────────────
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(ContactData.all) { contact in
                            Button {
                                selectedContact = contact
                                withAnimation { showOrderList = true }
                            } label: {
                                HStack(spacing: 14) {
                                    AvatarView(name: contact.name, size: 44)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(contact.name)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Theme.titleText)
                                        Text(contact.lastMessage)
                                            .font(.system(size: 12))
                                            .foregroundColor(Theme.subtitleText)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 11))
                                        .foregroundColor(Theme.subtitleText)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                            }
                            Divider().padding(.leading, 74)
                        }
                    }
                }

            } else {
                // ── Past Orders with selected contact ────────────────────
                if pastOrders.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "shippingbox")
                            .font(.system(size: 36))
                            .foregroundColor(Theme.subtitleText.opacity(0.3))
                        Text("No completed orders with \(selectedContact?.name ?? "this contact")")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.subtitleText)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding(40)

                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(pastOrders) { order in
                                Button {
                                    if let contact = selectedContact {
                                        onComplete(contact)
                                        dismiss()
                                    }
                                } label: {
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack {
                                            Text(order.title)
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(Theme.titleText)
                                            Spacer()
                                            Text(order.totalAmount)
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundColor(Theme.linkText)
                                        }

                                        HStack(spacing: 16) {
                                            Label(order.paperType, systemImage: "doc.text")
                                                .font(.system(size: 11))
                                                .foregroundColor(Theme.subtitleText)
                                            Label("\(order.quantity) reels", systemImage: "number")
                                                .font(.system(size: 11))
                                                .foregroundColor(Theme.subtitleText)
                                        }

                                        HStack(spacing: 16) {
                                            Label(order.size, systemImage: "ruler")
                                                .font(.system(size: 11))
                                                .foregroundColor(Theme.subtitleText)
                                            Label(order.weightGSM, systemImage: "scalemass")
                                                .font(.system(size: 11))
                                                .foregroundColor(Theme.subtitleText)
                                        }

                                        Text(order.date)
                                            .font(.system(size: 11))
                                            .foregroundColor(Theme.subtitleText.opacity(0.7))
                                    }
                                    .padding(14)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .background(Color(hex: "#F8F8F8"))
                }
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
}
