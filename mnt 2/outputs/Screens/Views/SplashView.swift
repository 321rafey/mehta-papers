// SplashView.swift
// Screens

import SwiftUI

struct SplashView: View {
    @Binding var currentScreen: AppScreen
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Theme.appGradient.ignoresSafeArea()

            VStack(spacing: 20) {
                LogoView(size: 120)
                    .scaleEffect(scale)
                    .opacity(opacity)

                Text("Screens")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Theme.titleText)
                    .opacity(opacity)

                Text("Paper Trading, Simplified")
                    .font(.system(size: 15))
                    .foregroundColor(Theme.subtitleText)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentScreen = .onboarding
                }
            }
        }
    }
}
