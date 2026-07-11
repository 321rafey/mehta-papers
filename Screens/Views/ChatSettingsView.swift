// ChatSettingsView.swift
// Screens — Chat-level settings (opened from MessagesView)

import SwiftUI

struct ChatSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var proManager = ProManager.shared
    @State private var showUpgrade = false
    @State private var showDeleteAlert = false
    @State private var showArchiveAlert = false
    @State private var showReportSheet = false
    @State private var notifyNewMessages = true
    @State private var showMessagePreviews = true

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
                Text("Chat Settings")
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

                    // ── Preferences ────────────────────────────────────
                    SettingsSection(title: "Preferences") {
                        HStack(spacing: 14) {
                            SettingsIcon(systemName: "bell.fill", color: Theme.linkText)
                            Text("New Message Notifications").font(.system(size: 15)).foregroundColor(Theme.titleText)
                            Spacer()
                            Toggle("", isOn: $notifyNewMessages).labelsHidden().tint(Theme.linkText)
                        }
                        .padding(.horizontal, 16).padding(.vertical, 14)

                        Divider().padding(.leading, 16)

                        HStack(spacing: 14) {
                            SettingsIcon(systemName: "eye.fill", color: Color(hex: "#5B7CDB"))
                            Text("Message Previews").font(.system(size: 15)).foregroundColor(Theme.titleText)
                            Spacer()
                            Toggle("", isOn: $showMessagePreviews).labelsHidden().tint(Theme.linkText)
                        }
                        .padding(.horizontal, 16).padding(.vertical, 14)
                    }

                    // ── Backup ─────────────────────────────────────────
                    SettingsSection(title: "Backup") {
                        Button {
                            if !proManager.isPro { showUpgrade = true }
                        } label: {
                            HStack(spacing: 14) {
                                SettingsIcon(systemName: "icloud.and.arrow.up.fill", color: Color(hex: "#27AE60"))
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 6) {
                                        Text("Chat Backup").font(.system(size: 15)).foregroundColor(Theme.titleText)
                                        ProBadge()
                                    }
                                    Text(proManager.isPro ? "Backed up today at 9:00 AM" : "Upgrade to Pro to enable backups")
                                        .font(.system(size: 11))
                                        .foregroundColor(proManager.isPro ? Color(hex: "#27AE60") : Theme.subtitleText)
                                }
                                Spacer()
                                if proManager.isPro {
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(Color(hex: "#27AE60"))
                                } else {
                                    Image(systemName: "lock.fill").foregroundColor(Theme.subtitleText)
                                }
                            }
                            .padding(.horizontal, 16).padding(.vertical, 14)
                        }
                    }

                    // ── Manage Chats ───────────────────────────────────
                    SettingsSection(title: "Manage Chats") {
                        Button { showArchiveAlert = true } label: {
                            HStack(spacing: 14) {
                                SettingsIcon(systemName: "archivebox.fill", color: Color(hex: "#F39C12"))
                                Text("Archive All Chats").font(.system(size: 15)).foregroundColor(Theme.titleText)
                                Spacer()
                                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                            }
                            .padding(.horizontal, 16).padding(.vertical, 14)
                        }

                        Divider().padding(.leading, 16)

                        Button { showDeleteAlert = true } label: {
                            HStack(spacing: 14) {
                                SettingsIcon(systemName: "trash.fill", color: Color(hex: "#E74C3C"))
                                Text("Delete All Chats").font(.system(size: 15)).foregroundColor(Color(hex: "#E74C3C"))
                                Spacer()
                                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                            }
                            .padding(.horizontal, 16).padding(.vertical, 14)
                        }
                    }

                    // ── Help ───────────────────────────────────────────
                    SettingsSection(title: "Help") {
                        Button { showReportSheet = true } label: {
                            HStack(spacing: 14) {
                                SettingsIcon(systemName: "exclamationmark.bubble.fill", color: Color(hex: "#E74C3C"))
                                Text("Report a Problem").font(.system(size: 15)).foregroundColor(Theme.titleText)
                                Spacer()
                                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                            }
                            .padding(.horizontal, 16).padding(.vertical, 14)
                        }

                        Divider().padding(.leading, 16)

                        AppSettingsRow(icon: "questionmark.circle.fill", label: "Help & FAQ", color: Color(hex: "#F39C12"))
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .background(Theme.screenBackground)
        }
        .background(Theme.screenBackground)
        .navigationBarHidden(true)
        .sheet(isPresented: $showUpgrade) { UpgradeView() }
        .sheet(isPresented: $showReportSheet) { ReportProblemSheet() }
        .alert("Archive All Chats?", isPresented: $showArchiveAlert) {
            Button("Archive", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("All your conversations will be archived. You can still access them later.")
        }
        .alert("Delete All Chats?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all your chat history. This action cannot be undone.")
        }
    }
}

// MARK: - Report Problem Sheet
private struct ReportProblemSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var reportText = ""
    @State private var submitted = false
    @State private var selectedCategory = "Bug / Error"

    let categories = ["Bug / Error", "Chat not loading", "Missing messages", "Account issue", "Other"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if submitted {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 60)).foregroundColor(Color(hex: "#27AE60"))
                    Text("Report Submitted").font(.system(size: 22, weight: .bold)).foregroundColor(Theme.titleText)
                    Text("We'll look into this and get back to you.").font(.system(size: 14)).foregroundColor(Theme.subtitleText)
                    Spacer()
                    Button { dismiss() } label: {
                        Text("Done").font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .background(Theme.linkText).cornerRadius(14)
                    }
                    .padding(.horizontal, 24).padding(.bottom, 24)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category").font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)
                        .padding(12).background(Theme.fieldBackground).cornerRadius(10)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Describe the problem").font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                        TextEditor(text: $reportText)
                            .font(.system(size: 15))
                            .frame(height: 140)
                            .padding(10).background(Theme.fieldBackground).cornerRadius(10)
                            .overlay(
                                Group {
                                    if reportText.isEmpty {
                                        Text("Tell us what went wrong...")
                                            .font(.system(size: 15))
                                            .foregroundColor(Theme.subtitleText.opacity(0.5))
                                            .padding(14)
                                    }
                                }, alignment: .topLeading
                            )
                    }

                    Spacer()

                    Button { submitted = true } label: {
                        Text("Submit Report")
                            .font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .background(reportText.count > 5 ? Theme.linkText : Theme.fieldBorder)
                            .cornerRadius(14)
                    }
                    .disabled(reportText.count <= 5)
                    .padding(.bottom, 8)
                }
            }
            .padding(.horizontal, 20).padding(.top, 16)
            .navigationTitle("Report a Problem")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }.foregroundColor(Theme.linkText)
                }
            }
        }
    }
}
