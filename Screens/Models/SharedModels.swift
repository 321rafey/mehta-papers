// SharedModels.swift
// Screens
//
// Central data models shared across views.
// NOTE: Conversation and AvatarView remain in MessagesView.swift (same module, visible everywhere).
// NOTE: ChatMessage remains in ChatView.swift but gains an optional orderCard property.

import SwiftUI

// MARK: - Buyer Order (feed on Home screen — placed by buyers)
struct BuyerOrder: Identifiable {
    let id: Int
    let buyerName: String
    let location: String
    let paperType: String
    let quantityKg: Double
    let offerPerKg: Double       // Rs / kg
    let onlineStatus: String     // "Online", "Online 10 mins ago", etc.
    let isVerified: Bool
    let conversationId: Int      // maps to Conversation.id in MessagesView
}

// MARK: - Seller Order (created by seller, lives in Orders view)
enum SellerOrderStatus: String, CaseIterable {
    case ongoing   = "Ongoing"
    case cancelled = "Cancelled"
    case completed = "Completed"
}

struct SellerOrder: Identifiable {
    var id: Int
    var title: String
    var buyerName: String
    var paperType: String
    var size: String
    var weightGSM: String        // e.g. "500g"  (GSM-based weight per reel)
    var quantity: Int
    var pricePerKg: Double
    var orderType: String        // "Standard Sales", "Wholesale", "Quotation-Based"
    var status: SellerOrderStatus
    var date: String
    var totalAmount: String
}

// MARK: - Paper Type
struct PaperCategory: Identifiable {
    let id: Int
    let name: String
    var items: [PaperItem]
    var isBoard: Bool = false   // true = board formula, false = paper formula
}

struct PaperItem: Identifiable {
    let id: Int
    let name: String
    var isFavorite: Bool = false
    let ratePerKg: Double        // PKR per kg
    let gsm: Double              // grams per square metre — determines weight per sheet/reel
}

// MARK: - Receipt
struct ReceiptItem: Identifiable {
    let id: Int
    let orderTitle: String
    let buyerName: String
    let paperType: String
    let size: String
    let weightGSM: String
    let quantity: Int
    let totalAmount: String
    let date: String
    let orderType: String
}

// MARK: - Order Card embedded in chat
struct OrderChatCard {
    let orderTitle: String
    let paperType: String
    let quantityKg: String
    let pricePerKg: String
    var cardStatus: OrderCardStatus
}

enum OrderCardStatus: String {
    case pending  = "Pending"
    case accepted = "Accepted"
    case closed   = "Closed"
}

// MARK: - Sample / Dummy Data
struct SampleData {

    static let buyerOrders: [BuyerOrder] = [
        BuyerOrder(id: 1, buyerName: "Ahmed Khan",   location: "Lines Area, Saddar",   paperType: "Offset Paper",      quantityKg: 25,  offerPerKg: 235, onlineStatus: "Online",            isVerified: true,  conversationId: 1),
        BuyerOrder(id: 2, buyerName: "Sara Malik",   location: "Urdu Bazaar, Karachi", paperType: "Art Card in Reels", quantityKg: 50,  offerPerKg: 240, onlineStatus: "Online 10 mins ago", isVerified: true,  conversationId: 2),
        BuyerOrder(id: 3, buyerName: "Raza Traders", location: "Defence, Karachi",     paperType: "Bleach Card",       quantityKg: 100, offerPerKg: 228, onlineStatus: "Online 2 hrs ago",   isVerified: false, conversationId: 3),
    ]

    static var sellerOrders: [SellerOrder] = [
        SellerOrder(id: 1, title: "Packages Order", buyerName: "Ahmed Khan",   paperType: "Offset Paper",      size: "12×10", weightGSM: "500g", quantity: 100, pricePerKg: 240, orderType: "Standard Sales", status: .completed, date: "Dec 15, 2025", totalAmount: "PKR 12,500"),
        SellerOrder(id: 2, title: "Small Order",    buyerName: "Sara Malik",   paperType: "Art Card in Reels", size: "8×5",   weightGSM: "300g", quantity: 50,  pricePerKg: 235, orderType: "Wholesale",      status: .completed, date: "Dec 22, 2025", totalAmount: "PKR 4,200"),
        SellerOrder(id: 3, title: "Bulk Order",     buyerName: "Raza Traders", paperType: "Bleach Card",       size: "14×12", weightGSM: "750g", quantity: 200, pricePerKg: 228, orderType: "Wholesale",      status: .ongoing,   date: "Jan 10, 2026", totalAmount: "PKR 38,000"),
        SellerOrder(id: 4, title: "Express Order",  buyerName: "Ahmed Khan",   paperType: "Offset Paper",      size: "12×10", weightGSM: "500g", quantity: 75,  pricePerKg: 242, orderType: "Standard Sales", status: .ongoing,   date: "Jan 20, 2026", totalAmount: "PKR 7,800"),
    ]

