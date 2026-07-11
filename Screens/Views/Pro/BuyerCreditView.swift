// BuyerCreditView.swift
// Screens — Pro Feature

import SwiftUI

struct BuyerCredit: Identifiable {
    let id: Int
    var buyerName: String
    var city: String
    var creditScore: Int          // 0–100
    var totalOrders: Int
    var onTimePayments: Int
    var latePayments: Int
    var defaulted: Int
    var avgOrderValue: Double
    var lastOrderDate: String
    var creditLimit: Double       // PKR
}

struct BuyerCreditView: View {
    @State private var buyers: [BuyerCredit] = [
        BuyerCredit(id: 1, buyerName: "Ahmed Khan",   city: "Karachi",   creditScore: 88, totalOrders: 24, onTimePayments: 22, latePayments: 2, defaulted: 0, avgOrderValue: 145000, lastOrderDate: "Jan 20", creditLimit: 500000),
        BuyerCredit(id: 2, buyerName: "Raza Traders", city: "Lahore",    creditScore: 74, totalOrders: 15, onTimePayments: 11, latePayments: 3, defaulted: 1, avgOrderValue: 210000, lastOrderDate: "Jan 18", creditLimit: 300000),
        BuyerCredit(id: 3, buyerName: "Sara Malik",   city: "Islamabad", creditScore: 95, totalOrders: 31, onTimePayments: 31, latePayments: 0, defaulted: 0, avgOrderValue: 84000,  lastOrderDate: "Jan 22", creditLimit: 700000),
        BuyerCredit(id: 4, buyerName: "Bilal & Sons", city: "Faisalabad",creditScore: 52, totalOrders: 9,  onTimePayments: 5,  latePayments: 3, defaulted: 1, avgOrderValue: 65000,  lastOrderDate: "Dec 15", creditLimit: 150000),
    ]
    @State private var selectedBuyer: BuyerCredit? = nil
    @State private var sortBy: CreditSort = .score

    enum CreditSort: String, CaseIterable {
        case score = "Score"
        case name  = "Name"
        case value = "Value"
    }

    var sorted: [BuyerCredit] {
        switch sortBy {
        case .score: return buyers.sorted { $0.creditScore > $1.creditScore }
        case .name:  return buyers.sorted { $0.buyerName < $1.buyerName }
        case .value: return buyers.sorted { $0.avgOrderValue > $1.avgOrderValue }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("Buyer Credit").font(.system(size: 26, weight: .bold)).foregroundColor(Theme.titleText)
                        ProBadge()
                    }
                    Text("Trust scores & payment history")
                        .font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                }
                Spacer()
                // Sort picker
                Menu {
                    ForEach(CreditSort.allCases, id: \.self) { option in
                        Button(option.rawValue) { sortBy = option }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.arrow.down")
                        Text(sortBy.rawValue)
                    }
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.linkText)
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(Theme.linkText.opacity(0.08))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 16)
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // Portfolio summary
                    HStack(spacing: 12) {
                        CreditSummaryCard(label: "Avg Score",   value: "\(buyers.map(\.creditScore).reduce(0,+) / max(1, buyers.count))", color: Theme.linkText)
                        CreditSummaryCard(label: "High Risk",   value: "\(buyers.filter { $0.creditScore < 60 }.count)",                   color: Color(hex: "#E74C3C"))
                        CreditSummaryCard(label: "Excellent",   value: "\(buyers.filter { $0.creditScore >= 85 }.count)",                  color: Color(hex: "#27AE60"))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // Buyer list
                    VStack(spacing: 12) {
                        ForEach(sorted) { buyer in
                            BuyerCreditCard(buyer: buyer) {
                                selectedBuyer = buyer
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 40)
                }
            }
            .background(Color(hex: "#F8F8F8"))
        }
        .background(Color(hex: "#F8F8F8"))
        .navigationBarHidden(true)
        .sheet(item: $selectedBuyer) { buyer in
            BuyerCreditDetailSheet(buyer: buyer)
        }
    }
}

