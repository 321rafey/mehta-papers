// ProfileView.swift
// Screens
//
// Profile tab — user info, statistics, settings, and Pro upgrade.

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var proManager = ProManager.shared
    @State private var showUpgrade = false

    var body: some View {
        ZStack {
            Theme.appGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // ── User Card ────────────────────────────────────────
                    HStack(spacing: 14) {
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

                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Text("ZEESHAN MEHTA")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Theme.titleText)
                                    .tracking(0.5)
                                if proManager.isPro {
                                    Text(proManager.currentTier == .pro ? "PRO" : "STD")
                                        .font(.system(size: 9, weight: .black))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 6).padding(.vertical, 2)
                                        .background(proManager.currentTier == .pro ? Color(hex: "#8B6914") : Color(hex: "#5B7CDB"))
                                        .cornerRadius(4)
                                }
                            }
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

                    // ── Pro Upgrade Banner (free users only) ─────────────
                    if !proManager.isPro {
                        Button { showUpgrade = true } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle().fill(Color(hex: "#8B6914").opacity(0.15)).frame(width: 44, height: 44)
                                    Image(systemName: "star.fill").font(.system(size: 18)).foregroundColor(Color(hex: "#8B6914"))
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Upgrade to Pro")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(Color(hex: "#8B6914"))
                                    Text("Unlock analytics, inventory, alerts & more")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(hex: "#8B6914").opacity(0.7))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Color(hex: "#8B6914"))
                            }
                            .padding(16)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "#FDF3DC"), Color(hex: "#FAE8B8")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#E8C860").opacity(0.4), lineWidth: 1))
                        }
                    }

                    // ── Pro Plan Info (pro users) ────────────────────────
                    if proManager.isPro {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle().fill(Color(hex: "#8B6914").opacity(0.15)).frame(width: 44, height: 44)
                                Image(systemName: "crown.fill").font(.system(size: 18)).foregroundColor(Color(hex: "#8B6914"))
                            }
                            VStack(alignment: .leading, spacing: 3) {
                                Text(proManager.currentTier == .pro ? "Pro Plan Active" : "Standard Plan Active")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(hex: "#8B6914"))
                                Text("All pro features unlocked")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "#8B6914").opacity(0.7))
                            }
                            Spacer()
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 22))
                                .foregroundColor(Color(hex: "#8B6914"))
                        }
                        .padding(16)
                        .background(LinearGradient(colors: [Color(hex: "#FDF3DC"), Color(hex: "#FAE8B8")], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#E8C860").opacity(0.4), lineWidth: 1))
                    }

                    // ── Statistics Card ───────────────────────────────────
                    VStack(alignment: .leading, spacing: 14) {
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

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Rating")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.subtitleText)
                                HStack(spacing: 6) {
                                    Text("4.6")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(Theme.titleText)
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
                        SettingsRow(icon: "bell", title: "Notification Preference")
                        Divider().padding(.leading, 46)
                        SettingsRow(icon: "creditcard", title: "Payment Method")
                        Divider().padding(.leading, 46)
                        SettingsRow(icon: "globe", title: "Language")
                        if proManager.isPro {
                            Divider().padding(.leading, 46)
                            Button {
                                ProManager.shared.upgradeTo(.free)
                            } label: {
                                HStack(spacing: 14) {
                                    Image(systemName: "arrow.down.circle")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "#E74C3C"))
                                        .frame(width: 26, height: 26)
                                    Text("Cancel Subscription")
                                        .font(.system(size: 15))
                                        .foregroundColor(Color(hex: "#E74C3C"))
                                    Spacer()
                                }
                                .padding(.horizontal, 18)
                                .padding(.vertical, 16)
                            }
                        }
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
        .sheet(isPresented: $showUpgrade) { UpgradeView() }
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 14) {
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
