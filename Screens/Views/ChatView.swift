// ChatView.swift
// Screens — Individual chat thread

import SwiftUI

// MARK: - Chat Message Model
struct ChatMessage: Identifiable {
    let id: Int
    let text: String
    let isSentByMe: Bool
    let time: String
    var orderCard: OrderChatCard? = nil
}

// MARK: - Chat View
struct ChatView: View {

    let conversation: Conversation
    @Environment(\.dismiss) private var dismiss

    @State private var messageText = ""
    @State private var showAttachmentMenu = false
    @State private var showKebabMenu = false
    @State private var showClearAlert = false
    @State private var showBlockAlert = false
    @State private var showReportAlert = false
    @State private var showSharedReceipts = false
    @State private var isFavorite = false

    @State private var messages: [ChatMessage] = [
        ChatMessage(id: 1, text: "Hi, I'm interested in placing a bulk order.",         isSentByMe: false, time: "9:00 AM"),
        ChatMessage(id: 2, text: "Sure! What quantity are you looking for?",             isSentByMe: true,  time: "9:02 AM"),
        ChatMessage(id: 3, text: "Around 500 units. Can you handle that?",               isSentByMe: false, time: "9:03 AM"),
        ChatMessage(id: 4, text: "Yes, that's no problem. What would be the best time to discuss pricing?", isSentByMe: true, time: "9:05 AM"),
        ChatMessage(id: 5, text: "", isSentByMe: true, time: "9:08 AM",
                    orderCard: OrderChatCard(
                        orderTitle: "Wholesale Order", paperType: "Newsprint",
                        quantityKg: "2500", pricePerKg: "148", cardStatus: .pending
                    )),
        ChatMessage(id: 6, text: "Please review this order and let me know.", isSentByMe: true,  time: "9:09 AM"),
        ChatMessage(id: 7, text: "What would be the best time?",              isSentByMe: false, time: "9:10 AM"),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {

                // ── Header ───────────────────────────────────────────────
                HStack(spacing: 12) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.titleText)
                            .frame(width: 36, height: 36)
                            .background(Theme.iconBackground)
                            .cornerRadius(8)
                    }

                    AvatarView(name: conversation.name, size: 38)

                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 6) {
                            Text(conversation.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Theme.titleText)
                            if isFavorite {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(hex: "#F39C12"))
                            }
                        }
                        Text("Online")
                            .font(.system(size: 11))
                            .foregroundColor(.green)
                    }

                    Spacer()

                    // ⋮ Kebab menu
                    Button { showKebabMenu = true } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Theme.titleText)
                            .frame(width: 36, height: 36)
                            .background(Theme.iconBackground)
                            .cornerRadius(8)
                    }
                    .confirmationDialog("", isPresented: $showKebabMenu, titleVisibility: .hidden) {
                        Button("Shared Receipts") { showSharedReceipts = true }
                        Button(isFavorite ? "Remove from Favorites" : "Add to Favorites") {
                            isFavorite.toggle()
                        }
                        Button("Clear Chat", role: .destructive) { showClearAlert = true }
                        Button("Block Contact", role: .destructive) { showBlockAlert = true }
                        Button("Report Contact", role: .destructive) { showReportAlert = true }
                        Button("Cancel", role: .cancel) {}
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Theme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

                // ── Messages ─────────────────────────────────────────────
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 10) {
                            ForEach(messages) { message in
                                MessageBubble(message: message).id(message.id)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 90) // leave room for input bar
                    }
                    .onAppear {
                        if let last = messages.last { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }

                // ── Input Bar ────────────────────────────────────────────
                HStack(spacing: 10) {
                    // + Attachment button
                    Button { withAnimation(.spring()) { showAttachmentMenu.toggle() } } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(showAttachmentMenu ? Theme.linkText : Theme.subtitleText)
                            .rotationEffect(.degrees(showAttachmentMenu ? 45 : 0))
                            .animation(.spring(), value: showAttachmentMenu)
                    }

                    TextField("Type a message…", text: $messageText)
                        .font(.system(size: 15))
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(Theme.fieldBackground)
                        .cornerRadius(22)

                    Button { sendMessage() } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(messageText.isEmpty ? Theme.fieldBorder : Theme.linkText)
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding(.horizontal, 16).padding(.vertical, 12)
                .background(Theme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: -2)
            }

            // ── Attachment Menu Tray (WhatsApp-style) ────────────────────
            if showAttachmentMenu {
                // Dim overlay
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showAttachmentMenu = false } }

                VStack(spacing: 0) {
                    Spacer()

                    VStack(spacing: 0) {
                        // Handle
                        Capsule()
                            .fill(Color(hex: "#D0D0D0"))
                            .frame(width: 36, height: 4)
                            .padding(.top, 12).padding(.bottom, 20)

                        // 4-icon grid
                        HStack(spacing: 28) {
                            AttachTile(icon: "camera.fill",   label: "Camera",   color: Color(hex: "#E74C3C")) {}
                            AttachTile(icon: "photo.fill",    label: "Photo",    color: Color(hex: "#9B59B6")) {}
                            AttachTile(icon: "doc.fill",      label: "Document", color: Color(hex: "#5B7CDB")) {}
                            AttachTile(icon: "person.fill",   label: "Contact",  color: Color(hex: "#27AE60")) {}
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 36)
                    }
                    .background(Theme.cardBackground)
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                }
                .transition(.move(edge: .bottom))
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .background(Theme.screenBackground)
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $showSharedReceipts) { SharedReceiptsSheet(contactName: conversation.name) }
        .alert("Clear Chat?", isPresented: $showClearAlert) {
            Button("Clear", role: .destructive) { messages.removeAll() }
            Button("Cancel", role: .cancel) {}
        } message: { Text("All messages in this chat will be permanently deleted.") }
        .alert("Block \(conversation.name)?", isPresented: $showBlockAlert) {
            Button("Block", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        } message: { Text("They won't be able to message you and you won't see their orders.") }
        .alert("Report \(conversation.name)?", isPresented: $showReportAlert) {
            Button("Report", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        } message: { Text("A report will be sent to Mehta Papers support for review.") }
    }

    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newMessage = ChatMessage(
            id: messages.count + 1,
            text: messageText.trimmingCharacters(in: .whitespaces),
            isSentByMe: true,
            time: currentTime()
        )
        withAnimation { messages.append(newMessage) }
        messageText = ""
        showAttachmentMenu = false
    }

    private func currentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
}

