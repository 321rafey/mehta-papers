// LedgerView.swift
// Screens — Pro Feature
//
// Full bookkeeping ledger for managing accounts and tracking payments.

import SwiftUI

// MARK: - Ledger Models
struct LedgerAccount: Identifiable {
    let id: Int
    let buyerName: String
    var totalOrders: Int
    var totalValue: Double
    var amountPaid: Double
    var amountDue: Double { totalValue - amountPaid }
    var lastTransaction: String
}

struct LedgerTransaction: Identifiable {
    let id: Int
    let date: String
    let buyerName: String
    let description: String
    let amount: Double
    let type: TransactionType
}

enum TransactionType {
    case credit, debit
}

// MARK: - Ledger View
struct LedgerView: View {
    @State private var selectedTab = 0
    @State private var showAddTransaction = false

    let accounts: [LedgerAccount] = [
        LedgerAccount(id: 1, buyerName: "Ahmed Khan",   totalOrders: 12, totalValue: 145000, amountPaid: 120000, lastTransaction: "Jan 20, 2026"),
        LedgerAccount(id: 2, buyerName: "Sara Malik",   totalOrders: 7,  totalValue: 84000,  amountPaid: 84000,  lastTransaction: "Jan 15, 2026"),
        LedgerAccount(id: 3, buyerName: "Raza Traders", totalOrders: 5,  totalValue: 210000, amountPaid: 150000, lastTransaction: "Jan 10, 2026"),
        LedgerAccount(id: 4, buyerName: "Bilal & Sons", totalOrders: 3,  totalValue: 65000,  amountPaid: 30000,  lastTransaction: "Dec 28, 2025"),
    ]

    let transactions: [LedgerTransaction] = [
        LedgerTransaction(id: 1, date: "Jan 20", buyerName: "Ahmed Khan",   description: "Packages Order — partial payment",    amount: 50000, type: .credit),
        LedgerTransaction(id: 2, date: "Jan 18", buyerName: "Raza Traders", description: "Bulk Order — advance",                amount: 80000, type: .credit),
        LedgerTransaction(id: 3, date: "Jan 15", buyerName: "Sara Malik",   description: "Small Order — full payment",          amount: 84000, type: .credit),
        LedgerTransaction(id: 4, date: "Jan 12", buyerName: "Bilal & Sons", description: "Express Order — deposit",             amount: 30000, type: .credit),
        LedgerTransaction(id: 5, date: "Jan 10", buyerName: "Ahmed Khan",   description: "Packages Order — balance due",        amount: 25000, type: .debit),
        LedgerTransaction(id: 6, date: "Dec 28", buyerName: "Raza Traders", description: "Wholesale Order — remaining balance", amount: 60000, type: .debit),
    ]

    var totalReceivable: Double { accounts.reduce(0) { $0 + $1.amountDue } }
    var totalCollected: Double  { accounts.reduce(0) { $0 + $1.amountPaid } }

    var body: some View {
        VStack(spacing: 0) {

            // ── Header ───────────────────────────────────────────────────
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("Ledger")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Theme.titleText)
                        ProBadge()
                    }
                    Text("Bookkeeping & Accounts")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.subtitleText)
                }
                Spacer()
                Button { showAddTransaction = true } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Theme.linkText)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            .background(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // ── Summary cards ────────────────────────────────────
                    HStack(spacing: 12) {
                        LedgerSummaryCard(
                            label: "Total Collected",
                            amount: totalCollected,
                            color: Color(hex: "#27AE60"),
                            icon: "arrow.down.circle.fill")
                        LedgerSummaryCard(
                            label: "Outstanding",
                            amount: totalReceivable,
                            color: Color(hex: "#E74C3C"),
                            icon: "clock.fill")
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // ── Tab toggle ───────────────────────────────────────
                    HStack(spacing: 0) {
                        LedgerTabBtn(title: "Accounts", selected: selectedTab == 0) { selectedTab = 0 }
                        LedgerTabBtn(title: "Transactions", selected: selectedTab == 1) { selectedTab = 1 }
                    }
                    .background(Color(hex: "#EFEFEF"))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)

                    // ── Content ──────────────────────────────────────────
                    if selectedTab == 0 {
                        VStack(spacing: 12) {
                            ForEach(accounts) { account in
                                LedgerAccountCard(account: account)
                            }
                        }
                        .padding(.horizontal, 20)
                    } else {
                        VStack(spacing: 10) {
                            ForEach(transactions) { tx in
                                LedgerTransactionRow(transaction: tx)
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
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionSheet()
        }
    }
}

// MARK: - Summary Card
private struct LedgerSummaryCard: View {
    let label: String
    let amount: Double
    let color: Color
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.subtitleText)
                Text("PKR \(Int(amount).formatted())")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Theme.titleText)
            }
            Spacer()
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Account Card
private struct LedgerAccountCard: View {
    let account: LedgerAccount

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                AvatarView(name: account.buyerName, size: 38)
                VStack(alignment: .leading, spacing: 2) {
                    Text(account.buyerName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Theme.titleText)
                    Text("\(account.totalOrders) orders · Last: \(account.lastTransaction)")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.subtitleText)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("PKR \(Int(account.amountDue).formatted())")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(account.amountDue > 0 ? Color(hex: "#E74C3C") : Color(hex: "#27AE60"))
                    Text(account.amountDue > 0 ? "Outstanding" : "Settled")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.subtitleText)
                }
            }
            .padding(14)

            // Payment progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color(hex: "#F0F0F0")).frame(height: 4)
                    Rectangle()
                        .fill(Color(hex: "#27AE60"))
                        .frame(width: geo.size.width * CGFloat(account.amountPaid / account.totalValue), height: 4)
                }
                .cornerRadius(2)
            }
            .frame(height: 4)
            .padding(.horizontal, 14)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Transaction Row
