// PriceHistoryView.swift
// Screens — Pro Feature

import SwiftUI

struct PriceHistoryView: View {
    @State private var selectedPaper = "Art Card in Reels"
    let papers = ["Art Card in Reels", "Offset Paper", "Bleach Card", "Bond Paper"]

    let priceData: [String: [(month: String, rate: Double)]] = [
        "Art Card in Reels": [
            ("Aug", 228), ("Sep", 233), ("Oct", 238), ("Nov", 242), ("Dec", 245), ("Jan", 240),
        ],
        "Offset Paper": [
            ("Aug", 218), ("Sep", 220), ("Oct", 225), ("Nov", 228), ("Dec", 230), ("Jan", 235),
        ],
        "Bleach Card": [
            ("Aug", 248), ("Sep", 252), ("Oct", 255), ("Nov", 258), ("Dec", 260), ("Jan", 255),
        ],
        "Bond Paper": [
            ("Aug", 258), ("Sep", 262), ("Oct", 265), ("Nov", 268), ("Dec", 272), ("Jan", 270),
        ],
    ]

    var currentData: [(month: String, rate: Double)] {
        priceData[selectedPaper] ?? []
    }

    var minRate: Double { (currentData.map(\.rate).min() ?? 200) - 10 }
    var maxRate: Double { (currentData.map(\.rate).max() ?? 300) + 10 }
    var rangeRate: Double { maxRate - minRate }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("Price History").font(.system(size: 26, weight: .bold)).foregroundColor(Theme.titleText)
                        ProBadge()
                    }
                    Text("Rate trends by paper type")
                        .font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                }
                Spacer()
            }
            .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 16)
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // Paper selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(papers, id: \.self) { paper in
                                Button { selectedPaper = paper } label: {
                                    Text(paper)
                                        .font(.system(size: 13, weight: selectedPaper == paper ? .semibold : .regular))
                                        .foregroundColor(selectedPaper == paper ? .white : Theme.subtitleText)
                                        .padding(.horizontal, 14).padding(.vertical, 8)
                                        .background(selectedPaper == paper ? Theme.linkText : Color.white)
                                        .cornerRadius(20)
                                        .overlay(RoundedRectangle(cornerRadius: 20)
                                            .stroke(selectedPaper == paper ? Theme.linkText : Theme.fieldBorder, lineWidth: 1))
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 16)

                    // Current stats
                    HStack(spacing: 12) {
                        PriceStatCard(label: "Current Rate",  value: "PKR \(Int(currentData.last?.rate ?? 0))/kg", color: Theme.linkText)
                        PriceStatCard(label: "6M High",       value: "PKR \(Int(maxRate - 10))/kg",                color: Color(hex: "#27AE60"))
                        PriceStatCard(label: "6M Low",        value: "PKR \(Int(minRate + 10))/kg",                color: Color(hex: "#E74C3C"))
                    }
                    .padding(.horizontal, 20)

                    // Line chart
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Rate Trend (PKR/kg)")
                            .font(.system(size: 15, weight: .bold)).foregroundColor(Theme.titleText)

                        GeometryReader { geo in
                            ZStack {
                                // Grid lines
                                VStack(spacing: 0) {
                                    ForEach(0..<4) { _ in
                                        Spacer()
                                        Rectangle().fill(Color(hex: "#F0F0F0")).frame(height: 1)
                                    }
                                }

                                // Line
                                Path { path in
                                    for (i, point) in currentData.enumerated() {
                                        let x = geo.size.width * CGFloat(i) / CGFloat(currentData.count - 1)
                                        let y = geo.size.height * (1 - CGFloat((point.rate - minRate) / rangeRate))
                                        if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                                        else { path.addLine(to: CGPoint(x: x, y: y)) }
                                    }
                                }
                                .stroke(Theme.linkText, lineWidth: 2.5)

                                // Dots
                                ForEach(Array(currentData.enumerated()), id: \.offset) { i, point in
                                    let x = geo.size.width * CGFloat(i) / CGFloat(currentData.count - 1)
                                    let y = geo.size.height * (1 - CGFloat((point.rate - minRate) / rangeRate))
                                    Circle().fill(Theme.linkText).frame(width: 8, height: 8)
                                        .position(x: x, y: y)
                                }
                            }
                        }
                        .frame(height: 150)

                        // X-axis labels
                        HStack {
                            ForEach(currentData, id: \.month) { point in
                                Text(point.month).font(.system(size: 10)).foregroundColor(Theme.subtitleText)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white).cornerRadius(14)
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

private struct PriceStatCard: View {
    let label: String; let value: String; let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.system(size: 10)).foregroundColor(Theme.subtitleText)
            Text(value).font(.system(size: 13, weight: .bold)).foregroundColor(color).lineLimit(1).minimumScaleFactor(0.7)
        }
        .padding(12).frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white).cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
