// OrdersView.swift
// Screens
//
// Orders tab — shows all seller-created orders with status badges.
// Tapping a deal card opens OrderDetailView via NavigationStack push.

import SwiftUI

// MARK: - Orders View
struct OrdersView: View {
    @State private var orders: [SellerOrder] = SampleData.sellerOrders
    @State private var filterStatus: SellerOrderStatus? = nil   // nil = All

    var filtered: [SellerOrder] {
        guard let f = filterStatus else { return orders }
        return orders.filter { $0.status == f }
    }

    var completedCount: Int { orders.filter { $0.status == .completed }.count }
    var ongoingCount:   Int { orders.filter { $0.status == .ongoing   }.count }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // ── Header ───────────────────────────────────────────────
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Orders")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Theme.titleText)
                        Text("Manage your deals")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.subtitleText)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
                .background(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {

                        // ── Summary card ─────────────────────────────────
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .fill(LinearGradient(
                                    colors: [Color(hex: "#D8CEB8"), Color(hex: "#C8B890")],
                                    startPoint: .topLeading, endPoint: .bottomTrailing))

                            GeometryReader { geo in
                                ZStack {
                                    OrdTriangle()
                                        .fill(Color.white.opacity(0.3))
                                        .frame(width: 90, height: 90)
                                        .offset(x: geo.size.width - 95, y: -15)
                                    OrdTriangle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 65, height: 65)
                                        .rotationEffect(.degrees(180))
                                        .offset(x: geo.size.width - 80, y: 60)
                                    OrdTriangle()
                                        .fill(Color(hex: "#8A7850").opacity(0.4))
                                        .frame(width: 50, height: 50)
                                        .offset(x: geo.size.width - 55, y: 40)
                                }
                            }

                            HStack(spacing: 0) {
                                OrdSummaryCell(value: "\(orders.count)",   label: "Total")
                                OrdSummaryCell(value: "\(ongoingCount)",   label: "Ongoing")
                                OrdSummaryCell(value: "\(completedCount)", label: "Completed")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                        }
                        .frame(height: 100)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)

                        // ── Filter pills ─────────────────────────────────
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                OrdFilterPill(label: "All",       active: filterStatus == nil)       { filterStatus = nil }
                                OrdFilterPill(label: "Ongoing",   active: filterStatus == .ongoing)  { filterStatus = .ongoing }
                                OrdFilterPill(label: "Completed", active: filterStatus == .completed){ filterStatus = .completed }
                                OrdFilterPill(label: "Cancelled", active: filterStatus == .cancelled){ filterStatus = .cancelled }
                            }
                            .padding(.horizontal, 20)
                        }

                        // ── Deal list ────────────────────────────────────
                        if filtered.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "tray")
                                    .font(.system(size: 36))
                                    .foregroundColor(Theme.subtitleText.opacity(0.3))
                                Text("No orders here")
                                    .font(.system(size: 15))
                                    .foregroundColor(Theme.subtitleText)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        } else {
                            VStack(spacing: 12) {
                                ForEach($orders) { $order in
                                    if filterStatus == nil || order.status == filterStatus {
                                        NavigationLink(destination: OrderDetailView(order: $order)) {
                                            DealCardView(order: order)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }

                        Spacer(minLength: 40)
                    }
                }
                .background(Color(hex: "#F8F8F8"))
            }
            .background(Color(hex: "#F8F8F8"))
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Triangle watermark shape (local to Orders)
private struct OrdTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

// MARK: - Summary cell
private struct OrdSummaryCell: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.titleText)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Theme.titleText.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Filter pill
private struct OrdFilterPill: View {
    let label: String
    let active: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: active ? .semibold : .regular))
                .foregroundColor(active ? .white : Theme.subtitleText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(active ? Theme.linkText : Color.white)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(active ? Theme.linkText : Theme.fieldBorder, lineWidth: 1))
        }
    }
}

// MARK: - Deal card (uses SellerOrder)
struct DealCardView: View {
    let order: SellerOrder

    var statusColor: Color {
        switch order.status {
        case .ongoing:   return Color(hex: "#F39C12")
        case .cancelled: return Color(hex: "#E74C3C")
        case .completed: return Color(hex: "#27AE60")
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Theme.titleText)
                    Text(order.buyerName)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.subtitleText)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    HStack(spacing: 4) {
                        Circle().fill(statusColor).frame(width: 6, height: 6)
                        Text(order.status.rawValue)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(statusColor)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.1))
                    .cornerRadius(12)

                    Text(order.totalAmount)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.linkText)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)

            Divider().padding(.horizontal, 16)

            HStack(spacing: 16) {
                Label(order.paperType, systemImage: "doc.text")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.subtitleText)
                Label("\(order.quantity) reels", systemImage: "number")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.subtitleText)
                Spacer()
                Text(order.date)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.subtitleText.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}
