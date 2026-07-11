// SignUpView.swift
// Screens — Multi-step sign up flow (7 steps)

import SwiftUI

// MARK: - Main Container
struct SignUpView: View {
    @Binding var currentScreen: AppScreen
    @State private var step: Int = 1

    // Collected data across steps
    @State private var name        = ""
    @State private var email       = ""
    @State private var password    = ""
    @State private var phone       = ""
    @State private var otpCode     = ["", "", "", "", "", ""]
    @State private var userRole: UserRole? = nil
    @State private var hasPhoto    = false
    @State private var hasCNIC     = false

    enum UserRole { case buyer, seller }

    var body: some View {
        ZStack(alignment: .top) {
            Theme.cardBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar + back button
                topBar

                // Step content
                Group {
                    switch step {
                    case 1: Step1View(name: $name, email: $email, password: $password, onNext: next)
                    case 2: Step2View(phone: $phone, onNext: next)
                    case 3: Step3View(phone: phone, otp: $otpCode, onNext: next)
                    case 4: Step4View(onNext: next)
                    case 5: Step5View(role: $userRole, onNext: next)
                    case 6: Step6View(hasPhoto: $hasPhoto, hasCNIC: $hasCNIC, onNext: next)
                    default: Step7View { currentScreen = .home }
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
                .animation(.easeInOut(duration: 0.3), value: step)
            }
        }
    }

    // MARK: Top bar
    private var topBar: some View {
        VStack(spacing: 16) {
            HStack {
                if step > 1 && step < 7 {
                    Button { back() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.titleText)
                            .frame(width: 36, height: 36)
                            .background(Theme.fieldBackground)
                            .cornerRadius(10)
                    }
                } else {
                    Spacer().frame(width: 36)
                }

                Spacer()

                Text("Step \(min(step, 7)) of 7")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.subtitleText)

                Spacer()

                if step == 1 {
                    Button { currentScreen = .login } label: {
                        Text("Log in")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Theme.linkText)
                    }
                } else {
                    Spacer().frame(width: 36)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 56)

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Theme.screenBackground)
                        .frame(height: 4)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Theme.linkText)
                        .frame(width: geo.size.width * CGFloat(step) / 7.0, height: 4)
                        .animation(.easeInOut(duration: 0.3), value: step)
                }
            }
            .frame(height: 4)
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 8)
        .background(Theme.cardBackground)
    }

    private func next() { withAnimation { step = min(step + 1, 7) } }
    private func back() { withAnimation { step = max(step - 1, 1) } }
}

// MARK: - Step 1: Name / Email / Password
private struct Step1View: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var password: String
    let onNext: () -> Void

    @State private var showPassword = false
    var isValid: Bool { !name.isEmpty && !email.isEmpty && password.count >= 6 }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Create your account")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.titleText)
                    .padding(.top, 32).padding(.horizontal, 24)

                Text("Start trading paper the smart way")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.subtitleText)
                    .padding(.top, 6).padding(.horizontal, 24).padding(.bottom, 36)

                VStack(spacing: 12) {
                    AuthTextField(icon: "person", placeholder: "Full Name", text: $name)
                    AuthTextField(icon: "envelope", placeholder: "Email address", text: $email, keyboardType: .emailAddress)
                    AuthSecureField(placeholder: "Password (min. 6 characters)", text: $password, showPassword: $showPassword)
                }
                .padding(.horizontal, 24)

                PrimaryButton(title: "Continue", isEnabled: isValid, action: onNext)
                    .padding(.horizontal, 24).padding(.top, 32)

                Spacer(minLength: 40)
            }
        }
    }
}

// MARK: - Step 2: Phone Number
private struct Step2View: View {
    @Binding var phone: String
    let onNext: () -> Void
    var isValid: Bool { phone.count >= 10 }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Your phone number")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.titleText)
                .padding(.top, 32).padding(.horizontal, 24)

            Text("We'll send a verification code to confirm it's you")
                .font(.system(size: 14))
                .foregroundColor(Theme.subtitleText)
                .padding(.top, 6).padding(.horizontal, 24).padding(.bottom, 36)

            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.fieldBackground)
                        .frame(width: 64, height: 52)
                    Text("+92")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Theme.titleText)
                }

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.fieldBackground)
                        .frame(height: 52)
                    if phone.isEmpty {
                        Text("3XX XXXXXXX")
                            .font(.system(size: 15))
                            .foregroundColor(Theme.subtitleText.opacity(0.5))
                            .padding(.leading, 16)
                    }
                    TextField("", text: $phone)
                        .keyboardType(.numberPad)
                        .font(.system(size: 15))
                        .foregroundColor(Theme.titleText)
                        .padding(.leading, 16)
                }
            }
            .padding(.horizontal, 24)

            PrimaryButton(title: "Send OTP", isEnabled: isValid, action: onNext)
                .padding(.horizontal, 24).padding(.top, 32)

            Spacer()
        }
    }
}

// MARK: - Step 3: OTP
private struct Step3View: View {
    let phone: String
    @Binding var otp: [String]
    let onNext: () -> Void

