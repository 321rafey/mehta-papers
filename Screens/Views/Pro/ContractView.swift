// ContractView.swift
// Screens — Pro Feature

import SwiftUI

struct PaperContract: Identifiable {
    let id: Int
    var buyerName: String
    var paperType: String
    var quantityKg: Double
    var pricePerKg: Double
    var deliveryDate: String
    var status: ContractStatus
    var createdDate: String
}

enum ContractStatus: String {
    case draft    = "Draft"
    case sent     = "Sent"
    case signed   = "Signed"
    case expired  = "Expired"

    var color: Color {
        switch self {
        case .draft:   return Color(hex: "#5B7CDB")
        case .sent:    return Color(hex: "#F39C12")
        case .signed:  return Color(hex: "#27AE60")
        case .expired: return Color(hex: "#E74C3C")
        }
    }
}

struct ContractView: View {
    @State private var contracts: [PaperContract] = [
        PaperContract(id: 1, buyerName: "Ahmed Khan",    paperType: "Offset Paper",      quantityKg: 2000, pricePerKg: 235, deliveryDate: "Feb 10", status: .signed,  createdDate: "Jan 15"),
        PaperContract(id: 2, buyerName: "Raza Traders",  paperType: "Art Card in Reels", quantityKg: 5000, pricePerKg: 240, deliveryDate: "Feb 28", status: .sent,    createdDate: "Jan 20"),
        PaperContract(id: 3, buyerName: "Sara Malik",    paperType: "Bleach Card",       quantityKg: 1000, pricePerKg: 255, deliveryDate: "Mar 5",  status: .draft,   createdDate: "Jan 22"),
        PaperContract(id: 4, buyerName: "Bilal & Sons",  paperType: "Bond Paper",        quantityKg: 800,  pricePerKg: 270, deliveryDate: "Jan 30", status: .expired, createdDate: "Dec 20"),
    ]
    @State private var showNewContract = false
    @State private var selectedFilter: ContractStatus? = nil

    var filtered: [PaperContract] {
        guard let f = selectedFilter else { return contracts }
        return contracts.filter { $0.status == f }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("Contracts").font(.system(size: 26, weight: .bold)).foregroundColor(Theme.titleText)
                        ProBadge()
                    }
                    Text("Generate & manage trade agreements")
                        .font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                }
                Spacer()
                Button { showNewContract = true } label: {
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

                    // Status filter pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ContractFilterPill(label: "All", isSelected: selectedFilter == nil) {
                                selectedFilter = nil
                            }
                            ForEach([ContractStatus.draft, .sent, .signed, .expired], id: \.rawValue) { status in
                                ContractFilterPill(label: status.rawValue, isSelected: selectedFilter == status) {
                                    selectedFilter = selectedFilter == status ? nil : status
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 16)

                    // Summary strip
                    HStack(spacing: 12) {
                        ContractStatStrip(label: "Total",   value: "\(contracts.count)",                              color: Theme.titleText)
                        ContractStatStrip(label: "Signed",  value: "\(contracts.filter { $0.status == .signed }.count)",  color: Color(hex: "#27AE60"))
                        ContractStatStrip(label: "Pending", value: "\(contracts.filter { $0.status == .sent }.count)",    color: Color(hex: "#F39C12"))
                        ContractStatStrip(label: "Draft",   value: "\(contracts.filter { $0.status == .draft }.count)",   color: Color(hex: "#5B7CDB"))
                    }
                    .padding(.horizontal, 20)

                    // Contract list
                    VStack(spacing: 12) {
                        ForEach(filtered) { contract in
                            ContractCard(contract: contract)
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
        .sheet(isPresented: $showNewContract) { NewContractSheet() }
    }
}

private struct ContractFilterPill: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : Theme.subtitleText)
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(isSelected ? Theme.linkText : Color.white)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Theme.linkText : Theme.fieldBorder, lineWidth: 1))
        }
    }
}

private struct ContractStatStrip: View {
    let label: String; let value: String; let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.system(size: 18, weight: .bold)).foregroundColor(color)
            Text(label).font(.system(size: 10)).foregroundColor(Theme.subtitleText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white).cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

private struct ContractCard: View {
    let contract: PaperContract
    @State private var showDetail = false

    var totalValue: Double { contract.quantityKg * contract.pricePerKg }

    var body: some View {
        Button { showDetail = true } label: {
            VStack(spacing: 0) {
                HStack {
                    AvatarView(name: contract.buyerName, size: 40)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(contract.buyerName).font(.system(size: 15, weight: .bold)).foregroundColor(Theme.titleText)
                        Text(contract.paperType).font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                    }
                    Spacer()
                    Text(contract.status.rawValue)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(contract.status.color)
                        .padding(.horizontal, 10).padding(.vertical, 4)
                        .background(contract.status.color.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 14).padding(.top, 14)

                Divider().padding(.horizontal, 14).padding(.top, 10)

                HStack(spacing: 0) {
                    ContractInfoCell(label: "Qty",       value: "\(Int(contract.quantityKg)) kg")
                    ContractInfoCell(label: "Rate",      value: "PKR \(Int(contract.pricePerKg))")
                    ContractInfoCell(label: "Value",     value: "PKR \(Int(totalValue/1000))K")
                    ContractInfoCell(label: "Delivery",  value: contract.deliveryDate)
                }
                .padding(.vertical, 12)
            }
            .background(Color.white).cornerRadius(14)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
        }
        .sheet(isPresented: $showDetail) { ContractDetailSheet(contract: contract) }
    }
}