private struct CreditSummaryCard: View {
    let label: String; let value: String; let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.system(size: 22, weight: .bold)).foregroundColor(color)
            Text(label).font(.system(size: 10)).foregroundColor(Theme.subtitleText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white).cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

private struct BuyerCreditCard: View {
    let buyer: BuyerCredit
    let onTap: () -> Void

    var scoreColor: Color {
        switch buyer.creditScore {
        case 85...100: return Color(hex: "#27AE60")
        case 65..<85:  return Color(hex: "#F39C12")
        default:       return Color(hex: "#E74C3C")
        }
    }

    var scoreLabel: String {
        switch buyer.creditScore {
        case 85...100: return "Excellent"
        case 65..<85:  return "Good"
        case 45..<65:  return "Fair"
        default:       return "Poor"
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    AvatarView(name: buyer.buyerName, size: 44)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(buyer.buyerName).font(.system(size: 15, weight: .bold)).foregroundColor(Theme.titleText)
                        Text(buyer.city).font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                    }
                    Spacer()

                    // Score circle
                    ZStack {
                        Circle().stroke(scoreColor.opacity(0.2), lineWidth: 5).frame(width: 52, height: 52)
                        Circle()
                            .trim(from: 0, to: CGFloat(buyer.creditScore) / 100)
                            .stroke(scoreColor, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                            .frame(width: 52, height: 52)
                            .rotationEffect(.degrees(-90))
                        VStack(spacing: 1) {
                            Text("\(buyer.creditScore)").font(.system(size: 14, weight: .bold)).foregroundColor(scoreColor)
                        }
                    }
                }
                .padding(.horizontal, 14).padding(.vertical, 14)

                Divider().padding(.horizontal, 14)

                HStack(spacing: 0) {
                    CreditStat(label: "Orders",    value: "\(buyer.totalOrders)")
                    CreditStat(label: "On Time",   value: "\(buyer.onTimePayments)")
                    CreditStat(label: "Late",      value: "\(buyer.latePayments)",  highlight: buyer.latePayments > 0 ? Color(hex: "#F39C12") : nil)
                    CreditStat(label: "Default",   value: "\(buyer.defaulted)",     highlight: buyer.defaulted > 0 ? Color(hex: "#E74C3C") : nil)
                }
                .padding(.vertical, 10)
            }
            .background(Color.white).cornerRadius(14)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
        }
    }
}

private struct CreditStat: View {
    let label: String
    let value: String
    var highlight: Color? = nil

