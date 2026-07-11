// NewOrderView.swift
// Screens
//
// 3-step order creation wizard:
//   Step 1 — Select order type (Standard Sales / Wholesale / Quotation-Based / Re-order)
//   Step 2 — Pick contacts to send the order to (multi-select)
//   Step 3 — Calculator (Calculator tab + Paper Rate tab) → Send Order

import SwiftUI

// MARK: - Order Type Enum
enum NewOrderType: String, CaseIterable {
    case standardSales  = "Standard Sales"
    case wholesale      = "Wholesale"
    case quotationBased = "Quotation-Based"
    case reorder        = "Re-order"
}

// MARK: - New Order View (wizard container)
struct NewOrderView: View {
    @State private var currentStep = 1
    @State private var selectedOrderType: NewOrderType? = nil
    @State private var selectedContacts: [Conversation] = []
    @State private var showReorderSheet = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Theme.appGradient.ignoresSafeArea(edges: .top)

            VStack(spacing: 0) {

                // ── Header ───────────────────────────────────────────────
                HStack(alignment: .center) {
                    Text("Create a new order")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Theme.titleText)
                    Image(systemName: "pencil")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.subtitleText)
                    Spacer()
                    HStack(spacing: 10) {
                        Button {} label: {
                            Image(systemName: "bookmark")
                                .font(.system(size: 15))
                                .foregroundColor(Theme.titleText)
                                .frame(width: 36, height: 36)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.fieldBorder, lineWidth: 1))
                        }
                        Button {} label: {
                            Image(systemName: "trash")
                                .font(.system(size: 15))
                                .foregroundColor(Theme.titleText)
                                .frame(width: 36, height: 36)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.fieldBorder, lineWidth: 1))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 14)

                // ── Progress Bar ─────────────────────────────────────────
                HStack(spacing: 6) {
                    ForEach(1...3, id: \.self) { step in
                        Capsule()
                            .fill(step <= currentStep ? Color(hex: "#B8A888") : Color(hex: "#E0D8C8"))
                            .frame(height: 5)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

                // ── Step Content ─────────────────────────────────────────
                Group {
                    switch currentStep {
                    case 1:
                        NOStep1View(
                            selectedType: $selectedOrderType,
                            onNext: {
                                if selectedOrderType == .reorder {
                                    showReorderSheet = true
                                } else if selectedOrderType != nil {
                                    withAnimation { currentStep = 2 }
                                }
                            }
                        )
                    case 2:
                        NOStep2View(
                            selectedContacts: $selectedContacts,
                            onBack: { withAnimation { currentStep = 1 } },
                            onNext: { withAnimation { currentStep = 3 } }
                        )
                    default:
                        NOStep3View(
                            selectedContacts: selectedContacts,
                            orderType: selectedOrderType?.rawValue ?? "Standard Sales"
                        )
                    }
                }
                .background(Color.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showReorderSheet) {
            ReorderPickerView { _ in showReorderSheet = false }
        }
    }
}

// MARK: ─────────────────────────────────────────────────────────────
// STEP 1: Order Type Selection
// ─────────────────────────────────────────────────────────────────
struct NOStep1View: View {
    @Binding var selectedType: NewOrderType?
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Order Type")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.subtitleText)
                        .padding(.horizontal, 20)

                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                        spacing: 12
                    ) {
                        ForEach(NewOrderType.allCases, id: \.self) { type in
                            NOTypeCard(
                                icon: iconFor(type),
                                title: type.rawValue,
                                subtitle: subtitleFor(type),
                                isSelected: selectedType == type
                            ) { selectedType = type }
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 100)
                }
                .padding(.top, 20)
            }

            // Next button
            VStack(spacing: 0) {
                Button(action: onNext) {
                    Text("Next")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(selectedType != nil ? Theme.primaryButtonText : Theme.subtitleText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(selectedType != nil ? Theme.primaryButtonBG : Color(hex: "#F0F0F0"))
                        .cornerRadius(14)
                }
                .disabled(selectedType == nil)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
    }

    func iconFor(_ type: NewOrderType) -> String {
        switch type {
        case .standardSales:  return "list.bullet.rectangle"
        case .wholesale:      return "square.3.layers.3d"
        case .quotationBased: return "doc.text.magnifyingglass"
        case .reorder:        return "arrow.2.circlepath"
        }
    }

    func subtitleFor(_ type: NewOrderType) -> String {
        switch type {
        case .standardSales:  return "Regular buying by distributors, printers, retailers"
        case .wholesale:      return "High-volume buyers"
        case .quotationBased: return "Price-sensitive or negotiated deals"
        case .reorder:        return "Frequent buyers purchasing the same SKU"
        }
    }
}

