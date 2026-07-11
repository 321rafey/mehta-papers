// OnboardingView.swift
// Screens

import SwiftUI

private struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
}

struct OnboardingView: View {
    @Binding var currentScreen: AppScreen
    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(icon: "doc.text.fill",       title: "Paper Trading",        subtitle: "Buy and sell paper products faster than ever before."),
        OnboardingPage(icon: "chart.bar.fill",       title: "Track Your Orders",    subtitle: "Monitor every deal from creation to completion in one place."),
        OnboardingPage(icon: "bubble.left.fill",     title: "Chat with Buyers",     subtitle: "Negotiate and finalise deals directly inside the app."),
        OnboardingPage(icon: "checkmark.seal.fill",  title: "Get Started Today",    subtitle: "Join the Screens marketplace and grow your business."),
    ]

    var body: some View {
        ZStack {
            Theme.appGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                // Skip
                HStack {
                    Spacer()
                    Button("Skip") {
                        currentScreen = .login
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.linkText)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                }

                // Pages
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        OnboardingPageView(page: pages[i])
                            .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)

                // Dot indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        Capsule()
                            .fill(i == currentPage ? Theme.dotActive : Theme.dotInactive)
                            .frame(width: i == currentPage ? 24 : 8, height: 8)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 32)

                // Next / Get Started button
                PrimaryButton(title: currentPage == pages.count - 1 ? "Get Started" : "Next") {
                    if currentPage == pages.count - 1 {
                        currentScreen = .login
                    } else {
                        withAnimation { currentPage += 1 }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
}

private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Theme.primaryButtonBG)
                    .frame(width: 130, height: 130)
                Image(systemName: page.icon)
                    .font(.system(size: 52))
                    .foregroundColor(Theme.linkText)
            }

            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Theme.titleText)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(Theme.subtitleText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()
        }
    }
}
