// RecurringOrdersView.swift
// Screens — Pro Feature

import SwiftUI

struct RecurringOrder: Identifiable {
    let id: Int
    var buyerName: String
    var paperType: String
    var quantityKg: Double
    var pricePerKg: Double
    var frequency: String
    var nextOrderDate: String
    var isActive: Bool
}

struct RecurringOrdersView: View {
    @State private var orders: [RecurringOrder] = [
        RecurringOrder(id: 1, buyerName: "Ahmed Khan",   paperType: "Offset Paper",      quantityKg: 500,  pricePerKg: 235, frequency: "Weekly",   nextOrderDate: "Jan 27", isActive: true),
        RecurringOrder(id: 2, buyerName: "Raza Traders", paperType: "Art Card in Reels", quantityKg: 1000, pricePerKg: 240, frequency: "Monthly",  nextOrderDate: "Feb 1",  isActive: true),
        RecurringOrder(id: 3, buyerName: "Sara Malik",   paperType: "Bleach Card",       quantityKg: 250,  pricePerKg: 255, frequency: "Bi-weekly",nextOrderDate: "Feb 3",  isActive: false),
    ]
    @State private var showAdd = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("Recurring Orders").font(.system(size: 22, weight: .bold)).foregroundColor(Theme.titleText)
                        ProBadge()
                    }
                    Text("Auto-generate standing orders")
                        .font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                }
                Spacer()
                Button { showAdd = true } label: {
                    Image(systemName: "plus").font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white).frame(width: 36, height: 36)
                        .background(Theme.linkText).cornerRadius(10)
                }
            }
            .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 16)
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach($orders) { $order in
                        RecurringOrderCard(order: $order)
                    }
                }
                .padding(.horizontal, 20).padding(.top, 16)
                Spacer(minLength: 40)
            }
            .background(Color(hex: "#F8F8F8"))
        }
        .background(Color(hex: "#F8F8F8"))
        .navigationBarHidden(true)
        .sheet(isPresented: $showAdd) { Text("New Recurring Order — Coming Soon").padding() }
    }
}

private struct RecurringOrderCard: View {
    @Binding var order: RecurringOrder
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                AvatarView(name: order.buyerName, size: 40)
                VStack(alignment: .leading, spacing: 3) {
                    Text(order.buyerName).font(.system(size: 15, weight: .bold)).foregroundColor(Theme.titleText)
                    Text(order.paperType).font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                }
                Spacer()
                Toggle("", isOn: $order.isActive).tint(Theme.linkText).labelsHidden()
            }
            .padding(.horizontal, 14).padding(.top, 14)

            Divider().padding(.horizontal, 14).padding(.top, 10)

            HStack(spacing: 0) {
                RecurStat(label: "Qty",       value: "\(Int(order.quantityKg)) kg")
                RecurStat(label: "Rate",      value: "PKR \(Int(order.pricePerKg))/kg")
                RecurStat(label: "Frequency", value: order.frequency)
                RecurStat(label: "Next Due",  value: order.nextOrderDate)
            }
            .padding(.vertical, 12)
        }
        .background(Color.white).cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
        .opacity(order.isActive ? 1 : 0.5)
    }
}

private struct RecurStat: View {
    let label: String; let value: String
    var body: some View {
        VStack(spacing: 3) {
            Text(label).font(.system(size: 10)).foregroundColor(Theme.subtitleText)
            Text(value).font(.system(size: 12, weight: .semibold)).foregroundColor(Theme.titleText).lineLimit(1).minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
    }
}