// MARK: ─────────────────────────────────────────────────────────────
// STEP 2: Contact Selection
// ─────────────────────────────────────────────────────────────────
struct NOStep2View: View {
    @Binding var selectedContacts: [Conversation]
    let onBack: () -> Void
    let onNext: () -> Void
    @State private var showPicker = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {

                    HStack {
                        Text("Send order to")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Theme.subtitleText)
                        Spacer()
                        Button { showPicker = true } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "plus").font(.system(size: 11, weight: .bold))
                                Text("Add Contact").font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundColor(Theme.linkText)
                        }
                    }
                    .padding(.horizontal, 20)

                    if selectedContacts.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 36))
                                .foregroundColor(Theme.subtitleText.opacity(0.3))
                            Text("Tap 'Add Contact' to choose who receives this order")
                                .font(.system(size: 13))
                                .foregroundColor(Theme.subtitleText)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(40)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(selectedContacts) { contact in
                                HStack(spacing: 14) {
                                    AvatarView(name: contact.name, size: 42)
                                    Text(contact.name)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Theme.titleText)
                                    Spacer()
                                    Button {
                                        selectedContacts.removeAll { $0.id == contact.id }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(Theme.subtitleText.opacity(0.5))
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                Divider().padding(.leading, 74)
                            }
                        }
                    }

                    Spacer(minLength: 100)
                }
                .padding(.top, 20)
            }

            VStack(spacing: 10) {
                Button(action: onNext) {
                    Text("Next")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(!selectedContacts.isEmpty ? Theme.primaryButtonText : Theme.subtitleText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(!selectedContacts.isEmpty ? Theme.primaryButtonBG : Color(hex: "#F0F0F0"))
                        .cornerRadius(14)
                }
                .disabled(selectedContacts.isEmpty)

                Button(action: onBack) {
                    Text("Back")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.subtitleText)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .sheet(isPresented: $showPicker) {
            ContactPickerView(title: "Select Contacts", multiSelect: true) { contacts in
                for c in contacts where !selectedContacts.contains(where: { $0.id == c.id }) {
                    selectedContacts.append(c)
                }
            }
        }
    }
}

// MARK: ─────────────────────────────────────────────────────────────
// STEP 3: Calculator
// ─────────────────────────────────────────────────────────────────
struct NOStep3View: View {
    let selectedContacts: [Conversation]
    let orderType: String

    @State private var activeTab = 0  // 0 = Calculator, 1 = Paper Rate

    // Calculator tab state
    @State private var calcDisplay   = "0"
    @State private var calcExpr      = ""
    @State private var firstOperand  : Double? = nil
    @State private var pendingOp     : String?  = nil
    @State private var shouldReset   = false
    @State private var showSendMenu  = false

    // Paper Rate tab state
    @State private var paperName     = "OFFSET PAPER IN REELS"
    @State private var paperRate     : Double = 230
    @State private var paperGSM      : Double = 60
    @State private var sizeInput     = ""
    @State private var weightInput   = ""
    @State private var quantityInput = ""
    @State private var activeField   = "weight"
    @State private var showPaperPicker = false

