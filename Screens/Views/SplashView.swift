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

            VStack(spacing: 24) {

                // App icon — drawn in SwiftUI, no image file needed
                ZStack {
                    RoundedRectangle(cornerRadius: 26)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#F5EDD8"), Color(hex: "#E8D5A8")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 110, height: 110)
                        .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 6)

                    // M shape made of two triangles (matches the logo)
                    Canvas { ctx, size in
                        let w = size.width
                        let h = size.height

                        // Left triangle (play button shape)
                        var left = Path()
                        left.move(to: CGPoint(x: w * 0.12, y: h * 0.18))
                        left.addLine(to: CGPoint(x: w * 0.52, y: h * 0.50))
                        left.addLine(to: CGPoint(x: w * 0.12, y: h * 0.82))
                        left.closeSubpath()
                        ctx.fill(left, with: .color(.white))

                        // Right triangle (mirror)
                        var right = Path()
                        right.move(to: CGPoint(x: w * 0.88, y: h * 0.18))
                        right.addLine(to: CGPoint(x: w * 0.48, y: h * 0.50))
                        right.addLine(to: CGPoint(x: w * 0.88, y: h * 0.82))
                        right.closeSubpath()
                        ctx.fill(right, with: .color(.white.opacity(0.85)))
                    }
                    .frame(width: 66, height: 66)
                }
                .scaleEffect(scale)
                .opacity(opacity)

                VStack(spacing: 6) {
                    Text("Mehta Papers")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Theme.titleText)

                    Text("Paper Trading, Simplified")
                        .font(.system(size: 15))
                        .foregroundColor(Theme.subtitleText)
                }
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
