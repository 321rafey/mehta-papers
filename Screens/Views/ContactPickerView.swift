// ContactPickerView.swift
// Screens
//
// Reusable contact picker sheet.
// multiSelect = true  → allows picking several contacts (used in Step 2)
// multiSelect = false → single tap selects and dismisses (used in Re-order)

import SwiftUI

struct ContactPickerView: View {
    let title: String
    let multiSelect: Bool
    let onSelect: ([Conversation]) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var selectedIds: Set<Int> = []

    var body: some View {
        VStack(spacing: 0) {

            // ── Header ───────────────────────────────────────────────────
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Theme.titleText)
                }
                Spacer()
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.titleText)
                Spacer()
                if multiSelect && !selectedIds.isEmpty {
                    Button {
                        let selected = ContactData.all.filter { selectedIds.contains($0.id) }
                        onSelect(selected)
                        dismiss()
                    } label: {
                        Text("Done (\(selectedIds.count))")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Theme.linkText)
                    }
                } else {
                    Color.clear.frame(width: 60, height: 24)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)

            Divider()

            // ── Contact List ─────────────────────────────────────────────
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(ContactData.all) { contact in
                        Button {
                            if multiSelect {
                                if selectedIds.contains(contact.id) {
                                    selectedIds.remove(contact.id)
                                } else {
                                    selectedIds.insert(contact.id)
                                }
                            } else {
                                onSelect([contact])
                                dismiss()
                            }
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

                                if multiSelect {
                                    // Circle checkbox
                                    ZStack {
                                        Circle()
                                            .fill(selectedIds.contains(contact.id) ? Theme.linkText : Color.clear)
                                            .frame(width: 22, height: 22)
                                        Circle()
                                            .stroke(
                                                selectedIds.contains(contact.id) ? Theme.linkText : Theme.fieldBorder,
                                                lineWidth: 1.5
                                            )
                                            .frame(width: 22, height: 22)
                                        if selectedIds.contains(contact.id) {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                } else {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 11))
                                        .foregroundColor(Theme.subtitleText)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                        }
                        Divider().padding(.leading, 74)
                    }
                }
            }
        }
        .background(Theme.cardBackground)
        .navigationBarHidden(true)
    }
}
