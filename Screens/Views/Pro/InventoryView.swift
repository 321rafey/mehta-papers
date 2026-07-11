// InventoryView.swift
// Screens — Pro Feature

import SwiftUI

struct InventoryItem: Identifiable {
    let id: Int
    var paperType: String
    var gsm: String
    var stockKg: Double
    var reorderLevel: Double
    var lastUpdated: String
    var isLow: Bool { stockKg <= reorderLevel }
}

struct InventoryView: View {
    @State private var inventory: [InventoryItem] = [
        InventoryItem(id: 1, paperType: "Art Card in Reels", gsm: "300 GSM", stockKg: 850,  reorderLevel: 500, lastUpdated: "Jan 20"),
        InventoryItem(id: 2, paperType: "Offset Paper",      gsm: "60 GSM",  stockKg: 320,  reorderLevel: 400, lastUpdated: "Jan 18"),
        InventoryItem(id: 3, paperType: "Bleach Card",       gsm: "350 GSM", stockKg: 1200, reorderLevel: 300, lastUpdated: "Jan 15"),
        InventoryItem(id: 4, paperType: "Bond Paper",        gsm: "80 GSM",  stockKg: 180,  reorderLevel: 250, lastUpdated: "Jan 10"),
        InventoryItem(id: 5, paperType: "Newsprint",         gsm: "45 GSM",  stockKg: 600,  reorderLevel: 200, lastUpdated: "Dec 28"),
    ]
    @State private var showAddItem = false

    var lowStockCount: Int { inventory.filter(\.isLow).count }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("Inventory").font(.system(size: 26, weight: .bold)).foregroundColor(Theme.titleText)
                        ProBadge()
                    }
                    Text("Stock levels by paper type")
                        .font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                }
                Spacer()
                Button { showAddItem = true } label: {
                    Image(systemName: "plus").font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white).frame(width: 36, height: 36)
                        .background(Theme.linkText).cornerRadius(10)
                }
            }
            .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 16)
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    if lowStockCount > 0 {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(Color(hex: "#E74C3C"))
                            Text("\(lowStockCount) item\(lowStockCount > 1 ? "s" : "") below reorder level")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "#E74C3C"))
                            Spacer()
                        }
                        .padding(14)
                        .background(Color(hex: "#E74C3C").opacity(0.08))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    }

                    VStack(spacing: 12) {
                        ForEach($inventory) { $item in
                            InventoryCard(item: $item)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, lowStockCount == 0 ? 16 : 0)

                    Spacer(minLength: 40)
                }
            }
            .background(Color(hex: "#F8F8F8"))
        }
        .background(Color(hex: "#F8F8F8"))
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddItem) {
            Text("Add Inventory Item — Coming Soon").padding()
        }
    }
}

private struct InventoryCard: View {
    @Binding var item: InventoryItem

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.paperType).font(.system(size: 15, weight: .bold)).foregroundColor(Theme.titleText)
                    Text(item.gsm).font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                }
                Spacer()
                if item.isLow {
                    Text("LOW STOCK")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color(hex: "#E74C3C"))
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal, 14).padding(.top, 14)

            HStack(spacing: 0) {
                InvStat(label: "In Stock",      value: "\(Int(item.stockKg)) kg")
                InvStat(label: "Reorder At",    value: "\(Int(item.reorderLevel)) kg")
                InvStat(label: "Last Updated",  value: item.lastUpdated)
            }
            .padding(.vertical, 12)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color(hex: "#F0F0F0")).frame(height: 6)
                    Rectangle()
                        .fill(item.isLow ? Color(hex: "#E74C3C") : Color(hex: "#27AE60"))
                        .frame(width: min(geo.size.width * CGFloat(item.stockKg / (item.reorderLevel * 3)), geo.size.width), height: 6)
                }
                .cornerRadius(3)
            }
            .frame(height: 6)
            .padding(.horizontal, 14).padding(.bottom, 14)
        }
        .background(Color.white).cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

private struct InvStat: View {
    let label: String; let value: String
    var body: some View {
        VStack(spacing: 3) {
            Text(label).font(.system(size: 10)).foregroundColor(Theme.subtitleText)
            Text(value).font(.system(size: 13, weight: .semibold)).foregroundColor(Theme.titleText)
        }
        .frame(maxWidth: .infinity)
    }
}