private struct ContractInfoCell: View {
    let label: String; let value: String
    var body: some View {
        VStack(spacing: 3) {
            Text(label).font(.system(size: 10)).foregroundColor(Theme.subtitleText)
            Text(value).font(.system(size: 12, weight: .semibold)).foregroundColor(Theme.titleText).lineLimit(1).minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: — Contract Detail Sheet
private struct ContractDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let contract: PaperContract
    @State private var showShareAlert = false

    var totalValue: Double { contract.quantityKg * contract.pricePerKg }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // Contract header card
                    VStack(spacing: 14) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("SALES CONTRACT").font(.system(size: 11, weight: .bold)).foregroundColor(Theme.subtitleText)
                                Text("Mehtah Papers").font(.system(size: 20, weight: .bold)).foregroundColor(Theme.titleText)
                            }
                            Spacer()
                            Image(systemName: "doc.text.fill").font(.system(size: 32)).foregroundColor(Theme.linkText)
                        }

                        Divider()

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Contract Date").font(.system(size: 11)).foregroundColor(Theme.subtitleText)
                                Text(contract.createdDate).font(.system(size: 13, weight: .semibold)).foregroundColor(Theme.titleText)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Delivery Date").font(.system(size: 11)).foregroundColor(Theme.subtitleText)
                                Text(contract.deliveryDate).font(.system(size: 13, weight: .semibold)).foregroundColor(Theme.titleText)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white).cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

                    // Parties
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Parties").font(.system(size: 15, weight: .bold)).foregroundColor(Theme.titleText)
                        HStack(spacing: 16) {
                            PartyBox(role: "SELLER", name: "Mehtah Papers", detail: "Lahore, Pakistan")
                            Image(systemName: "arrow.right").foregroundColor(Theme.subtitleText)
                            PartyBox(role: "BUYER", name: contract.buyerName, detail: "Karachi, Pakistan")
                        }
                    }
                    .padding(16)
                    .background(Color.white).cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

                    // Terms
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Order Terms").font(.system(size: 15, weight: .bold)).foregroundColor(Theme.titleText)
                        TermRow(label: "Paper Type",     value: contract.paperType)
                        TermRow(label: "Quantity",       value: "\(Int(contract.quantityKg)) kg")
                        TermRow(label: "Rate",           value: "PKR \(Int(contract.pricePerKg))/kg")
                        TermRow(label: "Total Value",    value: "PKR \(Int(totalValue).formatted())")
                        TermRow(label: "Payment Terms",  value: "Net 30 Days")
                        TermRow(label: "Delivery",       value: contract.deliveryDate)
                        TermRow(label: "Status",         value: contract.status.rawValue)
                    }
                    .padding(16)
                    .background(Color.white).cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

                    // Action buttons
                    VStack(spacing: 12) {
                        Button {
                            showShareAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share Contract PDF")
                            }
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .background(Theme.linkText).cornerRadius(14)
                        }

                        Button {
                            showShareAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "envelope")
                                Text("Send to Buyer via WhatsApp")
                            }
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Theme.linkText)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .background(Theme.linkText.opacity(0.08)).cornerRadius(14)
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding(20)
            }
            .background(Color(hex: "#F8F8F8"))
            .navigationTitle("Contract Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }.foregroundColor(Theme.linkText)
                }
            }
            .alert("Sharing Coming Soon", isPresented: $showShareAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("PDF export and sharing will be available in the next update.")
            }
        }
    }
}

private struct PartyBox: View {
    let role: String; let name: String; let detail: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(role).font(.system(size: 9, weight: .bold)).foregroundColor(Theme.subtitleText)
            Text(name).font(.system(size: 12, weight: .bold)).foregroundColor(Theme.titleText)
            Text(detail).font(.system(size: 11)).foregroundColor(Theme.subtitleText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color(hex: "#F8F8F8")).cornerRadius(10)
    }
}

private struct TermRow: View {
    let label: String; let value: String
    var body: some View {
        HStack {
            Text(label).font(.system(size: 13)).foregroundColor(Theme.subtitleText)
            Spacer()
            Text(value).font(.system(size: 13, weight: .semibold)).foregroundColor(Theme.titleText)
        }
    }
}

// MARK: — New Contract Sheet
private struct NewContractSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var buyerName = ""
    @State private var paperType = ""
    @State private var quantity = ""
    @State private var rate = ""
    @State private var deliveryDate = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Group {
                        ContractField(label: "Buyer Name", placeholder: "e.g. Ahmed Khan", text: $buyerName)
                        ContractField(label: "Paper Type", placeholder: "e.g. Art Card in Reels", text: $paperType)
                        ContractField(label: "Quantity (kg)", placeholder: "e.g. 2000", text: $quantity, keyboard: .numberPad)
                        ContractField(label: "Rate (PKR/kg)", placeholder: "e.g. 235", text: $rate, keyboard: .numberPad)
                        ContractField(label: "Delivery Date", placeholder: "e.g. Feb 15", text: $deliveryDate)
                    }

                    Button { dismiss() } label: {
                        Text("Generate Contract")
                            .font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .background(Theme.linkText).cornerRadius(14)
                    }
                    .padding(.top, 8)
                }
                .padding(20)
            }
            .background(Color(hex: "#F8F8F8"))
            .navigationTitle("New Contract")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundColor(Theme.linkText)
                }
            }
        }
    }
}

private struct ContractField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.system(size: 13)).foregroundColor(Theme.subtitleText)
            TextField(placeholder, text: $text)
                .keyboardType(keyboard)
                .padding(12).background(Color(hex: "#F5F5F5")).cornerRadius(10)
        }
    }
}
