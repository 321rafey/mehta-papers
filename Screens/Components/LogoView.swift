// LogoView.swift
// Screens

import SwiftUI

struct LogoView: View {
    var size: CGFloat = 80

    var body: some View {
        Image("app_logo")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}
