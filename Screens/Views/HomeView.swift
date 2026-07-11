// HomeView.swift
// Screens
//
// Main home screen shown after login/signup.
// Contains the bottom tab bar with 5 tabs.
// The Home tab is wrapped in a NavigationStack so we can
// push MessagesView and other screens onto it.

import SwiftUI

// MARK: - Home View (Tab Bar Container)
struct HomeView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            // Tab 1: Home — wrapped in NavigationStack for sub-screen navigation
            NavigationStack {
                HomeTabContent()
            }
            .tabItem {
                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                Text("Home")
            }
            .tag(0)

            // Tab 2: Orders
            OrdersView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "shippingbox.fill" : "shippingbox")
                    Text("Orders")
                }
                .tag(1)

            // Tab 3: New Order
            NewOrderView()
                .tabItem {
                    Image(systemName: "plus.app")
                    Text("New Order")
                }
                .tag(2)

            // Tab 4: Receipt
            ReceiptView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "doc.text.fill" : "doc.text")
                    Text("Receipt")
                }
                .tag(3)

            // Tab 5: Profile
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(4)
        }
        .tint(Theme.linkText)
    }
}

// MARK: - Home Tab Content
struct HomeTabContent: View {

    @ObservedObject private var proManager = ProManager.shared
    @State private var showSubscriptionBanner = true
    @State private var showUpgrade = false
    let buyerOrders: [BuyerOrder] = SampleData.buyerOrders

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {

                // ── Header ───────────────────────────────────────────────
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Good Morning")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.subtitleText)
                        Text("Zeeshan")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Theme.titleText)
                    }
                    Spacer()
                    HStack(spacing: 10) {
                        // ── Chat button → navigates to MessagesView ──────
                        NavigationLink(destination: MessagesView()) {
                            Image(systemName: "bubble.left")
                                .font(.system(size: 14))
                                .foregroundColor(Theme.subtitleText)
                                .frame(width: 38, height: 38)
                                .background(Theme.iconBackground)
                                .clipShape(Circle())
                        }

                        // Settings button → App Settings
                        NavigationLink(destination: AppSettingsView()) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 14))
                                .foregroundColor(Theme.subtitleText)
                                .frame(width: 38, height: 38)
                                .background(Theme.iconBackground)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                // ── Current Value Card ───────────────────────────────────
                CurrentValueCard()
                    .padding(.horizontal, 20)

                // ── Pro upgrade banner (free users) ─────────────────────
                if !proManager.isPro {
                    Button { showUpgrade = true } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "#8B6914"))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Unlock Pro Features")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(hex: "#8B6914"))
                                Text("Analytics, Inventory, Rate Alerts & more")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(hex: "#8B6914").opacity(0.7))
                            }
                            Spacer()
                            Text("Upgrade →")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12).padding(.vertical, 6)
                                .background(Color(hex: "#8B6914"))
                                .cornerRadius(8)
                        }
                        .padding(14)
                        .background(LinearGradient(colors: [Color(hex: "#FDF3DC"), Color(hex: "#FAE8B8")], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#E8C860").opacity(0.5), lineWidth: 1))
                    }
                    .padding(.horizontal, 20)
                }

                // ── Pro Quick Access (pro users only) ───────────────────
                if proManager.isPro {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pro Features")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.titleText)
                            .padding(.horizontal, 20)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                NavigationLink(destination: AnalyticsView()) {
                                    ProQuickTile(icon: "chart.bar.fill", label: "Analytics", color: Color(hex: "#5B7CDB"))
                                }
                                .buttonStyle(.plain)
                                NavigationLink(destination: InventoryView()) {
                                    ProQuickTile(icon: "cube.box.fill", label: "Inventory", color: Color(hex: "#27AE60"))
                                }
                                .buttonStyle(.plain)
                                NavigationLink(destination: RateAlertsView()) {
                                    ProQuickTile(icon: "bell.fill", label: "Rate Alerts", color: Color(hex: "#E74C3C"))
                                }
                                .buttonStyle(.plain)
                                NavigationLink(destination: PriceHistoryView()) {
                                    ProQuickTile(icon: "chart.line.uptrend.xyaxis", label: "Prices", color: Color(hex: "#8B6914"))
                                }
                                .buttonStyle(.plain)
                                NavigationLink(destination: RecurringOrdersView()) {
                                    ProQuickTile(icon: "arrow.clockwise", label: "Recurring", color: Color(hex: "#9B59B6"))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }

                // ── Subscription Banner (only if not pro and banner not dismissed) ─
                if showSubscriptionBanner && !proManager.isPro {
                    SubscriptionBanner {
                        withAnimation { showSubscriptionBanner = false }
                    }
                    .padding(.horizontal, 20)
                }

                // ── Recent Orders (Buyer Feed) ────────────────────────────
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Orders")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Theme.titleText)
                        .padding(.horizontal, 20)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(buyerOrders) { order in
                                NavigationLink(destination: BuyerOrderDetailView(order: order)) {
                                    BuyerOrderCard(order: order)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 4)
                    }
                }

                // ── Community ────────────────────────────────────────────
                VStack(alignment: .leading, spacing: 12) {
                    Text("Community")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Theme.titleText)
                        .padding(.horizontal, 20)

                    RoundedRectangle(cornerRadius: 14)
                        .fill(Theme.fieldBackground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .overlay(
                            VStack(spacing: 6) {
                                Image(systemName: "person.3")
                                    .font(.system(size: 24))
                                    .foregroundColor(Theme.subtitleText)
                                Text("Coming Soon")
                                    .font(.system(size: 13))
                                    .foregroundColor(Theme.subtitleText)
                            }
                        )
                        .padding(.horizontal, 20)
                }

                Spacer(minLength: 40)
            }
        }
        .background(Theme.cardBackground)
        .navigationBarHidden(true)
        .sheet(isPresented: $showUpgrade) { UpgradeView() }
    }
}

