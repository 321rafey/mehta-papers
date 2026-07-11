// RateAlertsView.swift
// Screens — Pro Feature

import SwiftUI

struct RateAlert: Identifiable {
    let id: Int
    var paperType: String
    var targetRate: Double
    var condition: AlertCondition
    var isActive: Bool
    var lastTriggered: String?
}

enum AlertCondition: String, CaseIterable {
    case above = "Above"
    case below = "Below"
}

struct RateAlertsView: View {
    @State private var alerts: [RateAlert] = [
        RateAlert(id: 1, paperType: "Art Card in Reels", targetRate: 250, condition: .above,  isActive: true,  lastTriggered: "Jan 18"),
        RateAlert(id: 2, paperType: "Offset Paper",      targetRate: 220, condition: .below,  isActive: true,  lastTriggered: nil),
        RateAlert(id: 3, paperType: "Bleach Card",       targetRate: 260, condition: .above,  isActive: false, lastTriggered: "Jan 5"),
    ]
    @State private var showAddAlert = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("Rate Alerts").font(.system(size: 26, weight: .bold)).foregroundColor(Theme.titleText)
                        ProBadge()
                    }
                    Text("Get notified when buyers hit your target")
                        .font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                }
                Spacer()
                Button { showAddAlert = true } label: {
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
                    ForEach($alerts) { $alert in
                        RateAlertCard(alert: $alert)
                    }
                }
                .padding(.horizontal, 20).padding(.top, 16)
                Spacer(minLength: 40)
            }
            .background(Color(hex: "#F8F8F8"))
        }
        .background(Color(hex: "#F8F8F8"))
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddAlert) { AddAlertSheet() }
    }
}

private struct RateAlertCard: View {
    @Binding var alert: RateAlert
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(alert.isActive ? Theme.linkText.opacity(0.1) : Color(hex: "#F0F0F0")).frame(width: 44, height: 44)
                Image(systemName: "bell.fill").font(.system(size: 18))
                    .foregroundColor(alert.isActive ? Theme.linkText : Theme.subtitleText)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(alert.paperType).font(.system(size: 14, weight: .semibold)).foregroundColor(Theme.titleText)
                HStack(spacing: 4) {
                    Text(alert.condition.rawValue).font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                    Text("PKR \(Int(alert.targetRate))/kg").font(.system(size: 12, weight: .semibold)).foregroundColor(Theme.linkText)
                }
                if let last = alert.lastTriggered {
                    Text("Last triggered: \(last)").font(.system(size: 10)).foregroundColor(Theme.subtitleText)
                } else {
                    Text("Never triggered").font(.system(size: 10)).foregroundColor(Theme.subtitleText)
                }
            }
            Spacer()
            Toggle("", isOn: $alert.isActive).tint(Theme.linkText).labelsHidden()
        }
        .padding(14)
        .background(Color.white).cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

private struct AddAlertSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var paperType = ""
    @State private var rate = ""
    @State private var condition = AlertCondition.above

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Paper Type").font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                    TextField("e.g. Art Card in Reels", text: $paperType)
                        .padding(12).background(Color(hex: "#F5F5F5")).cornerRadius(10)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Target Rate (PKR/kg)").font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                    TextField("e.g. 250", text: $rate).keyboardType(.numberPad)
                        .padding(12).background(Color(hex: "#F5F5F5")).cornerRadius(10)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Trigger When Rate Is").font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                    Picker("Condition", selection: $condition) {
                        ForEach(AlertCondition.allCases, id: \.self) { c in Text(c.rawValue).tag(c) }
                    }
                    .pickerStyle(.segmented)
                }
                Spacer()
                Button { dismiss() } label: {
                    Text("Create Alert").font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                        .frame(maxWidth: .infinity).frame(height: 52).background(Theme.linkText).cornerRadius(14)
                }
            }
            .padding(20)
            .navigationTitle("New Rate Alert")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() }.foregroundColor(Theme.linkText) } }
        }
    }
}
