// AnalyticsView.swift
// Screens — Pro Feature

import SwiftUI

struct AnalyticsView: View {
    @State private var selectedPeriod = 0
    let periods = ["3M", "6M", "1Y"]

    // Sample monthly revenue data
    let monthlyData: [(month: String, revenue: Double)] = [
        ("Aug", 85000), ("Sep", 112000), ("Oct", 98000),
        ("Nov", 134000), ("Dec", 156000), ("Jan", 142000),
    ]

    let topPaperTypes: [(name: String, percentage: Double, color: Color)] = [
        ("Art Card in Reels", 0.38, Color(hex: "#8B6914")),
        ("Offset Paper",      0.27, Color(hex: "#5B7CDB")),
        ("Bleach Card",       0.20, Color(hex: "#27AE60")),
        ("Bond Paper",        0.15, Color(hex: "#E74C3C")),
    ]

    let topBuyers: [(name: String, revenue: Double)] = [
        ("Raza Traders", 210000),
        ("Ahmed Khan",   145000),
        ("Bilal & Sons",  65000),
        ("Sara Malik",    84000),
    ]

    var maxRevenue: Double { monthlyData.map(\.revenue).max() ?? 1 }

    var body: some View {
        VStack(spacing: 0) {

            // ── Header ───────────────────────────────────────────────────
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("Analytics")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Theme.titleText)
                        ProBadge()
                    }
                    Text("Sales performance overview")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.subtitleText)
                }
                Spacer()
                // Period picker
                HStack(spacing: 0) {
                    ForEach(0..<periods.count, id: \.self) { i in
                        Button { selectedPeriod = i } label: {
                            Text(periods[i])
                                .font(.system(size: 12, weight: selectedPeriod == i ? .semibold : .regular))
                                .foregroundColor(selectedPeriod == i ? .white : Theme.subtitleText)
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(selectedPeriod == i ? Theme.linkText : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                }
                .background(Color(hex: "#F0F0F0"))
                .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // ── KPI row ──────────────────────────────────────────
                    HStack(spacing: 12) {
                        KPICard(label: "Total Revenue", value: "PKR 7.27L", trend: "+18%", up: true)
                        KPICard(label: "Orders",        value: "27",         trend: "+5",   up: true)
                        KPICard(label: "Avg Order",     value: "PKR 26.9K",  trend: "-3%",  up: false)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // ── Revenue bar chart ────────────────────────────────
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Monthly Revenue")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.titleText)

                        HStack(alignment: .bottom, spacing: 8) {
                            ForEach(monthlyData, id: \.month) { item in
                                VStack(spacing: 6) {
                                    Text("₨\(Int(item.revenue/1000))K")
                                        .font(.system(size: 8))
                                        .foregroundColor(Theme.subtitleText)
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Theme.linkText)
                                        .frame(height: CGFloat(item.revenue / maxRevenue) * 120)
                                    Text(item.month)
                                        .font(.system(size: 10))
                                        .foregroundColor(Theme.subtitleText)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 160)
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .padding(.horizontal, 20)

                    // ── Paper type breakdown ─────────────────────────────
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Sales by Paper Type")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.titleText)
                        ForEach(topPaperTypes, id: \.name) { item in
                            VStack(spacing: 6) {
                                HStack {
                                    Text(item.name).font(.system(size: 13)).foregroundColor(Theme.titleText)
                                    Spacer()
                                    Text("\(Int(item.percentage * 100))%")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(item.color)
                                }
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 4).fill(Color(hex: "#F0F0F0")).frame(height: 8)
                                        RoundedRectangle(cornerRadius: 4).fill(item.color)
                                            .frame(width: geo.size.width * item.percentage, height: 8)
                                    }
                                }
                                .frame(height: 8)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .padding(.horizontal, 20)

                    // ── Top buyers ───────────────────────────────────────
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Top Buyers by Revenue")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.titleText)
                        ForEach(Array(topBuyers.enumerated()), id: \.offset) { i, buyer in
                            HStack(spacing: 12) {
                                Text("\(i + 1)")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Theme.subtitleText)
                                    .frame(width: 20)
                                AvatarView(name: buyer.name, size: 34)
                                Text(buyer.name).font(.system(size: 14)).foregroundColor(Theme.titleText)
                                Spacer()
                                Text("PKR \(Int(buyer.revenue).formatted())")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Theme.linkText)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .padding(.horizontal, 20)

                    Spacer(minLength: 40)
                }
            }
            .background(Color(hex: "#F8F8F8"))
        }
        .background(Color(hex: "#F8F8F8"))
        .navigationBarHidden(true)
    }
}

private struct KPICard: View {
    let label: String
    let value: String
    let trend: String
    let up: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.system(size: 10)).foregroundColor(Theme.subtitleText).lineLimit(1).minimumScaleFactor(0.7)
            Text(value).font(.system(size: 14, weight: .bold)).foregroundColor(Theme.titleText).lineLimit(1).minimumScaleFactor(0.7)
            HStack(spacing: 2) {
                Image(systemName: up ? "arrow.up.right" : "arrow.down.right").font(.system(size: 9))
                Text(trend).font(.system(size: 10, weight: .semibold))
            }
            .foregroundColor(up ? Color(hex: "#27AE60") : Color(hex: "#E74C3C"))
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
