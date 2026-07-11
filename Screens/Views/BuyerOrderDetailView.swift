// BuyerOrderDetailView.swift
// Screens
//
// Shown when a seller taps a recent buyer order from the Home feed.
// Displays buyer status, location, requirements, offer, verification.
// "Send Offer" changes to "Offer Sent" then navigates to existing chat.

import SwiftUI

struct BuyerOrderDetailView: View {
    let order: BuyerOrder
    @State private var offerSent = false
    @State private var navigateToChat = false
    @Environment(\.dismiss) private var dismiss

    // Resolve the matching conversation for this buyer
    private var conversation: Conversation {
        let contacts = ContactData.all
        return contacts.first { $0.id == order.conversationId } ?? contacts[0]
    }

    var body: some View {
        VStack(spacing: 0) {

            // ── Custom Nav Bar ───────────────────────────────────────────
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.titleText)
                        .frame(width: 36, height: 36)
                        .background(Theme.iconBackground)
                        .cornerRadius(10)
                }
                Spacer()
                Text("Buyer Order")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Theme.titleText)
                Spacer()
                Color.clear.frame(width: 36, height: 36)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(Theme.cardBackground)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

            // ── Scrollable Content ───────────────────────────────────────
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // ── Buyer Header ─────────────────────────────────────
                    VStack(spacing: 0) {
                        HStack(spacing: 14) {
                            AvatarView(name: order.buyerName, size: 52)

                            VStack(alignment: .leading, spacing: 5) {
                                Text(order.buyerName)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Theme.titleText)

                                HStack(spacing: 5) {
                                    Circle()
                                        .fill(order.onlineStatus == "Online" ? Color.green : Color(hex: "#FFA500"))
                                        .frame(width: 7, height: 7)
                                    Text(order.onlineStatus)
                                        .font(.system(size: 12))
                                        .foregroundColor(Theme.subtitleText)
                                }
                            }

                            Spacer()

                            if order.isVerified {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 11))
                                        .foregroundColor(.green)
                                    Text("Verified")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.green)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(20)
                            }
                        }
                        .padding(16)

                        Divider().padding(.horizontal, 16)

                        // Location
                        HStack(spacing: 8) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 15))
                                .foregroundColor(Theme.linkText)
                            Text(order.location)
                                .font(.system(size: 13))
                                .foregroundColor(Theme.subtitleText)
                            Spacer()
                        }
                        .padding(16)
                    }
                    .background(Theme.cardBackground)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

                    // ── Requirements Card ────────────────────────────────
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Order Requirements")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Theme.subtitleText)
                            .padding(.horizontal, 16)
                            .padding(.top, 14)
                            .padding(.bottom, 10)

                        Divider().padding(.horizontal, 16)

                        BuyerDetailRow(icon: "doc.text.fill",      label: "Paper Type",   value: order.paperType)
                        Divider().padding(.leading, 52)
                        BuyerDetailRow(icon: "scalemass.fill",     label: "Quantity",     value: "\(Int(order.quantityKg)) kg")
                        Divider().padding(.leading, 52)
                        BuyerDetailRow(icon: "tag.fill",           label: "Buyer Offer",  value: "PKR \(Int(order.offerPerKg))/kg")
                        Divider().padding(.leading, 52)

                        // Verification row
                        HStack(spacing: 12) {
                            Image(systemName: order.isVerified ? "checkmark.shield.fill" : "shield")
                                .font(.system(size: 16))
                                .foregroundColor(order.isVerified ? .green : Theme.subtitleText)
                                .frame(width: 20)
                                .padding(.leading, 16)
                            Text(order.isVerified ? "✓  Verified Buyer" : "Unverified Buyer")
                                .font(.system(size: 14, weight: order.isVerified ? .medium : .regular))
                                .foregroundColor(order.isVerified ? .green : Theme.subtitleText)
                            Spacer()
                        }
                        .padding(.vertical, 14)
                    }
                    .background(Theme.cardBackground)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .background(Theme.screenBackground)

            // ── Send Offer Button ────────────────────────────────────────
            VStack(spacing: 0) {
                // Hidden navigation trigger
                NavigationLink(
                    destination: ChatView(conversation: conversation),
                    isActive: $navigateToChat
                ) { EmptyView() }

                Button {
                    withAnimation(.easeInOut(duration: 0.25)) { offerSent = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        navigateToChat = true
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: offerSent ? "checkmark.circle.fill" : "paperplane.fill")
                            .font(.system(size: 15))
                        Text(offerSent ? "Offer Sent" : "Send Offer")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(offerSent ? .white : Theme.primaryButtonText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(offerSent ? Color.green : Theme.primaryButtonBG)
                    .cornerRadius(14)
                }
                .disabled(offerSent)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Theme.cardBackground)
        }
        .navigationBarHidden(true)
        .background(Theme.screenBackground)
    }
}

// MARK: - Detail Row
struct BuyerDetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Theme.linkText)
                .frame(width: 20)
                .padding(.leading, 16)
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(Theme.subtitleText)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.titleText)
                .padding(.trailing, 16)
        }
        .padding(.vertical, 14)
    }
}

// MARK: - Shared contact list used across picker views
struct ContactData {
    static let all: [Conversation] = [
        Conversation(id: 1, name: "Ahmed Khan",   lastMessage: "Let me know the rate",   time: "2m",  unreadCount: 3),
        Conversation(id: 2, name: "Sara Malik",   lastMessage: "Order confirmed",         time: "15m", unreadCount: 0),
        Conversation(id: 3, name: "Raza Traders", lastMessage: "Can you do 228?",         time: "1h",  unreadCount: 1),
        Conversation(id: 4, name: "Jason Brody",  lastMessage: "Waiting for your offer",  time: "3h",  unreadCount: 2),
        Conversation(id: 5, name: "Ali Printers", lastMessage: "Done, receipt attached",  time: "1d",  unreadCount: 0),
    ]
}
