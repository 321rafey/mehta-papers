// Theme.swift
// Screens — App-wide design tokens with full light/dark adaptive support.
//
// HOW IT WORKS:
//   All colors use UIColor's dynamic provider. When the root view sets
//   .preferredColorScheme(.dark / .light), every Theme color automatically
//   resolves to its dark or light variant — across the entire app.
//   No view-level changes needed for the core palette.

import SwiftUI
import UIKit

// MARK: - UIColor hex + adaptive helpers
private extension UIColor {
    /// Create a UIColor from a 6-digit hex string like "#1A1A1A"
    convenience init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let r, g, b: UInt64
        (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        self.init(red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, alpha: 1)
    }

    /// Create an adaptive color — automatically switches light ↔ dark
    static func adaptive(light: String, dark: String) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(hex: dark)
            : UIColor(hex: light) }
    }
}

// MARK: - SwiftUI Color hex init (kept for one-off usage in views)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255,
                  blue: Double(b)/255, opacity: Double(a)/255)
    }
}

// MARK: - Theme
enum Theme {

    // ── Text ──────────────────────────────────────────────────────────
    /// Primary text  (near-black / near-white)
    static let titleText    = Color(UIColor.adaptive(light: "#1A1A1A", dark: "#F2F2F7"))
    /// Secondary / caption text
    static let subtitleText = Color(UIColor.adaptive(light: "#6B6B6B", dark: "#8E8E93"))
    /// Gold accent / links
    static let linkText     = Color(UIColor.adaptive(light: "#8B6914", dark: "#D4A843"))

    // ── Backgrounds ───────────────────────────────────────────────────
    /// Full-screen page background  (#F8F8F8 light / near-black dark)
    static let screenBackground = Color(UIColor.adaptive(light: "#F4F4F4", dark: "#0D0D0D"))
    /// Card / sheet / nav-bar background  (white light / dark-card dark)
    static let cardBackground   = Color(UIColor.adaptive(light: "#FFFFFF", dark: "#1C1C1E"))
    /// Input field fill  (#F5F5F5 light / dark-field dark)
    static let fieldBackground  = Color(UIColor.adaptive(light: "#F5F5F5", dark: "#2C2C2E"))
    /// Small icon-button pill (gear, back, etc.)
    static let iconBackground   = Color(UIColor.adaptive(light: "#F2F2F2", dark: "#2C2C2E"))
    /// App gradient top colour
    static let gradientTop      = Color(UIColor.adaptive(light: "#D8D8D8", dark: "#2A2A2A"))
    /// App gradient bottom colour
    static let gradientBottom   = Color(UIColor.adaptive(light: "#EFE0B0", dark: "#1A1208"))

    // ── Borders & separators ──────────────────────────────────────────
    static let fieldBorder      = Color(UIColor.adaptive(light: "#D0D0D0", dark: "#3A3A3C"))
    static let separatorColor   = Color(UIColor.adaptive(light: "#E5E5E5", dark: "#2C2C2E"))

    // ── Icons ─────────────────────────────────────────────────────────
    static let fieldIcon        = Color(UIColor.adaptive(light: "#AAAAAA", dark: "#636366"))

    // ── Primary button ────────────────────────────────────────────────
    static let primaryButtonBG   = Color(UIColor.adaptive(light: "#F0DEAD", dark: "#3D2E0F"))
    static let primaryButtonText = Color(UIColor.adaptive(light: "#1A1A1A", dark: "#F2F2F2"))

    // ── Indicator dots ────────────────────────────────────────────────
    static let dotActive   = Color(UIColor.adaptive(light: "#C8A96E", dark: "#D4A843"))
    static let dotInactive = Color(UIColor.adaptive(light: "#D0D0D0", dark: "#3A3A3C"))

    // ── Computed ──────────────────────────────────────────────────────
    static var appGradient: LinearGradient {
        LinearGradient(colors: [gradientTop, gradientBottom],
                       startPoint: .top, endPoint: .bottom)
    }
}
