// PaperTypeSelectorView.swift
// Screens
//
// Full-screen paper type selector presented as a sheet.
// Search bar, categories, star = mark favourite, checkmark = select.
// Each item carries its own ratePerKg and GSM value.

import SwiftUI

struct PaperTypeSelectorView: View {
    @Binding var selectedPaperName: String
    @Binding var selectedRatePerKg: Double
    @Binding var selectedGSM: Double
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var categories = SampleData.paperCategories

    var filtered: [PaperCategory] {
        guard !searchText.isEmpty else { return categories }
        return categories.compactMap { cat in
            let matchingItems = cat.items.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
            return matchingItems.isEmpty ? nil : PaperCategory(id: cat.id, name: cat.name, items: matchingItems)
        }
    }

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
                Text("Select Paper Type")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.titleText)
                Spacer()
                Color.clear.frame(width: 24, height: 24)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)

            // ── Search Bar ───────────────────────────────────────────────
            HStack(spacing: 10) {
                TextField("Search paper type", text: $searchText)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.titleText)
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Theme.fieldIcon)
            }
            .padding(.horizontal, 14)
            .frame(height: 44)
            .background(Color(hex: "#F5F5F5"))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.fieldBorder, lineWidth: 1))
            .padding(.horizontal, 20)
            .padding(.bottom, 8)

            Divider()

            // ── Category List ────────────────────────────────────────────
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    Text("Raw Material")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.subtitleText)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)

                    ForEach(filtered.indices, id: \.self) { ci in

                        // Category header
                        Text(filtered[ci].name)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Theme.titleText)
                            .padding(.horizontal, 20)
                            .padding(.top, 12)
                            .padding(.bottom, 4)

                        // Items
                        ForEach(filtered[ci].items.indices, id: \.self) { ii in
                            let item = filtered[ci].items[ii]

                            HStack(spacing: 10) {
                                Text(item.name)
                                    .font(.system(size: 13))
                                    .foregroundColor(Theme.titleText)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                // Rate badge
                                Text("PKR \(Int(item.ratePerKg))/kg")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(Theme.subtitleText)

                                // Star — mark as favourite
                                Button {
                                    // Toggle favourite in live state
                                    if let realCi = categories.firstIndex(where: { $0.id == filtered[ci].id }),
                                       let realIi = categories[realCi].items.firstIndex(where: { $0.id == item.id }) {
                                        categories[realCi].items[realIi].isFavorite.toggle()
                                    }
                                } label: {
                                    Image(systemName: item.isFavorite ? "star.fill" : "star")
                                        .font(.system(size: 13))
                                        .foregroundColor(item.isFavorite ? Theme.dotActive : Theme.subtitleText)
                                        .frame(width: 34, height: 34)
                                        .background(Color(hex: "#F5F0E8"))
                                        .cornerRadius(8)
                                }

                                // Checkmark — select this paper
                                Button {
                                    selectedPaperName = item.name
                                    selectedRatePerKg = item.ratePerKg
                                    selectedGSM       = item.gsm
                                    dismiss()
                                } label: {
                                    Image(systemName: "checkmark.circle")
                                        .font(.system(size: 13))
                                        .foregroundColor(
                                            item.name == selectedPaperName
                                                ? Theme.linkText
                                                : Theme.subtitleText
                                        )
                                        .frame(width: 34, height: 34)
                                        .background(Color(hex: "#F5F0E8"))
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)

                            Divider().padding(.horizontal, 20)
                        }

                        Spacer(minLength: 4)
                    }

                    Spacer(minLength: 30)
                }
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
}
