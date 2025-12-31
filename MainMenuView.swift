//
//  Project: SortMyStuff
//  File: MainMenuView.swift
//  Created by Noah Carpenter
//  🐱 Follow me on YouTube! 🎥
//  https://www.youtube.com/@NoahDoesCoding97
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
//  Dream Big, Code Bigger
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var data: DataManager

    // Branding
    private let brandGradient = LinearGradient(
        colors: [Color.green.opacity(0.85), Color.teal.opacity(0.85), Color.blue.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    private let cardGradient = LinearGradient(
        colors: [Color.white.opacity(0.25), Color.white.opacity(0.10)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                brandGradient
                    .ignoresSafeArea()

                // Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        header

                        VStack(spacing: 16) {
                            NavigationLink(destination: SortingChallengeView()) {
                                MenuCard(
                                    icon: "arrow.3.trianglepath",
                                    iconColor: .green,
                                    title: "Sorting Challenge",
                                    subtitle: "Test your skills and learn what goes where."
                                )
                            }
                            .accessibilityLabel("Sorting Challenge. Test your recycling skills.")

                            NavigationLink(destination: HelpMeSortView()) {
                                MenuCard(
                                    icon: "questionmark.circle.fill",
                                    iconColor: .teal,
                                    title: "Help Me Sort",
                                    subtitle: "Snap a photo or search to sort responsibly."
                                )
                            }
                            .accessibilityLabel("Help Me Sort. Get assistance sorting items.")

                            NavigationLink(destination: ConsumptionTrackerView()) {
                                MenuCard(
                                    icon: "leaf.circle.fill",
                                    iconColor: .mint,
                                    title: "Track Consumption",
                                    subtitle: "Build better habits and reduce waste."
                                )
                            }
                            .accessibilityLabel("Track Consumption. Build better habits.")
                        }
                        .padding(.horizontal)

                        Spacer(minLength: 12)

                        footerNote
                            .padding(.horizontal)
                            .padding(.bottom, 24)
                    }
                    .padding(.top, 24)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .symbolRenderingMode(.monochrome)
                            .padding(8)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.white.opacity(0.25), lineWidth: 1))
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    .accessibilityLabel("Settings")
                    .accessibilityHint("Open settings")
                }
            }
            .navigationTitle("TrashSort Challenge")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            // Future: trigger any onboarding or analytics here
        }
    }

    // MARK: - Header
    private var header: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .frame(width: 88, height: 88)
                    .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 8)

                Image(systemName: "arrow.3.trianglepath")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.white.opacity(0.95), Color.green)
                    .font(.system(size: 40, weight: .bold))
            }

            VStack(spacing: 4) {
                Text("Recycle Smarter")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(radius: 0.5)
                Text("Sort waste. Save resources. Consume responsibly.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
        .padding(.bottom, 8)
    }

    // MARK: - Footer
    private var footerNote: some View {
        HStack(spacing: 8) {
            Image(systemName: "globe.americas.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.white.opacity(0.9))
            Text("Every choice counts. Join the movement for a cleaner planet.")
                .foregroundStyle(.white.opacity(0.95))
                .font(.system(.footnote, design: .rounded))
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - Menu Card
private struct MenuCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(iconColor.opacity(0.35))
                    .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(Color.white.opacity(0.25), lineWidth: 1))
                Image(systemName: icon)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, iconColor)
                    .font(.system(size: 24, weight: .semibold))
                    .accessibilityHidden(true)
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(2)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white.opacity(0.95))
                .accessibilityHidden(true)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 8)
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .hoverEffect(.highlight)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: UUID())
    }
}

// MARK: - Preview
#Preview {
    MainMenuView()
        .environmentObject(DataManager())
}
