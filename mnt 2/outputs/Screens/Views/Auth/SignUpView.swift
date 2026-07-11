// SignUpView.swift
// Screens

import SwiftUI

struct SignUpView: View {
    @Binding var currentScreen: AppScreen
    @StateObject private var authVM = AuthViewModel()
    @State private var email = ""
    @State private var agreedToPolicy = false
    @State private var showError = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Get your free account")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Theme.titleText)
                        .padding(.top, 72).padding(.horizontal, 24).padding(.bottom, 36)

                    VStack(spacing: 12) {
                        SocialButton(icon: "google_icon", label: "Continue with Google") { authVM.signInWithGoogle() }
                        SocialButton(icon: "facebook_icon", label: "Continue With Facebook") { authVM.signInWithFacebook() }
                    }.padding(.horizontal, 24)

                    DividerWithLabel().padding(.horizontal, 24).padding(.vertical, 24)

                    AuthTextField(icon: "person", placeholder: "Email", text: $email, keyboardType: .emailAddress)
                        .padding(.horizontal, 24)

                    HStack(alignment: .center, spacing: 8) {
                        CheckboxView(isChecked: $agreedToPolicy)
                        (Text("I Agree with ").font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                        + Text("Privacy").font(.system(size: 13, weight: .semibold)).foregroundColor(Theme.linkText)
                        + Text(" & ").font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                        + Text("Policy").font(.system(size: 13, weight: .semibold)).foregroundColor(Theme.linkText))
                    }.padding(.horizontal, 24).padding(.top, 16)

                    PrimaryButton(title: "Continue with Email", isEnabled: agreedToPolicy && !email.isEmpty) {
                        authVM.signUpWithEmail(email: email)
                    }.padding(.horizontal, 24).padding(.top, 28)

                    HStack(spacing: 0) {
                        Spacer()
                        Text("Already have an account? ").font(.system(size: 14)).foregroundColor(Theme.subtitleText)
                        Button("Login") { currentScreen = .login }
                            .font(.system(size: 14, weight: .semibold)).foregroundColor(Theme.linkText)
                        Spacer()
                    }.padding(.top, 22)

                    CookieNoticeView().padding(.top, 20)
                    Spacer(minLength: 44)
                }
            }

            if authVM.isLoading {
                Color.black.opacity(0.25).ignoresSafeArea()
                ProgressView().scaleEffect(1.4).tint(.white)
            }
        }
        // ── KEY LINE: when sign up succeeds, go to home ──
        .onChange(of: authVM.isAuthenticated) { isAuth in
            if isAuth { currentScreen = .home }
        }
        .onChange(of: authVM.errorMessage) { msg in
            showError = msg != nil
        }
    }
}
