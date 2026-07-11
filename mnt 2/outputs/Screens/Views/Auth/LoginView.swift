// LoginView.swift
// Screens

import SwiftUI

struct LoginView: View {
    @Binding var currentScreen: AppScreen
    @StateObject private var authVM = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showPassword = false
    @State private var showError = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Log in to App")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Theme.titleText)
                        .padding(.top, 72).padding(.horizontal, 24).padding(.bottom, 36)

                    AuthTextField(icon: "person", placeholder: "Email", text: $email, keyboardType: .emailAddress)
                        .padding(.horizontal, 24)

                    AuthSecureField(placeholder: "Password", text: $password, showPassword: $showPassword)
                        .padding(.horizontal, 24).padding(.top, 12)

                    HStack {
                        HStack(spacing: 8) {
                            CheckboxView(isChecked: $rememberMe)
                            Text("Remember me").font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                        }
                        Spacer()
                        Button("Forgot password?") {}
                            .font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                    }
                    .padding(.horizontal, 24).padding(.top, 14)

                    if showError {
                        Text(authVM.errorMessage ?? "Please fill in all fields.")
                            .font(.system(size: 12)).foregroundColor(.red)
                            .padding(.horizontal, 24).padding(.top, 8)
                    }

                    PrimaryButton(title: "Login", isEnabled: !email.isEmpty && !password.isEmpty) {
                        authVM.loginWithEmail(email: email, password: password)
                    }
                    .padding(.horizontal, 24).padding(.top, 24)

                    DividerWithLabel().padding(.horizontal, 24).padding(.vertical, 20)

                    VStack(spacing: 12) {
                        SocialButton(icon: "google_icon", label: "Continue with Google") { authVM.signInWithGoogle() }
                        SocialButton(icon: "facebook_icon", label: "Continue With Facebook") { authVM.signInWithFacebook() }
                    }.padding(.horizontal, 24)

                    HStack(spacing: 0) {
                        Spacer()
                        Text("Don't have an account? ").font(.system(size: 14)).foregroundColor(Theme.subtitleText)
                        Button("Sign Up") { currentScreen = .signUp }
                            .font(.system(size: 14, weight: .semibold)).foregroundColor(Theme.linkText)
                        Spacer()
                    }.padding(.top, 20)

                    CookieNoticeView().padding(.top, 20)
                    Spacer(minLength: 44)
                }
            }

            if authVM.isLoading {
                Color.black.opacity(0.25).ignoresSafeArea()
                ProgressView().scaleEffect(1.4).tint(.white)
            }
        }
        // ── KEY LINE: when login succeeds, go to home ──
        .onChange(of: authVM.isAuthenticated) { isAuth in
            if isAuth { currentScreen = .home }
        }
        .onChange(of: authVM.errorMessage) { msg in
            showError = msg != nil
        }
    }
}