    // Total PKR = rate/kg × (GSM weight in grams / 1000) × quantity reels
    var totalPKR: Double {
        let w = Double(weightInput) ?? 0
        let q = Double(quantityInput) ?? 0
        return paperRate * (w / 1000.0) * q
    }

    var body: some View {
        VStack(spacing: 0) {

            // ── Tab Toggle ───────────────────────────────────────────────
            HStack(spacing: 8) {
                NOTabBtn(title: "Calculator", icon: "tablecells", isActive: activeTab == 0) {
                    withAnimation { activeTab = 0 }
                }
                NOTabBtn(title: "Paper Rate", icon: "doc.plaintext", isActive: activeTab == 1) {
                    withAnimation { activeTab = 1 }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)

            if activeTab == 0 {
                calculatorTabContent
            } else {
                paperRateTabContent
            }
        }
        .sheet(isPresented: $showPaperPicker) {
            PaperTypeSelectorView(
                selectedPaperName: $paperName,
                selectedRatePerKg: $paperRate,
                selectedGSM:       $paperGSM
            )
        }
    }

    // MARK: Calculator Tab
    var calculatorTabContent: some View {
        VStack(spacing: 12) {

            // Display
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "#8FA87A").opacity(0.25))
                VStack(alignment: .trailing, spacing: 4) {
                    if !calcExpr.isEmpty {
                        Text(calcExpr)
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "#5A7A4A"))
                            .lineLimit(1)
                    }
                    Text(calcDisplay)
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(Color(hex: "#2A4A1A"))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                }
                .padding(16)
            }
            .frame(height: 110)
            .padding(.horizontal, 20)

            // Send result to + undo + copy
            HStack(spacing: 8) {
                Button { withAnimation { showSendMenu.toggle() } } label: {
                    HStack(spacing: 6) {
                        Text("Send Result to")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.titleText)
                        Spacer()
                        Image(systemName: showSendMenu ? "chevron.up" : "chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.subtitleText)
                    }
                    .padding(.horizontal, 14)
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(Theme.primaryButtonBG)
                    .cornerRadius(10)
                }

                // Undo
                Button {
                    if calcDisplay.count > 1 { calcDisplay = String(calcDisplay.dropLast()) }
                    else { calcDisplay = "0" }
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.titleText)
                        .frame(width: 40, height: 40)
                        .background(Color(hex: "#F2F2F2"))
                        .cornerRadius(10)
                }

                // Copy
                Button { UIPasteboard.general.string = calcDisplay } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.titleText)
                        .frame(width: 40, height: 40)
                        .background(Color(hex: "#F2F2F2"))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)

            // Send dropdown options
            if showSendMenu {
                HStack(spacing: 8) {
                    ForEach(["Size", "Weight", "Quantity"], id: \.self) { target in
                        Button {
                            let val = calcDisplay
                            switch target {
                            case "Size":     sizeInput     = val
                            case "Weight":   weightInput   = val
                            case "Quantity": quantityInput = val
                            default: break
                            }
                            activeField  = target.lowercased()
                            showSendMenu = false
                            withAnimation { activeTab = 1 }
                        } label: {
                            Text(target)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Theme.titleText)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color(hex: "#F2F2F2"))
                                .cornerRadius(8)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
            }

            // Full iOS-style keypad
            FullCalculatorKeypad(
                display:       $calcDisplay,
                expression:    $calcExpr,
                firstOperand:  $firstOperand,
                pendingOp:     $pendingOp,
                shouldReset:   $shouldReset
            )
            .padding(.horizontal, 20)

            Spacer(minLength: 20)
        }
    }

    // MARK: Paper Rate Tab
    var paperRateTabContent: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {

                    // PKR result display
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "#8FA87A").opacity(0.25))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("PKR:")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "#5A7A4A"))
                            Text(totalPKR > 0 ? String(format: "%.0f", totalPKR) : "0")
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(Color(hex: "#2A4A1A"))
                                .minimumScaleFactor(0.4)
                                .lineLimit(1)
                            Text("Latest rate: PKR \(Int(paperRate))/kg  •  GSM: \(Int(paperGSM))")
                                .font(.system(size: 11))
                                .foregroundColor(Color(hex: "#5A7A4A"))
                        }
                        .padding(16)
                    }
                    .frame(height: 120)
                    .padding(.horizontal, 20)

                    // Paper type dropdown
                    Button { showPaperPicker = true } label: {
                        HStack {
                            Text(paperName)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Theme.titleText)
                                .lineLimit(1)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10))
                                .foregroundColor(Theme.subtitleText)
                        }
                        .padding(.horizontal, 14)
                        .frame(height: 46)
                        .background(Color(hex: "#F5F5F5"))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.fieldBorder, lineWidth: 1))
                    }
                    .padding(.horizontal, 20)

                    // Input fields
                    PRInputRow(label: "Size",     value: $sizeInput,     isActive: activeField == "size")     { activeField = "size" }
                    PRInputRow(label: "Weight",   value: $weightInput,   isActive: activeField == "weight")   { activeField = "weight" }
                    PRInputRow(label: "Quantity", value: $quantityInput, isActive: activeField == "quantity") { activeField = "quantity" }

                    // Simple digit keypad
                    PRNumpad { key in
                        applyKey(key, to: activeField)
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 80)
                }
                .padding(.top, 4)
                .padding(.bottom, 20)
            }

            // Send Order button
            VStack(spacing: 0) {
                Button {} label: {
                    Text("Send Order")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.primaryButtonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Theme.primaryButtonBG)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color.white)
        }
    }

    func applyKey(_ key: String, to field: String) {
        switch field {
        case "size":     updateField(&sizeInput,     key: key)
        case "weight":   updateField(&weightInput,   key: key)
        case "quantity": updateField(&quantityInput, key: key)
        default: break
        }
    }

    func updateField(_ field: inout String, key: String) {
        if key == "⌫" {
            if !field.isEmpty { field.removeLast() }
        } else if key == "." {
            if !field.contains(".") { field += "." }
        } else {
            if field == "0" { field = key } else { field += key }
        }
    }
}