// MARK: - Pro Quick Access Tile
struct ProQuickTile: View {
    let icon: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 14).fill(color.opacity(0.12)).frame(width: 56, height: 56)
                Image(systemName: icon).font(.system(size: 22)).foregroundColor(color)
            }
            Text(label).font(.system(size: 11, weight: .semibold)).foregroundColor(Theme.titleText)
        }
        .frame(width: 80)
        .padding(.vertical, 14)
        .background(Theme.cardBackground)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Current Value Card
struct CurrentValueCard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16).fill(Theme.appGradient)
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Current Value")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Theme.subtitleText)
                    HStack(alignment: .bottom, spacing: 3) {
                        Text("PKR").font(.system(size: 13, weight: .medium)).foregroundColor(Theme.titleText).padding(.bottom, 7)
                        Text("240").font(.system(size: 44, weight: .bold)).foregroundColor(Theme.titleText)
                        Text(".00").font(.system(size: 20, weight: .medium)).foregroundColor(Theme.titleText).padding(.bottom, 7)
                    }
                    Button {} label: {
                        HStack(spacing: 7) {
                            Image(systemName: "tablecells").font(.system(size: 13))
                            Text("Calculator").font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 18).padding(.vertical, 10)
                        .background(Color(hex: "#1A1A1A")).cornerRadius(10)
                    }
                }
                .padding(.leading, 20).padding(.vertical, 20)
                Spacer()
                LogoView(size: 90).opacity(0.55).padding(.trailing, 16).padding(.top, 20)
            }
        }
        .frame(height: 165)
    }
}

// MARK: - Subscription Banner
struct SubscriptionBanner: View {
    let onDismiss: () -> Void
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 14).fill(Color(hex: "#1A1208"))
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Subscription").font(.system(size: 13, weight: .semibold)).foregroundColor(.white)
                    Text("Trial ends in 3 days!").font(.system(size: 11)).foregroundColor(.white.opacity(0.55))
                }
                HStack {
                    Text("Basic Plan").font(.system(size: 19, weight: .bold)).foregroundColor(.white)
                    Spacer()
                    Button {} label: {
                        Text("Manage Subscription")
                            .font(.system(size: 11, weight: .medium)).foregroundColor(.white)
                            .padding(.horizontal, 12).padding(.vertical, 7)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.35), lineWidth: 1))
                    }
                }
            }.padding(16)
            Button(action: onDismiss) {
                Image(systemName: "xmark").font(.system(size: 9, weight: .bold)).foregroundColor(.white.opacity(0.55)).padding(10)
            }
        }
    }
}

// MARK: - Buyer Order Card (horizontal scroll on Home tab)
struct BuyerOrderCard: View {
    let order: BuyerOrder

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image / header area
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(LinearGradient(
                        colors: [Color(hex: "#C8B89A"), Color(hex: "#A89070")],
                        startPoint: .topLeading, endPoint: .bottomTrailing))
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white.opacity(0.35))
                    .frame(maxWidth: .infinity, alignment: .center)

                // Online status pill
                HStack(spacing: 4) {
                    Circle()
                        .fill(order.onlineStatus == "Online" ? Color.green : Color.orange)
                        .frame(width: 5, height: 5)
                    Text(order.onlineStatus)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.35))
                .cornerRadius(10)
                .padding(8)
            }
            .frame(width: 185, height: 100)
            .clipped()

            // Info area
            VStack(alignment: .leading, spacing: 6) {
                // Buyer name + verified
                HStack(spacing: 5) {
                    Text(order.buyerName)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Theme.titleText)
                        .lineLimit(1)
                    if order.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "#27AE60"))
                    }
                }

                // Location
                HStack(spacing: 3) {
                    Image(systemName: "mappin")
                        .font(.system(size: 9))
                        .foregroundColor(Theme.subtitleText)
                    Text(order.location)
                        .font(.system(size: 10))
                        .foregroundColor(Theme.subtitleText)
                        .lineLimit(1)
                }

                // Paper type + quantity
                HStack(spacing: 6) {
                    Text(order.paperType)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Theme.linkText)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Theme.linkText.opacity(0.1))
                        .cornerRadius(6)
                    Text("\(Int(order.quantityKg)) kg")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.subtitleText)
                }

                // Offer price
                Text("PKR \(Int(order.offerPerKg))/kg")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Theme.titleText)
            }
            .padding(10)
        }
        .frame(width: 185)
        .background(Theme.cardBackground)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 3)
    }
}

// MARK: - Circle Icon Button
struct CircleIconButton: View {
    let systemName: String
    var action: () -> Void = {}
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName).font(.system(size: 14)).foregroundColor(Theme.subtitleText)
                .frame(width: 38, height: 38).background(Theme.iconBackground).clipShape(Circle())
        }
    }
}

// MARK: - Placeholder Tab Views
struct PlaceholderTabView: View {
    let title: String
    let icon: String
    var body: some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: icon).font(.system(size: 44)).foregroundColor(Theme.subtitleText.opacity(0.5))
            Text(title).font(.system(size: 22, weight: .semibold)).foregroundColor(Theme.titleText)
            Text("Coming soon").font(.system(size: 14)).foregroundColor(Theme.subtitleText)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity).background(Theme.cardBackground)
    }
}

// BuyerOrder and other shared models are defined in Models/SharedModels.swift
