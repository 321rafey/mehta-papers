// PaperTypeSelectorView.swift
// Screens
//
// Material type selector — shows both Paper and Board categories.
// Search bar, star = favourite, checkmark = select.

import SwiftUI

struct PaperTypeSelectorView: View {
    @Binding var selectedPaperName: String
    @Binding var selectedRatePerKg: Double
    @Binding var selectedGSM: Double
    @Binding var selectedIsBoard: Bool
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var categories = SampleData.paperCategories
    @State private var activeSection = 0   // 0 = Paper, 1 = Board

    var paperCats: [PaperCategory] { categories.filter { !$0.isBoard } }
    var boardCats: [PaperCategory] { categories.filter { $0.isBoard } }

    var filteredPaper: [PaperCategory] {
        guard !searchText.isEmpty else { return paperCats }
        return paperCats.compactMap { cat in
            let items = cat.items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            return items.isEmpty ? nil : PaperCategory(id: cat.id, name: cat.name, items: items, isBoard: false)
        }
    }

    var filteredBoard: [PaperCategory] {
        guard !searchText.isEmpty else { return boardCats }
        return boardCats.compactMap { cat in
            let items = cat.items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            return items.isEmpty ? nil : PaperCategory(id: cat.id, name: cat.name, items: items, isBoard: true)
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
                Text("Select Material Type")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.titleText)
                Spacer()
                Color.clear.frame(width: 24, height: 24)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)

            // ── Paper / Board toggle ─────────────────────────────────────
            HStack(spacing: 0) {
                SectionTab(label: "Paper", isActive: activeSection == 0) { activeSection = 0 }
                SectionTab(label: "Board", isActive: activeSection == 1) { activeSection = 1 }
            }
            .padding(.horizontal, 20).padding(.bottom, 10)

            // ── Search Bar ───────────────────────────────────────────────
            HStack(spacing: 10) {
                TextField("Search \(activeSection == 0 ? "paper" : "board") type", text: $searchText)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.titleText)
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Theme.fieldIcon)
            }
            .padding(.horizontal, 14)
            .frame(height: 44)
            .background(Theme.fieldBackground)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.fieldBorder, lineWidth: 1))
            .padding(.horizontal, 20)
            .padding(.bottom, 8)

            Divider()

            // ── Category List ────────────────────────────────────────────
            let displayCats = activeSection == 0 ? filteredPaper : filteredBoard
            let isBoard = activeSection == 1

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    Text(isBoard ? "Board — Formula: L×W×GSM÷15500 = kg/packet" : "Paper — Formula: L×W×GSM÷3100 = kg/rim")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.subtitleText)
                        .padding(.horizontal, 20).padding(.vertical, 10)

                    ForEach(displayCats.indices, id: \.self) { ci in
                        let cat = displayCats[ci]

                        // Category header
                        Text(cat.name)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Theme.titleText)
                            .padding(.horizontal, 20).padding(.top, 12).padding(.bottom, 4)

                        ForEach(cat.items.indices, id: \.self) { ii in
                            let item = cat.items[ii]

                            HStack(spacing: 10) {
                                Text(item.name)
                                    .font(.system(size: 13))
                                    .foregroundColor(Theme.titleText)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("PKR \(Int(item.ratePerKg))/kg")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(Theme.subtitleText)

                                // Star
                                Button {
                                    if let realCi = categories.firstIndex(where: { $0.id == cat.id }),
                                       let realIi = categories[realCi].items.firstIndex(where: { $0.id == item.id }) {
                                        categories[realCi].items[realIi].isFavorite.toggle()
                                    }
                                } label: {
                                    Image(systemName: item.isFavorite ? "star.fill" : "star")
                                        .font(.system(size: 13))
                                        .foregroundColor(item.isFavorite ? Theme.dotActive : Theme.subtitleText)
                                        .frame(width: 34, height: 34)
                                        .background(Theme.fieldBackground).cornerRadius(8)
                                }

                                // Select
                                Button {
                                    selectedPaperName = item.name
                                    selectedRatePerKg = item.ratePerKg
                                    selectedGSM       = item.gsm
                                    selectedIsBoard   = isBoard
                                    dismiss()
                                } label: {
                                    Image(systemName: item.name == selectedPaperName ? "checkmark.circle.fill" : "checkmark.circle")
                                        .font(.system(size: 13))
                                        .foregroundColor(item.name == selectedPaperName ? Theme.linkText : Theme.subtitleText)
                                        .frame(width: 34, height: 34)
                                        .background(Theme.fieldBackground).cornerRadius(8)
                                }
                            }
                            .padding(.horizontal, 20).padding(.vertical, 10)

                            Divider().padding(.horizontal, 20)
                        }

                        Spacer(minLength: 4)
                    }

                    Spacer(minLength: 30)
                }
            }
        }
        .background(Theme.cardBackground)
        .navigationBarHidden(true)
    }
}

private struct SectionTab: View {
    let label: String; let isActive: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 14, weight: isActive ? .semibold : .regular))
                .foregroundColor(isActive ? Theme.linkText : Theme.subtitleText)
                .frame(maxWidth: .infinity).padding(.vertical, 10)
                .background(isActive ? Theme.linkText.opacity(0.08) : Color.clear)
                .cornerRadius(10)
        }
    }
}