    @FocusState private var focusedIndex: Int?
    var isComplete: Bool { otp.allSatisfy { $0.count == 1 } }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Enter the code")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.titleText)
                .padding(.top, 32).padding(.horizontal, 24)

            Text("We sent a 6-digit code to +92 \(phone)")
                .font(.system(size: 14))
                .foregroundColor(Theme.subtitleText)
                .padding(.top, 6).padding(.horizontal, 24).padding(.bottom, 36)

            HStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { i in
                    OTPBox(text: $otp[i], index: i, focusedIndex: $focusedIndex) {
                        if i < 5 { focusedIndex = i + 1 } else { focusedIndex = nil }
                    }
                }
            }
            .padding(.horizontal, 24)
            .onAppear { focusedIndex = 0 }

            HStack(spacing: 4) {
                Text("Didn't receive it?")
                    .font(.system(size: 13)).foregroundColor(Theme.subtitleText)
                Button("Resend Code") {}
                    .font(.system(size: 13, weight: .semibold)).foregroundColor(Theme.linkText)
            }
            .padding(.horizontal, 24).padding(.top, 20)

            PrimaryButton(title: "Verify", isEnabled: isComplete, action: onNext)
                .padding(.horizontal, 24).padding(.top, 32)

            Spacer()
        }
    }
}

private struct OTPBox: View {
    @Binding var text: String
    let index: Int
    var focusedIndex: FocusState<Int?>.Binding
    let onFilled: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.fieldBackground)
                .frame(height: 54)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(focusedIndex.wrappedValue == index ? Theme.linkText : Color.clear, lineWidth: 2)
                )
            TextField("", text: $text)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Theme.titleText)
                .focused(focusedIndex, equals: index)
                .onChange(of: text) { val in
                    if val.count > 1 { text = String(val.last!) }
                    if val.count == 1 { onFilled() }
                }
        }
    }
}

// MARK: - Step 4: Phone Verified
private struct Step4View: View {
    let onNext: () -> Void
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                Circle().fill(Color(hex: "#27AE60").opacity(0.1)).frame(width: 130, height: 130)
                Circle().fill(Color(hex: "#27AE60").opacity(0.15)).frame(width: 100, height: 100)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60)).foregroundColor(Color(hex: "#27AE60"))
            }
            .scaleEffect(appeared ? 1 : 0.4).opacity(appeared ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: appeared)

            Text("Phone Verified!")
                .font(.system(size: 28, weight: .bold)).foregroundColor(Theme.titleText)
                .padding(.top, 24)
                .opacity(appeared ? 1 : 0)
                .animation(.easeIn(duration: 0.4).delay(0.3), value: appeared)

            Text("Your number has been confirmed.\nYou're in good hands.")
                .font(.system(size: 15)).foregroundColor(Theme.subtitleText)
                .multilineTextAlignment(.center)
                .padding(.top, 10).padding(.horizontal, 40)
                .opacity(appeared ? 1 : 0)
                .animation(.easeIn(duration: 0.4).delay(0.4), value: appeared)

            Spacer()

            PrimaryButton(title: "Continue", isEnabled: true, action: onNext)
                .padding(.horizontal, 24).padding(.bottom, 48)
                .opacity(appeared ? 1 : 0)
                .animation(.easeIn(duration: 0.4).delay(0.5), value: appeared)
        }
        .onAppear { appeared = true }
    }
}

// MARK: - Step 5: Buyer or Seller
private struct Step5View: View {
    @Binding var role: SignUpView.UserRole?
    let onNext: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("I am a...")
                .font(.system(size: 28, weight: .bold)).foregroundColor(Theme.titleText)
                .padding(.top, 32).padding(.horizontal, 24)

            Text("This helps us personalise your experience")
                .font(.system(size: 14)).foregroundColor(Theme.subtitleText)
                .padding(.top, 6).padding(.horizontal, 24).padding(.bottom, 36)

            VStack(spacing: 16) {
                RoleCard(
                    icon: "cart.fill", title: "Buyer",
                    subtitle: "I'm looking to purchase paper stock",
                    isSelected: role == .buyer, color: Color(hex: "#5B7CDB")
                ) { role = .buyer }

                RoleCard(
                    icon: "shippingbox.fill", title: "Seller",
                    subtitle: "I want to list and sell my paper inventory",
                    isSelected: role == .seller, color: Theme.linkText
                ) { role = .seller }
            }
            .padding(.horizontal, 24)

            PrimaryButton(title: "Continue", isEnabled: role != nil, action: onNext)
                .padding(.horizontal, 24).padding(.top, 36)

            Spacer()
        }
    }
}

private struct RoleCard: View {
    let icon: String; let title: String; let subtitle: String
    let isSelected: Bool; let color: Color; let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(color.opacity(isSelected ? 1 : 0.1))
                        .frame(width: 54, height: 54)
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(isSelected ? .white : color)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.system(size: 17, weight: .bold)).foregroundColor(Theme.titleText)
                    Text(subtitle).font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                ZStack {
                    Circle().stroke(isSelected ? color : Color(hex: "#D0D0D0"), lineWidth: 2).frame(width: 22, height: 22)
                    if isSelected { Circle().fill(color).frame(width: 12, height: 12) }
                }
            }
            .padding(16)
            .background(Theme.cardBackground).cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(isSelected ? color : Theme.separatorColor, lineWidth: isSelected ? 2 : 1))
            .shadow(color: .black.opacity(isSelected ? 0.08 : 0.03), radius: 8, x: 0, y: 2)
        }
    }
}

