// Theme.swift
// Screens
//
// App-wide design tokens — colours, gradients, etc.

import SwiftUI

// MARK: - Hex colour initialiser
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
        self.init(.sRGB,
                  red:     Double(r) / 255,
                  green:   Double(g) / 255,
                  blue:    Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

// MARK: - Theme
enum Theme {
    static let gradientTop       = Color(hex: "#D8D8D8")
    static let gradientBottom    = Color(hex: "#EFE0B0")
    static let primaryButtonBG   = Color(hex: "#F0DEAD")
    static let primaryButtonText = Color(hex: "#1A1A1A")
    static let titleText         = Color(hex: "#1A1A1A")
    static let subtitleText      = Color(hex: "#6B6B6B")
    static let linkText          = Color(hex: "#8B6914")
    static let fieldBorder       = Color(hex: "#D0D0D0")
    static let fieldIcon         = Color(hex: "#AAAAAA")
    static let dotActive         = Color(hex: "#C8A96E")
    static let dotInactive       = Color(hex: "#D0D0D0")

    static var appGradient: LinearGradient {
        LinearGradient(colors: [gradientTop, gradientBottom],
                       startPoint: .top, endPoint: .bottom)
    }
}
