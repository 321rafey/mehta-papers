// AppSettingsView.swift
// Screens — App-wide settings

import SwiftUI

struct AppSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("soundEnabled") private var soundEnabled = true
    @State private var showVerifySheet = false
    @State private var showLogoutAlert = false
    @State private var isVerified = false

    var body: some View {
        VStack(spacing: 0) {

            // ── Header ─────────────────────────────────────────────────
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.titleText)
                        .frame(width: 36, height: 36)
                        .background(Theme.iconBackground)
                        .cornerRadius(8)
                }
                Spacer()
                Text("Settings")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Theme.titleText)
                Spacer()
                Spacer().frame(width: 36)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16).padding(.bottom, 16)
            .background(Theme.cardBackground)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // ── Account ────────────────────────────────────────
                    SettingsSection(title: "Account") {
                        // Profile row
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [Color(hex: "#E8A030"), Color(hex: "#C87820")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 48, height: 48)
                                Text("ZM").font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                            }
                            VStack(alignment: .leading, spacing: 3) {
                                HStack(spacing: 6) {
                                    Text("Zeeshan Mehta").font(.system(size: 15, weight: .bold)).foregroundColor(Theme.titleText)
                                    if isVerified {
                                        Image(systemName: "checkmark.seal.fill").font(.system(size: 12)).foregroundColor(Color(hex: "#27AE60"))
                                    }
                                }
                                Text("zeeshan@mehtapapers.com").font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                        }
                        .padding(.horizontal, 16).padding(.vertical, 14)

                        Divider().padding(.leading, 16)

                        // Verify account
                        Button { showVerifySheet = true } label: {
                            HStack(spacing: 14) {
                                SettingsIcon(systemName: "checkmark.shield", color: Color(hex: "#27AE60"))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Verify Your Account").font(.system(size: 15)).foregroundColor(Theme.titleText)
                                    Text(isVerified ? "Account is verified ✓" : "Upload CNIC to get verified badge")
                                        .font(.system(size: 11))
                                        .foregroundColor(isVerified ? Color(hex: "#27AE60") : Theme.subtitleText)
                                }
                                Spacer()
                                if isVerified {
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(Color(hex: "#27AE60"))
                                } else {
                                    Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                                }
                            }
                            .padding(.horizontal, 16).padding(.vertical, 14)
                        }
                    }

                    // ── Appearance ─────────────────────────────────────
                    SettingsSection(title: "Appearance") {
                        HStack(spacing: 14) {
                            SettingsIcon(systemName: isDarkMode ? "moon.fill" : "sun.max.fill", color: isDarkMode ? Color(hex: "#5B7CDB") : Color(hex: "#F39C12"))
                            Text("Dark Mode").font(.system(size: 15)).foregroundColor(Theme.titleText)
                            Spacer()
                            Toggle("", isOn: $isDarkMode).labelsHidden().tint(Theme.linkText)
                        }
                        .padding(.horizontal, 16).padding(.vertical, 14)
                    }

                    // ── Notifications ──────────────────────────────────
                    SettingsSection(title: "Notifications") {
                        HStack(spacing: 14) {
                            SettingsIcon(systemName: "bell.fill", color: Theme.linkText)
                            Text("Push Notifications").font(.system(size: 15)).foregroundColor(Theme.titleText)
                            Spacer()
                            Toggle("", isOn: $notificationsEnabled).labelsHidden().tint(Theme.linkText)
                        }
                        .padding(.horizontal, 16).padding(.vertical, 14)

                        Divider().padding(.leading, 16)

                        HStack(spacing: 14) {
                            SettingsIcon(systemName: "speaker.wave.2.fill", color: Color(hex: "#9B59B6"))
                            Text("Message Sounds").font(.system(size: 15)).foregroundColor(Theme.titleText)
                            Spacer()
                            Toggle("", isOn: $soundEnabled).labelsHidden().tint(Theme.linkText)
                        }
                        .padding(.horizontal, 16).padding(.vertical, 14)
                    }

                    // ── Privacy & Security ─────────────────────────────
                    SettingsSection(title: "Privacy & Security") {
                        AppSettingsRow(icon: "lock.fill", label: "Change Password", color: Color(hex: "#E74C3C"))
                        Divider().padding(.leading, 16)
                        AppSettingsRow(icon: "hand.raised.fill", label: "Privacy Policy", color: Color(hex: "#5B7CDB"))
                        Divider().padding(.leading, 16)
                        AppSettingsRow(icon: "doc.text.fill", label: "Terms of Service", color: Color(hex: "#27AE60"))
                    }

                    // ── Support ────────────────────────────────────────
                    SettingsSection(title: "Support") {
                        AppSettingsRow(icon: "questionmark.circle.fill", label: "Help & FAQ", color: Color(hex: "#F39C12"))
                        Divider().padding(.leading, 16)
                        AppSettingsRow(icon: "exclamationmark.bubble.fill", label: "Report a Problem", color: Color(hex: "#E74C3C"))
                        Divider().padding(.leading, 16)
                        AppSettingsRow(icon: "star.fill", label: "Rate the App", color: Color(hex: "#F39C12"))
                    }

                    // ── Account Actions ────────────────────────────────
                    SettingsSection(title: "") {
                        Button { showLogoutAlert = true } label: {
                            HStack {
                                Spacer()
                                Text("Log Out")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "#E74C3C"))
                                Spacer()
                            }
                            .padding(.vertical, 16)
                        }
                    }

                    Text("Mehta Papers v1.0")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.subtitleText)
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .background(Theme.screenBackground)
        }
        .background(Theme.screenBackground)
        .navigationBarHidden(true)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .sheet(isPresented: $showVerifySheet) { VerifyAccountSheet(isVerified: $isVerified) }
        .alert("Log Out", isPresented: $showLogoutAlert) {
            Button("Log Out", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to log out?")
        }
    }
}