// MARK: - Step 6: Profile Photo + CNIC
private struct Step6View: View {
    @Binding var hasPhoto: Bool
    @Binding var hasCNIC: Bool
    let onNext: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Complete your profile")
                    .font(.system(size: 28, weight: .bold)).foregroundColor(Theme.titleText)
                    .padding(.top, 32).padding(.horizontal, 24)

                Text("Verified profiles get more trust from buyers and sellers")
                    .font(.system(size: 14)).foregroundColor(Theme.subtitleText)
                    .padding(.top, 6).padding(.horizontal, 24).padding(.bottom, 36)

                VStack(spacing: 16) {
                    UploadCard(
                        icon: hasPhoto ? "person.fill.checkmark" : "person.crop.circle.badge.plus",
                        title: "Profile Picture",
                        subtitle: hasPhoto ? "Photo added ✓" : "Tap to upload a photo",
                        isDone: hasPhoto, color: Color(hex: "#5B7CDB")
                    ) { hasPhoto = true }

                    UploadCard(
                        icon: hasCNIC ? "checkmark.shield.fill" : "creditcard",
                        title: "CNIC",
                        subtitle: hasCNIC ? "CNIC uploaded ✓" : "Upload your national ID card",
                        isDone: hasCNIC, color: Color(hex: "#27AE60")
                    ) { hasCNIC = true }

                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.seal.fill").foregroundColor(Color(hex: "#27AE60"))
                        Text("Uploading CNIC earns you a verified badge on your profile")
                            .font(.system(size: 12)).foregroundColor(Theme.subtitleText)
                    }
                    .padding(14).background(Color(hex: "#F0FAF4")).cornerRadius(12)
                }
                .padding(.horizontal, 24)

                PrimaryButton(title: "Continue", isEnabled: true, action: onNext)
                    .padding(.horizontal, 24).padding(.top, 32)

                Button(action: onNext) {
                    Text("Skip for now")
                        .font(.system(size: 14)).foregroundColor(Theme.subtitleText)
                        .frame(maxWidth: .infinity).padding(.top, 14)
                }

                Spacer(minLength: 40)
            }
        }
    }
}

private struct UploadCard: View {
    let icon: String; let title: String; let subtitle: String
    let isDone: Bool; let color: Color; let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(isDone ? 1 : 0.1)).frame(width: 50, height: 50)
                    Image(systemName: icon).font(.system(size: 20))
                        .foregroundColor(isDone ? .white : color)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.system(size: 15, weight: .semibold)).foregroundColor(Theme.titleText)
                    Text(subtitle).font(.system(size: 12))
                        .foregroundColor(isDone ? Color(hex: "#27AE60") : Theme.subtitleText)
                }
                Spacer()
                Image(systemName: isDone ? "checkmark.circle.fill" : "plus.circle")
                    .font(.system(size: 22))
                    .foregroundColor(isDone ? Color(hex: "#27AE60") : Theme.subtitleText)
            }
            .padding(14).background(Theme.cardBackground).cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(isDone ? color.opacity(0.4) : Theme.separatorColor, lineWidth: 1))
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }
}

// MARK: - Step 7: All Set!
private struct Step7View: View {
    let onEnter: () -> Void
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                Circle().fill(Theme.linkText.opacity(0.08)).frame(width: 150, height: 150)
                Circle().fill(Theme.linkText.opacity(0.12)).frame(width: 110, height: 110)
                Image(systemName: "party.popper.fill")
                    .font(.system(size: 56)).foregroundColor(Theme.linkText)
            }
            .scaleEffect(appeared ? 1 : 0.3).opacity(appeared ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: appeared)

            Text("You're all set!")
                .font(.system(size: 32, weight: .bold)).foregroundColor(Theme.titleText)
                .padding(.top, 28)
                .opacity(appeared ? 1 : 0)
                .animation(.easeIn(duration: 0.4).delay(0.3), value: appeared)

            Text("Welcome to Mehta Papers.\nLet's get trading.")
                .font(.system(size: 15)).foregroundColor(Theme.subtitleText)
                .multilineTextAlignment(.center)
                .padding(.top, 10).padding(.horizontal, 40)
                .opacity(appeared ? 1 : 0)
                .animation(.easeIn(duration: 0.4).delay(0.4), value: appeared)

            Spacer()

            PrimaryButton(title: "Enter the App →", isEnabled: true, action: onEnter)
                .padding(.horizontal, 24).padding(.bottom, 52)
                .opacity(appeared ? 1 : 0)
                .animation(.easeIn(duration: 0.4).delay(0.5), value: appeared)
        }
        .onAppear { appeared = true }
    }
}
