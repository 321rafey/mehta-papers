// ProfileView.swift
// Screens
//
// Profile tab — user info, statistics, and settings menu.

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            // Cream/wheat gradient background (same as rest of app)
            Theme.appGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // ── User Card ────────────────────────────────────────
                    HStack(spacing: 14) {
                        // Avatar circle
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "#E8A030"), Color(hex: "#C87820")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 56, height: 56)
                            Text("ZM")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }

                        // Name + location
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ZEESHAN MEHTA")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Theme.titleText)
                                .tracking(0.5)
                            HStack(spacing: 4) {
                                Image(systemName: "mappin")
                                    .font(.system(size: 10))
                                    .foregroundColor(Theme.subtitleText)
                                Text("Lines Area, Saddar, Karachi")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.subtitleText)
                            }
                        }

                        Spacer()

                        // Edit button
                        Button {} label: {
                            Image(systemName: "pencil")
                                .font(.system(size: 15))
                                .foregroundColor(Theme.subtitleText)
                        }
                    }
                    .padding(18)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

                    // ── Statistics Card ───────────────────────────────────
                    VStack(alignment: .leading, spacing: 14) {
                        // Card header
                        HStack(spacing: 8) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Theme.titleText)
                            Text("Statistics")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Theme.titleText)
                        }

                        Divider()

                        HStack(spacing: 0) {
                            // Total Orders
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total Orders")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.subtitleText)
                                Text("125")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Theme.titleText)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Rectangle()
                                .fill(Color(hex: "#E8E8E8"))
                                .frame(width: 1, height: 40)

                            // Rating
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Rating")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.subtitleText)
                                HStack(spacing: 6) {
                                    Text("4.6")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(Theme.titleText)
                                    // Gold star/coin
                                    Image(systemName: "seal.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(Theme.dotActive)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        }
                    }
                    .padding(18)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

                    // ── Settings Menu Card ────────────────────────────────
                    VStack(spacing: 0) {
                        SettingsRow(icon: "lock.shield", title: "Privacy & Security")
                        Divider().padding(.leading, 46)
                        SettingsRow(icon: "lock.shield", title: "Notification Preference")
                        Divider().padding(.leading, 46)
                        SettingsRow(icon: "lock.shield", title: "Payment Method")
                        Divider().padding(.leading, 46)
                        SettingsRow(icon: "lock.shield", title: "Language")
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 14) {
            // Shield icon in small circle
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Theme.titleText)
                .frame(width: 26, height: 26)

            Text(title)
                .font(.system(size: 15))
                .foregroundColor(Theme.titleText)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Theme.subtitleText)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
    }
}