    var body: some View {
        VStack(spacing: 3) {
            Text(label).font(.system(size: 10)).foregroundColor(Theme.subtitleText)
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(highlight ?? Theme.titleText)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: — Detail Sheet
private struct BuyerCreditDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let buyer: BuyerCredit

    var scoreColor: Color {
        switch buyer.creditScore {
        case 85...100: return Color(hex: "#27AE60")
        case 65..<85:  return Color(hex: "#F39C12")
        case 45..<65:  return Color(hex: "#E74C3C")
        default:       return Color(hex: "#C0392B")
        }
    }

    var scoreLabel: String {
        switch buyer.creditScore {
        case 85...100: return "Excellent"
        case 65..<85:  return "Good"
        case 45..<65:  return "Fair"
        default:       return "Poor"
        }
    }

    var onTimeRate: Double {
        guard buyer.totalOrders > 0 else { return 0 }
        return Double(buyer.onTimePayments) / Double(buyer.totalOrders)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // Score hero
                    VStack(spacing: 12) {
                        ZStack {
                            Circle().stroke(scoreColor.opacity(0.15), lineWidth: 12).frame(width: 120, height: 120)
                            Circle()
                                .trim(from: 0, to: CGFloat(buyer.creditScore) / 100)
                                .stroke(scoreColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(-90))
                            VStack(spacing: 2) {
                                Text("\(buyer.creditScore)").font(.system(size: 32, weight: .bold)).foregroundColor(scoreColor)
                                Text(scoreLabel).font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                            }
                        }
                        Text(buyer.buyerName).font(.system(size: 20, weight: .bold)).foregroundColor(Theme.titleText)
                        Text(buyer.city).font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(Color.white).cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)

                    // Credit limit
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Recommended Credit Limit").font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                            Text("PKR \(Int(buyer.creditLimit/1000))K").font(.system(size: 22, weight: .bold)).foregroundColor(Theme.linkText)
                        }
                        Spacer()
                        Image(systemName: "shield.checkered").font(.system(size: 28)).foregroundColor(Theme.linkText.opacity(0.4))
                    }
                    .padding(16)
                    .background(Color.white).cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

                    // Payment breakdown
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Payment History").font(.system(size: 15, weight: .bold)).foregroundColor(Theme.titleText)

                        DetailRow(label: "Total Orders",      value: "\(buyer.totalOrders)")
                        DetailRow(label: "On-Time Payments",  value: "\(buyer.onTimePayments)", color: Color(hex: "#27AE60"))
                        DetailRow(label: "Late Payments",     value: "\(buyer.latePayments)",   color: buyer.latePayments > 0 ? Color(hex: "#F39C12") : Theme.titleText)
                        DetailRow(label: "Defaults",          value: "\(buyer.defaulted)",      color: buyer.defaulted > 0 ? Color(hex: "#E74C3C") : Theme.titleText)
                        DetailRow(label: "On-Time Rate",      value: "\(Int(onTimeRate * 100))%")
                        DetailRow(label: "Avg Order Value",   value: "PKR \(Int(buyer.avgOrderValue/1000))K")
                        DetailRow(label: "Last Order",        value: buyer.lastOrderDate)

                        // On-time rate bar
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Payment Reliability").font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4).fill(Color(hex: "#F0F0F0")).frame(height: 10)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(scoreColor)
                                        .frame(width: geo.size.width * onTimeRate, height: 10)
                                }
                            }
                            .frame(height: 10)
                        }
                    }
                    .padding(16)
                    .background(Color.white).cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

                    // Risk assessment
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Risk Assessment").font(.system(size: 15, weight: .bold)).foregroundColor(Theme.titleText)
                        Text(riskText).font(.system(size: 13)).foregroundColor(Theme.subtitleText).fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(16)
                    .background(Color.white).cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

                    Spacer(minLength: 20)
                }
                .padding(20)
            }
            .background(Color(hex: "#F8F8F8"))
            .navigationTitle("Credit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }.foregroundColor(Theme.linkText)
                }
            }
        }
    }

    var riskText: String {
        switch buyer.creditScore {
        case 85...100:
            return "This buyer has an excellent payment track record. Low risk — you can confidently extend higher credit limits and priority service."
        case 65..<85:
            return "This buyer generally pays on time with occasional delays. Moderate risk — consider standard credit terms with payment reminders."
        case 45..<65:
            return "This buyer has a mixed payment history. Elevated risk — consider advance payment or smaller order sizes until trust is established."
        default:
            return "This buyer has a poor payment record with defaults. High risk — require advance payment or secure guarantees before fulfilling large orders."
        }
    }
}

private struct DetailRow: View {
    let label: String; let value: String; var color: Color = Theme.titleText
    // Use a static property as a workaround for Theme.titleText in default param
    init(label: String, value: String, color: Color? = nil) {
        self.label = label
        self.value = value
        self.color = color ?? Theme.titleText
    }
    var body: some View {
        HStack {
            Text(label).font(.system(size: 13)).foregroundColor(Theme.subtitleText)
            Spacer()
            Text(value).font(.system(size: 13, weight: .semibold)).foregroundColor(color)
        }
    }
}
