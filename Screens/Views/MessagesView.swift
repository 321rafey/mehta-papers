// MessagesView.swift
// Screens
//
// Messages list screen — reached by tapping the chat bubble
// icon on the home screen header.

import SwiftUI

// MARK: - Data Model
struct Conversation: Identifiable {
    let id: Int
    let name: String
    let lastMessage: String
    let time: String
    let unreadCount: Int   // 0 = no badge shown
}

// MARK: - Messages View
struct MessagesView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var showChatSettings = false

    // Sample conversations — replace with real data later
    let conversations: [Conversation] = [
        Conversation(id: 1, name: "Sean Baker",    lastMessage: "What would be the best time?",  time: "2m",  unreadCount: 2),
        Conversation(id: 2, name: "Ahmad Raza",    lastMessage: "Can you confirm the order?",     time: "11m", unreadCount: 0),
        Conversation(id: 3, name: "Sara Malik",    lastMessage: "Sure, I'll send it over.",       time: "21m", unreadCount: 0),
        Conversation(id: 4, name: "Bilal Khan",    lastMessage: "The package arrived today.",     time: "45m", unreadCount: 0),
        Conversation(id: 5, name: "Nadia Farooq",  lastMessage: "Thanks for the update!",        time: "51m", unreadCount: 0),
        Conversation(id: 6, name: "Omar Sheikh",   lastMessage: "When is the next shipment?",    time: "1w",  unreadCount: 6),
    ]

    // Filter conversations based on search
    var filteredConversations: [Conversation] {
        if searchText.isEmpty { return conversations }
        return conversations.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.lastMessage.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(spacing: 0) {

            // ── Custom Navigation Bar ────────────────────────────────────
            HStack {
                // Back button
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.titleText)
                        .frame(width: 36, height: 36)
                        .background(Theme.iconBackground)
                        .cornerRadius(8)
                }

                Spacer()

                Text("Messages")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Theme.titleText)

                Spacer()

                // Settings button → opens Chat Settings
                Button { showChatSettings = true } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.subtitleText)
                        .frame(width: 36, height: 36)
                        .background(Theme.iconBackground)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 16)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── Search Bar ───────────────────────────────────────
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Theme.fieldIcon)
                        TextField("Search messages", text: $searchText)
                            .font(.system(size: 15))
                            .foregroundColor(Theme.titleText)
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 46)
                    .background(Theme.cardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.fieldBorder, lineWidth: 1.5)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)

                    // ── Pending Reply Notification Card ──────────────────
                    PendingReplyCard()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)

                    // ── Conversation List ────────────────────────────────
                    VStack(spacing: 0) {
                        ForEach(filteredConversations) { convo in
                            NavigationLink(destination: ChatView(conversation: convo)) {
                                ConversationRow(conversation: convo)
                            }
                            .buttonStyle(.plain)

                            // Divider between rows (not after the last one)
                            if convo.id != filteredConversations.last?.id {
                                Divider()
                                    .padding(.leading, 74)
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 40)
                }
                .padding(.top, 4)
            }
        }
        .background(Theme.cardBackground)
        .navigationBarHidden(true)
        .sheet(isPresented: $showChatSettings) { ChatSettingsView() }
    }
}

// MARK: - Pending Reply Card
struct PendingReplyCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                // Profile photo placeholder
                AvatarView(name: "Jason Brody", size: 44)

                VStack(alignment: .leading, spacing: 3) {
                    Group {
                        Text("Jason Brody ")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.titleText)
                        + Text("seems to be waiting for a reply to your message since a week ago")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.subtitleText)
                    }
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
                }
            }

            HStack {
                Spacer()
                Button {} label: {
                    Text("Reply Now")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Theme.titleText)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(Theme.cardBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Theme.fieldBorder, lineWidth: 1.5)
                        )
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.fieldBorder, lineWidth: 1.5)
        )
    }
}

// MARK: - Conversation Row
struct ConversationRow: View {
    let conversation: Conversation

    var body: some View {
        HStack(spacing: 12) {

            // Profile avatar
            AvatarView(name: conversation.name, size: 50)

            // Name + message preview
            VStack(alignment: .leading, spacing: 3) {
                Text(conversation.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Theme.titleText)
                Text(conversation.lastMessage)
                    .font(.system(size: 13))
                    .foregroundColor(Theme.subtitleText)
                    .lineLimit(1)
            }

            Spacer()

            // Time + unread badge
            VStack(alignment: .trailing, spacing: 5) {
                Text(conversation.time)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.subtitleText)

                if conversation.unreadCount > 0 {
                    Text("\(conversation.unreadCount)")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.vertical, 14)
    }
}

// MARK: - Avatar View
// Generates a colored circle with the person's initials.
// Replace with a real Image("photo") when you have profile photos.
struct AvatarView: View {
    let name: String
    let size: CGFloat

    // Derive initials from the name (e.g. "Sean Baker" → "SB")
    var initials: String {
        let parts = name.split(separator: " ")
        let first = parts.first?.prefix(1) ?? ""
        let last  = parts.dropFirst().first?.prefix(1) ?? ""
        return "\(first)\(last)".uppercased()
    }

    // Pick a consistent color based on the name
    var bgColor: Color {
        let colors: [Color] = [
            Color(hex: "#C8A96E"),
            Color(hex: "#6E9EC8"),
            Color(hex: "#9EC86E"),
            Color(hex: "#C86E9E"),
            Color(hex: "#6EC8C8"),
        ]
        let index = abs(name.hashValue) % colors.count
        return colors[index]
    }

    var body: some View {
        ZStack {
            Circle().fill(bgColor.opacity(0.25))
            Text(initials)
                .font(.system(size: size * 0.34, weight: .semibold))
                .foregroundColor(bgColor)
        }
        .frame(width: size, height: size)
    }
}