// MARK: - Attachment Tile
private struct AttachTile: View {
    let icon: String; let label: String; let color: Color; let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle().fill(color).frame(width: 56, height: 56)
                    Image(systemName: icon).font(.system(size: 22)).foregroundColor(.white)
                }
                Text(label).font(.system(size: 12, weight: .medium)).foregroundColor(Theme.titleText)
            }
        }
    }
}

// MARK: - Shared Receipts Sheet
private struct SharedReceiptsSheet: View {
    @Environment(\.dismiss) private var dismiss
    let contactName: String

    let receipts = SampleData.receipts

    var body: some View {
        NavigationStack {
            Group {
                if receipts.isEmpty {
                    VStack(spacing: 14) {
                        Spacer()
                        Image(systemName: "doc.text").font(.system(size: 44)).foregroundColor(Theme.subtitleText.opacity(0.3))
                        Text("No shared receipts").font(.system(size: 16)).foregroundColor(Theme.subtitleText)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(receipts) { receipt in
                                ReceiptCard(receipt: receipt)
                            }
                        }
                        .padding(20)
                    }
                    .background(Theme.screenBackground)
                }
            }
            .navigationTitle("Receipts with \(contactName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }.foregroundColor(Theme.linkText)
                }
            }
        }
    }
}

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        if let card = message.orderCard {
            VStack(alignment: message.isSentByMe ? .trailing : .leading, spacing: 4) {
                OrderCardBubble(card: card, isSentByMe: message.isSentByMe)
                Text(message.time).font(.system(size: 10)).foregroundColor(Theme.subtitleText).padding(.horizontal, 4)
            }
        } else {
            HStack {
                if message.isSentByMe { Spacer(minLength: 60) }
                VStack(alignment: message.isSentByMe ? .trailing : .leading, spacing: 3) {
                    Text(message.text)
                        .font(.system(size: 15))
                        .foregroundColor(message.isSentByMe ? .white : Theme.titleText)
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(message.isSentByMe ? Theme.linkText : Color.white)
                        .cornerRadius(18)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
                    Text(message.time).font(.system(size: 10)).foregroundColor(Theme.subtitleText).padding(.horizontal, 4)
                }
                if !message.isSentByMe { Spacer(minLength: 60) }
            }
        }
    }
}

// MARK: - Order Card Bubble
struct OrderCardBubble: View {
    let card: OrderChatCard
    let isSentByMe: Bool

    var statusColor: Color {
        switch card.cardStatus {
        case .pending:  return Color(hex: "#F39C12")
        case .accepted: return Color(hex: "#27AE60")
        case .closed:   return Color(hex: "#999999")
        }
    }
    var statusLabel: String {
        switch card.cardStatus {
        case .pending:  return "Pending"
        case .accepted: return "Accepted"
        case .closed:   return "Closed"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "doc.text.fill").font(.system(size: 13)).foregroundColor(.white)
                Text("Order Details").font(.system(size: 13, weight: .semibold)).foregroundColor(.white)
                Spacer()
                Text(statusLabel).font(.system(size: 11, weight: .semibold)).foregroundColor(.white)
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(Color.white.opacity(0.25)).cornerRadius(10)
            }
            .padding(.horizontal, 14).padding(.vertical, 10)
            .background(Theme.linkText)

            VStack(spacing: 8) {
                Text(card.orderTitle).font(.system(size: 15, weight: .bold)).foregroundColor(Theme.titleText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Paper Type").font(.system(size: 10)).foregroundColor(Theme.subtitleText)
                        Text(card.paperType).font(.system(size: 12, weight: .semibold)).foregroundColor(Theme.titleText)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Quantity").font(.system(size: 10)).foregroundColor(Theme.subtitleText)
                        Text("\(card.quantityKg) kg").font(.system(size: 12, weight: .semibold)).foregroundColor(Theme.titleText)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Rate").font(.system(size: 10)).foregroundColor(Theme.subtitleText)
                        Text("PKR \(card.pricePerKg)/kg").font(.system(size: 12, weight: .semibold)).foregroundColor(Theme.linkText)
                    }
                    Spacer()
                }
            }
            .padding(12).background(Theme.cardBackground)
        }
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        .frame(maxWidth: 280, alignment: isSentByMe ? .trailing : .leading)
        .frame(maxWidth: .infinity, alignment: isSentByMe ? .trailing : .leading)
    }
}