// MARK: - Verify Account Sheet
private struct VerifyAccountSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isVerified: Bool
    @State private var uploaded = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle().fill(Color(hex: "#27AE60").opacity(0.1)).frame(width: 100, height: 100)
                    Image(systemName: uploaded ? "checkmark.seal.fill" : "creditcard.fill")
                        .font(.system(size: 44))
                        .foregroundColor(Color(hex: "#27AE60"))
                }

                VStack(spacing: 8) {
                    Text(uploaded ? "You're Verified!" : "Verify Your Account")
                        .font(.system(size: 24, weight: .bold)).foregroundColor(Theme.titleText)
                    Text(uploaded ? "Your CNIC has been submitted for review. Verified badge will appear shortly." :
                         "Upload your CNIC to receive a verified badge on your profile. This builds trust with buyers and sellers.")
                        .font(.system(size: 14)).foregroundColor(Theme.subtitleText)
                        .multilineTextAlignment(.center).padding(.horizontal, 30)
                }

                if !uploaded {
                    VStack(spacing: 12) {
                        Button {
                            uploaded = true
                            isVerified = true
                        } label: {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("Upload CNIC Front")
                            }
                            .font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .background(Color(hex: "#27AE60")).cornerRadius(14)
                        }

                        Button {
                            uploaded = true
                            isVerified = true
                        } label: {
                            HStack {
                                Image(systemName: "photo.fill")
                                Text("Upload from Photos")
                            }
                            .font(.system(size: 15, weight: .semibold)).foregroundColor(Theme.linkText)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .background(Theme.linkText.opacity(0.08)).cornerRadius(14)
                        }
                    }
                    .padding(.horizontal, 24)
                } else {
                    Button { dismiss() } label: {
                        Text("Done")
                            .font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .background(Theme.linkText).cornerRadius(14)
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()
            }
            .navigationTitle("Account Verification")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }.foregroundColor(Theme.linkText)
                }
            }
        }
    }
}

// MARK: - Reusable components
struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !title.isEmpty {
                Text(title.uppercased())
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Theme.subtitleText)
                    .padding(.horizontal, 4).padding(.bottom, 8)
            }
            VStack(spacing: 0) {
                content
            }
            .background(Theme.cardBackground)
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
    }
}

struct SettingsIcon: View {
    let systemName: String
    let color: Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8).fill(color).frame(width: 30, height: 30)
            Image(systemName: systemName).font(.system(size: 14)).foregroundColor(.white)
        }
    }
}

struct AppSettingsRow: View {
    let icon: String
    let label: String
    let color: Color

    var body: some View {
        Button {} label: {
            HStack(spacing: 14) {
                SettingsIcon(systemName: icon, color: color)
                Text(label).font(.system(size: 15)).foregroundColor(Theme.titleText)
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(Theme.subtitleText)
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
        }
    }
}   