// MARK: - Tab Toggle Button
struct NOTabBtn: View {
    let title: String
    let icon: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 12))
                Text(title).font(.system(size: 13, weight: .medium))
            }
            .foregroundColor(isActive ? Theme.titleText : Theme.subtitleText)
            .frame(maxWidth: .infinity)
            .frame(height: 38)
            .background(isActive ? Theme.primaryButtonBG : Color(hex: "#F2F2F2"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isActive ? Theme.dotActive.opacity(0.4) : Color.clear, lineWidth: 1)
            )
        }
    }
}

// MARK: - Paper Rate Input Row
struct PRInputRow: View {
    let label: String
    @Binding var value: String
    let isActive: Bool
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: onTap) {
                Text(value.isEmpty ? "0" : value)
                    .font(.system(size: 15))
                    .foregroundColor(value.isEmpty ? Theme.subtitleText : Theme.titleText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 14)
                    .frame(height: 46)
                    .background(Color(hex: "#F5F5F5"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isActive ? Theme.linkText : Theme.fieldBorder, lineWidth: isActive ? 1.5 : 1)
                    )
            }
            .padding(.leading, 20)

            Rectangle()
                .fill(Color(hex: "#D0D0D0"))
                .frame(width: 24, height: 1)

            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.titleText)
                .frame(width: 74, alignment: .leading)
                .padding(.trailing, 20)
        }
    }
}

