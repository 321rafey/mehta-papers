// ContentView.swift
// Screens
//
// Root navigation controller. Switches between screens using AppScreen enum.

import SwiftUI

// MARK: - App Screen Enum
enum AppScreen {
    case splash
    case onboarding
    case login
    case signUp
    case home
}

// MARK: - Content View
struct ContentView: View {
    @State private var currentScreen: AppScreen = .splash

    var body: some View {
        ZStack {
            switch currentScreen {
            case .splash:
                SplashView(currentScreen: $currentScreen)
            case .onboarding:
                OnboardingView(currentScreen: $currentScreen)
            case .login:
                LoginView(currentScreen: $currentScreen)
            case .signUp:
                SignUpView(currentScreen: $currentScreen)
            case .home:
                HomeView()
            }
        }
        .animation(.easeInOut(duration: 0.30), value: currentScreen)
    }
}
