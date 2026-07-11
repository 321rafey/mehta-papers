// AuthViewModel.swift
// Screens

import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Sign Up with email
    func signUpWithEmail(email: String) {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email."
            return
        }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.isAuthenticated = true
        }
    }

    // MARK: - Login with email + password
    func loginWithEmail(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.isAuthenticated = true
        }
    }

    // MARK: - Google Sign In (stub)
    func signInWithGoogle() {
        isAuthenticated = true
    }

    // MARK: - Facebook Login (stub)
    func signInWithFacebook() {
        isAuthenticated = true
    }

    // MARK: - Sign Out
    func signOut() {
        isAuthenticated = false
    }
}