    static var paperCategories: [PaperCategory] = [
        PaperCategory(id: 1, name: "ART CARD IN REELS", items: [
            PaperItem(id: 101, name: "AC PINDO IN REELS",        isFavorite: true, ratePerKg: 240, gsm: 300),
            PaperItem(id: 102, name: "AC AMERICAN IN REELS",                       ratePerKg: 245, gsm: 280),
            PaperItem(id: 103, name: "AC STORA ENSO IN REELS",                     ratePerKg: 238, gsm: 260),
            PaperItem(id: 104, name: "AC NINGBO GLOSS IN REELS",                   ratePerKg: 242, gsm: 300),
            PaperItem(id: 105, name: "AC IPSUN IN REELS",                          ratePerKg: 239, gsm: 250),
            PaperItem(id: 106, name: "AC OMNI STAR IN REELS",                      ratePerKg: 241, gsm: 270),
            PaperItem(id: 107, name: "AC BOHUI IN REELS",                          ratePerKg: 237, gsm: 260),
            PaperItem(id: 108, name: "AC NINGBO STAR IN REELS",                    ratePerKg: 243, gsm: 290),
            PaperItem(id: 109, name: "AC PACKAGES IN REELS",                       ratePerKg: 236, gsm: 250),
        ]),
        PaperCategory(id: 2, name: "BLEACH CARD IN REELS", items: [
            PaperItem(id: 201, name: "BC PACKAGES IN REELS",      ratePerKg: 255, gsm: 350),
            PaperItem(id: 202, name: "BC P. T. SURIYA IN REELS",  ratePerKg: 258, gsm: 380),
        ]),
        PaperCategory(id: 3, name: "OFFSET PAPER IN REELS", items: [
            PaperItem(id: 301, name: "OFFSET PINDO IN REELS",     ratePerKg: 230, gsm: 60),
            PaperItem(id: 302, name: "OFFSET AMERICAN IN REELS",  ratePerKg: 235, gsm: 70),
            PaperItem(id: 303, name: "OFFSET PACKAGES IN REELS",  ratePerKg: 228, gsm: 55),
        ]),
        PaperCategory(id: 4, name: "BOND PAPER IN REELS", items: [
            PaperItem(id: 401, name: "BOND PINDO IN REELS",       ratePerKg: 265, gsm: 80),
            PaperItem(id: 402, name: "BOND AMERICAN IN REELS",    ratePerKg: 270, gsm: 90),
        ]),
        // ── Board categories ────────────────────────────────────────────
        PaperCategory(id: 5, name: "DUPLEX BOARD", items: [
            PaperItem(id: 501, name: "DUPLEX PINDO",               ratePerKg: 195, gsm: 230),
            PaperItem(id: 502, name: "DUPLEX AMERICAN",            ratePerKg: 200, gsm: 250),
            PaperItem(id: 503, name: "DUPLEX PACKAGES",            ratePerKg: 192, gsm: 230),
            PaperItem(id: 504, name: "DUPLEX BOHUI",               ratePerKg: 198, gsm: 250),
            PaperItem(id: 505, name: "DUPLEX NINGBO",              ratePerKg: 196, gsm: 240),
        ], isBoard: true),
        PaperCategory(id: 6, name: "GREY BOARD", items: [
            PaperItem(id: 601, name: "GREY BOARD 1MM",             ratePerKg: 120, gsm: 700),
            PaperItem(id: 602, name: "GREY BOARD 1.5MM",           ratePerKg: 118, gsm: 1050),
            PaperItem(id: 603, name: "GREY BOARD 2MM",             ratePerKg: 115, gsm: 1400),
            PaperItem(id: 604, name: "GREY BOARD 2.5MM",           ratePerKg: 112, gsm: 1750),
            PaperItem(id: 605, name: "GREY BOARD 3MM",             ratePerKg: 110, gsm: 2100),
        ], isBoard: true),
        PaperCategory(id: 7, name: "KRAFT BOARD", items: [
            PaperItem(id: 701, name: "KRAFT BOARD PINDO",          ratePerKg: 175, gsm: 200),
            PaperItem(id: 702, name: "KRAFT BOARD AMERICAN",       ratePerKg: 180, gsm: 225),
            PaperItem(id: 703, name: "KRAFT BOARD PACKAGES",       ratePerKg: 172, gsm: 200),
        ], isBoard: true),
        PaperCategory(id: 8, name: "WHITE TOP LINER", items: [
            PaperItem(id: 801, name: "WTL PINDO",                  ratePerKg: 210, gsm: 160),
            PaperItem(id: 802, name: "WTL AMERICAN",               ratePerKg: 215, gsm: 175),
            PaperItem(id: 803, name: "WTL PACKAGES",               ratePerKg: 208, gsm: 160),
        ], isBoard: true),
        PaperCategory(id: 9, name: "TRIPLEX BOARD", items: [
            PaperItem(id: 901, name: "TRIPLEX PINDO",              ratePerKg: 220, gsm: 270),
            PaperItem(id: 902, name: "TRIPLEX AMERICAN",           ratePerKg: 225, gsm: 300),
            PaperItem(id: 903, name: "TRIPLEX PACKAGES",           ratePerKg: 218, gsm: 270),
        ], isBoard: true),
    ]

    static let receipts: [ReceiptItem] = [
        ReceiptItem(id: 1, orderTitle: "Packages Order", buyerName: "Ahmed Khan", paperType: "Offset Paper",      size: "12×10", weightGSM: "500g", quantity: 100, totalAmount: "PKR 12,500", date: "Dec 15, 2025", orderType: "Standard Sales"),
        ReceiptItem(id: 2, orderTitle: "Small Order",    buyerName: "Sara Malik",  paperType: "Art Card in Reels", size: "8×5",   weightGSM: "300g", quantity: 50,  totalAmount: "PKR 4,200",  date: "Dec 22, 2025", orderType: "Wholesale"),
    ]
}