// MARK: - Paper Rate Simple Numpad
struct PRNumpad: View {
    let onKey: (String) -> Void
    let rows = [["7","8","9"], ["4","5","6"], ["1","2","3"], [".","0","⌫"]]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(rows.indices, id: \.self) { ri in
                HStack(spacing: 8) {
                    ForEach(rows[ri].indices, id: \.self) { ci in
                        let key = rows[ri][ci]
                        Button { onKey(key) } label: {
                            Group {
                                if key == "⌫" {
                                    Image(systemName: "delete.left")
                                        .font(.system(size: 16))
                                } else {
                                    Text(key)
                                        .font(.system(size: 18, weight: .medium))
                                }
                            }
                            .foregroundColor(Theme.titleText)
                            .frame(maxWidth: .infinity)
                            .frame(height: numH())
                            .background(Color(hex: "#F2F2F2"))
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
    }

    func numH() -> CGFloat { (UIScreen.main.bounds.width - 40 - 16) / 3 * 0.60 }
}

// MARK: - Full iOS-style Calculator Keypad
struct FullCalculatorKeypad: View {
    @Binding var display:      String
    @Binding var expression:   String
    @Binding var firstOperand: Double?
    @Binding var pendingOp:    String?
    @Binding var shouldReset:  Bool

    let rows: [[CalcKey]] = [
        [.fn("AC"), .fn("+/-"), .fn("%"), .op("÷")],
        [.num("7"), .num("8"),  .num("9"), .op("×")],
        [.num("4"), .num("5"),  .num("6"), .op("−")],
        [.num("1"), .num("2"),  .num("3"), .op("+")],
        [.wide("0"), .num("."), .op("=")]
    ]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(rows.indices, id: \.self) { ri in
                HStack(spacing: 8) {
                    ForEach(rows[ri].indices, id: \.self) { ci in
                        let key = rows[ri][ci]
                        Button { handleKey(key.value) } label: {
                            Text(key.value)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(key.isOp ? .white : Theme.titleText)
                                .frame(maxWidth: key.isWide ? .infinity : nil)
                                .frame(
                                    width:  key.isWide ? nil : btnSize(),
                                    height: btnSize()
                                )
                                .background(key.isOp ? Color(hex: "#555555") : Color(hex: "#F2F2F2"))
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
    }

    func btnSize() -> CGFloat { (UIScreen.main.bounds.width - 40 - 24) / 4 }

    func handleKey(_ key: String) {
        switch key {
        case "AC":
            display = "0"; expression = ""; firstOperand = nil; pendingOp = nil; shouldReset = false
        case "+/-":
            if let v = Double(display) { display = "\(v * -1 == v * -1 ? String(format: "%g", v * -1) : display)" }
        case "%":
            if let v = Double(display) { display = String(format: "%g", v / 100) }
        case "÷", "×", "−", "+":
            firstOperand = Double(display)
            pendingOp    = key
            expression   = "\(display) \(key)"
            shouldReset  = true
        case "=":
            guard let a = firstOperand, let b = Double(display), let op = pendingOp else { return }
            var result: Double
            switch op {
            case "÷": result = b != 0 ? a / b : 0
            case "×": result = a * b
            case "−": result = a - b
            case "+": result = a + b
            default:  return
            }
            expression   = "\(String(format: "%g", a)) \(op) \(display) ="
            display      = String(format: "%g", result)
            firstOperand = nil; pendingOp = nil; shouldReset = true
        case ".":
            if shouldReset { display = "0."; shouldReset = false }
            else if !display.contains(".") { display += "." }
        default: // digit
            if shouldReset || display == "0" { display = key; shouldReset = false }
            else { display += key }
        }
    }
}

enum CalcKey {
    case num(String)
    case op(String)
    case fn(String)
    case wide(String)

    var value: String {
        switch self { case .num(let v), .op(let v), .fn(let v), .wide(let v): return v }
    }
    var isOp:  Bool { if case .op  = self { return true }; return false }
    var isWide: Bool { if case .wide = self { return true }; return false }
}

// MARK: - Order Type Card
struct NOTypeCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? Theme.linkText : Theme.subtitleText)
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Theme.titleText)
                        .multilineTextAlignment(.leading)
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundColor(Theme.subtitleText)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Color.white)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Theme.linkText : Theme.fieldBorder, lineWidth: isSelected ? 1.5 : 1)
            )
        }
    }
}

// MARK: - Corner Radius Helper
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 14
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        ).cgPath)
    }
}
