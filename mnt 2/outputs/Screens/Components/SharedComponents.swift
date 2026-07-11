// SharedComponents.swift
// Screens
//
// Reusable UI components used across auth and other screens.

import SwiftUI

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    var isEnabled: Bool = true
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView().tint(Theme.primaryButtonText)
                } else {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isEnabled ? Theme.primaryButtonText : Theme.subtitleText)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(isEnabled ? Theme.primaryButtonBG : Color(hex: "#E8E8E8"))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isEnabled ? Color(hex: "#C8A96E") : Theme.fieldBorder, lineWidth: 1)
            )
        }
        .disabled(!isEnabled || isLoading)
    }
}

// MARK: - Auth Text Field
struct AuthTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundColor(Theme.fieldIcon)
                .frame(width: 20)
            TextField(placeholder, text: $text)
                .font(.system(size: 15))
                .foregroundColor(Theme.titleText)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.fieldBorder, lineWidth: 1)
        )
    }
}

// MARK: - Auth Secure Field
struct AuthSecureField: View {
    let placeholder: String
    @Binding var text: String
    @Binding var showPassword: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock")
                .font(.system(size: 15))
                .foregroundColor(Theme.fieldIcon)
                .frame(width: 20)
            if showPassword {
                TextField(placeholder, text: $text)
                    .font(.system(size: 15))
                    .foregroundColor(Theme.titleText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 15))
                    .foregroundColor(Theme.titleText)
            }
            Button {
                showPassword.toggle()
            } label: {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.fieldIcon)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.fieldBorder, lineWidth: 1)
        )
    }
}

// MARK: - Divider with label
struct DividerWithLabel: View {
    var label: String = "OR"

    var body: some View {
        HStack(spacing: 12) {
            Rectangle().fill(Theme.fieldBorder).frame(height: 1)
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(Theme.subtitleText)
                .fixedSize()
            Rectangle().fill(Theme.fieldBorder).frame(height: 1)
        }
    }
}

// MARK: - Social Button
struct SocialButton: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                // Try image asset first, fall back to SF Symbol
                if UIImage(named: icon) != nil {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                } else {
                    Image(systemName: icon.contains("google") ? "g.circle.fill" : "f.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Theme.titleText)
                }
                Text(label)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Theme.titleText)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.fieldBorder, lineWidth: 1)
            )
        }
    }
}

// MARK: - Checkbox View
struct CheckboxView: View {
    @Binding var isChecked: Bool

    var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isChecked ? Theme.linkText : Theme.fieldBorder, lineWidth: 1.5)
                    .frame(width: 20, height: 20)
                if isChecked {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.linkText)
                        .frame(width: 20, height: 20)
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

// MARK: - Cookie Notice
struct CookieNoticeView: View {
    var body: some View {
        Text("By continuing, you agree to our Terms of Service and Privacy Policy.")
            .font(.system(size: 11))
            .foregroundColor(Theme.subtitleText.opacity(0.7))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
    }
}