private struct LedgerTransactionRow: View {
    let transaction: LedgerTransaction

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(transaction.type == .credit
                          ? Color(hex: "#27AE60").opacity(0.1)
                          : Color(hex: "#E74C3C").opacity(0.1))
                    .frame(width: 38, height: 38)
                Image(systemName: transaction.type == .credit ? "arrow.down" : "arrow.up")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(transaction.type == .credit ? Color(hex: "#27AE60") : Color(hex: "#E74C3C"))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.buyerName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.titleText)
                Text(transaction.description)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.subtitleText)
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(transaction.type == .credit ? "+" : "-")PKR \(Int(transaction.amount).formatted())")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(transaction.type == .credit ? Color(hex: "#27AE60") : Color(hex: "#E74C3C"))
                Text(transaction.date)
                    .font(.system(size: 10))
                    .foregroundColor(Theme.subtitleText)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Tab Button
private struct LedgerTabBtn: View {
    let title: String
    let selected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: selected ? .semibold : .regular))
                .foregroundColor(selected ? Theme.titleText : Theme.subtitleText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selected ? Color.white : Color.clear)
                .cornerRadius(8)
                .padding(3)
        }
    }
}

// MARK: - Add Transaction Sheet
private struct AddTransactionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var buyerName = ""
    @State private var amount = ""
    @State private var description = ""
    @State private var isCredit = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Buyer Name").font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                    TextField("e.g. Ahmed Khan", text: $buyerName)
                        .padding(12).background(Color(hex: "#F5F5F5")).cornerRadius(10)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount (PKR)").font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                    TextField("e.g. 50000", text: $amount).keyboardType(.numberPad)
                        .padding(12).background(Color(hex: "#F5F5F5")).cornerRadius(10)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description").font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                    TextField("e.g. Partial payment for January order", text: $description)
                        .padding(12).background(Color(hex: "#F5F5F5")).cornerRadius(10)
                }
                HStack(spacing: 12) {
                    Button { isCredit = true } label: {
                        Label("Payment Received", systemImage: "arrow.down")
                            .font(.system(size: 13, weight: isCredit ? .semibold : .regular))
                            .foregroundColor(isCredit ? .white : Theme.subtitleText)
                            .frame(maxWidth: .infinity).padding(.vertical, 12)
                            .background(isCredit ? Color(hex: "#27AE60") : Color(hex: "#F0F0F0"))
                            .cornerRadius(10)
                    }
                    Button { isCredit = false } label: {
                        Label("Amount Due", systemImage: "arrow.up")
                            .font(.system(size: 13, weight: !isCredit ? .semibold : .regular))
                            .foregroundColor(!isCredit ? .white : Theme.subtitleText)
                            .frame(maxWidth: .infinity).padding(.vertical, 12)
                            .background(!isCredit ? Color(hex: "#E74C3C") : Color(hex: "#F0F0F0"))
                            .cornerRadius(10)
                    }
                }
                Spacer()
                Button { dismiss() } label: {
                    Text("Save Transaction")
                        .font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                        .frame(maxWidth: .infinity).frame(height: 52)
                        .background(Theme.linkText).cornerRadius(14)
                }
            }
            .padding(20)
            .navigationTitle("New Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundColor(Theme.linkText)
                }
            }
        }
    }
}

// MARK: - Pro Badge (reusable)
struct ProBadge: View {
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "star.fill").font(.system(size: 8))
            Text("PRO").font(.system(size: 9, weight: .bold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 7)
        .padding(.vertical, 3)
        .background(Theme.linkText)
        .cornerRadius(6)
    }
}
