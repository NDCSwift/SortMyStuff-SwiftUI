//
//  SortingChallengeView.swift
//  SortMyStuff
//
//  Core mini-game view: timed sorting round with scoring, feedback, accessibility, and high score.
//

import SwiftUI
import UIKit

struct SortingChallengeView: View {
    @EnvironmentObject var data: DataManager
    @StateObject var engine = GameEngine()

    // Game session state
    @State private var isPlaying: Bool = false
    @State private var showEndSheet: Bool = false
    @State private var showFactBanner: Bool = false
    @State private var factBannerText: String = ""
    @State private var itemAppear: Bool = true

    // Local high score
    @AppStorage("bestScore") private var bestScore: Int = 0
    @AppStorage("leaderboardTop5") private var leaderboardData: Data = Data()
    @State private var leaderboard: [Int] = []

    // Branding gradient (consistent with app)
    private let brandGradient = LinearGradient(
        colors: [Color.green.opacity(0.85), Color.teal.opacity(0.85), Color.blue.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        ZStack {
            // Background
            brandGradient
                .ignoresSafeArea()

            VStack(spacing: 16) {
                header
                itemArea
                bins
                Spacer(minLength: 12)
            }
            .padding()

            // Educational / feedback banner
            if showFactBanner {
                VStack {
                    Text(factBannerText)
                        .font(.system(.callout, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule(style: .continuous)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Capsule(style: .continuous)
                                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                                )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 8)
                        .accessibilityAddTraits(.isStaticText)
                    Spacer()
                }
                .padding(.top, 12)
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(2)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Ensure static data is loaded
            if data.items.isEmpty { data.loadItems() }
            if data.regions.isEmpty { data.loadRegions() }

            // Restore previously selected region, if any
            if data.selectedRegion == nil,
               let savedName = UserDefaults.standard.string(forKey: "selectedRegionName"),
               let match = data.regions.first(where: { $0.regionName == savedName }) {
                data.selectedRegion = match
                print("[SortingChallenge] Restored selected region: \(match.regionName)")
            }

            print("[SortingChallenge] View appeared. Starting game…")
            startGame()
        }
        .onChange(of: engine.timeRemaining) { newValue in
            if newValue <= 0, isPlaying {
                print("[SortingChallenge] Time reached 0. Ending game.")
                endGame()
            }
        }
        .sheet(isPresented: $showEndSheet) {
            endOfGameSheet
        }
        .onChange(of: engine.score) { newScore in
            print("[SortingChallenge] Score updated: \(newScore)")
        }
        .onChange(of: engine.currentItem?.imageName ?? "") { newName in
            if !newName.isEmpty {
                print("[SortingChallenge] Showing item: \(newName)")
            }
        }
        .onReceive(data.$selectedRegion) { region in
            if let region = region {
                print("[SortingChallenge] Selected region changed: \(region.regionName). Future sorts will respect these rules.")
            } else {
                print("[SortingChallenge] No region selected. Using base categories.")
            }
        }
    }

    // MARK: - Header (Timer + Score)
    private var header: some View {
        HStack(spacing: 12) {
            Label(timerString(from: engine.timeRemaining), systemImage: "timer")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .monospacedDigit()
                .foregroundStyle(.white)
                .accessibilityLabel("Time remaining")
                .accessibilityValue(timerString(from: engine.timeRemaining))

            Spacer()

            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("\(engine.score)")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Score \(engine.score)")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 8)
    }

    // MARK: - Item Area
    private var itemArea: some View {
        Group {
            if let item = engine.currentItem {
                VStack(spacing: 10) {
                    // Large item image
                    Image(item.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 220)
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 6)
                        .padding(8)
                        .accessibilityLabel(Text(accessibilityName(for: item)))
                        .transition(.scale.combined(with: .opacity))
                        .opacity(itemAppear ? 1 : 0)

                    // Name label (fallbacks to imageName if no explicit name available)
                    Text(displayName(for: item))
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(.white)
                        .accessibilityHidden(true)
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.thinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                        )
                )
                .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 10)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "questionmark.square.dashed")
                        .font(.system(size: 80))
                        .foregroundStyle(.white.opacity(0.9))
                    Text("Get ready…")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .frame(height: 260)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: itemAppear)
    }

    // MARK: - Bins / Category Buttons
    private var bins: some View {
        HStack(spacing: 12) {
            ForEach(WasteCategory.allCases) { category in
                Button {
                    guard isPlaying, let item = engine.currentItem else { return }
                    let correct = data.category(for: item)
                    let wasCorrect = (category == correct)
                    print("[SortingChallenge] Tapped \(category.displayName) for item \(item.imageName). Correct: \(correct.displayName). Result: \(wasCorrect ? "correct" : "incorrect")")

                    // Haptics
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(wasCorrect ? .success : .error)

                    // Show quick educational banner on incorrect
                    if !wasCorrect {
                        showEducationalBanner(for: item, correct: correct)
                    }

                    // Animate item out and request next
                    withAnimation(.easeInOut(duration: 0.2)) {
                        itemAppear = false
                    }

                    // Delegate scoring + flow to engine
                    engine.sort(item: item, into: category, correctCategory: correct)

                    // Bring next item in with a small delay for a snappier feel
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            itemAppear = true
                        }
                    }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: iconName(for: category))
                            .font(.system(size: 22, weight: .semibold))
                        Text(category.displayName)
                            .font(.system(.headline, design: .rounded))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [category.color.opacity(0.95), category.color.opacity(0.85)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
                            )
                    )
                    .shadow(color: category.color.opacity(0.45), radius: 10, x: 0, y: 8)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("\(category.displayName) bin"))
                .accessibilityHint("Double tap to sort the item here")
                .accessibilityAddTraits(.isButton)
            }
        }
        .disabled(!isPlaying)
    }

    // MARK: - End of Game Sheet
    private var endOfGameSheet: some View {
        VStack(spacing: 16) {
            Text("Round Complete")
                .font(.system(.title, design: .rounded, weight: .bold))

            Text("Your score: \(engine.score)")
                .font(.system(.title2, design: .rounded))

            Text("Best score: \(bestScore)")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(engine.score >= bestScore ? .green : .secondary)

            if engine.score >= bestScore {
                Label("New High Score!", systemImage: "star.fill")
                    .foregroundStyle(.yellow)
            }

            HStack(spacing: 12) {
                Button(role: .cancel) {
                    showEndSheet = false
                } label: {
                    Text("Close")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    showEndSheet = false
                    startGame()
                } label: {
                    Text("Play Again")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.top, 6)

            VStack(alignment: .leading, spacing: 8) {
                Text("Top Scores")
                    .font(.system(.headline, design: .rounded))
                if leaderboard.isEmpty {
                    Text("No scores yet. Play a round to set your first score!")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                } else {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(Array(leaderboard.enumerated()), id: \.offset) { index, score in
                            HStack(spacing: 8) {
                                Text("\(index + 1).")
                                    .font(.system(.body, design: .rounded, weight: .semibold))
                                    .frame(width: 28, alignment: .trailing)
                                Text("\(score)")
                                    .font(.system(.body, design: .rounded))
                                Spacer()
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Rank \(index + 1), score \(score)")
                        }
                    }
                }
            }
            .padding(.top, 8)

            VStack(alignment: .leading, spacing: 8) {
                Text("Why it matters")
                    .font(.system(.headline, design: .rounded))
                Text("Sorting correctly helps reduce waste and supports Responsible Consumption & Production (SDG 12). Keep practicing to learn where everyday items belong!")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Helpers
    private func loadLeaderboard() -> [Int] {
        guard !leaderboardData.isEmpty else { return [] }
        do {
            return try JSONDecoder().decode([Int].self, from: leaderboardData)
        } catch {
            print("[SortingChallenge] Failed to decode leaderboard: \(error)")
            return []
        }
    }

    private func saveLeaderboard(_ scores: [Int]) {
        do {
            leaderboardData = try JSONEncoder().encode(scores)
        } catch {
            print("[SortingChallenge] Failed to encode leaderboard: \(error)")
        }
    }

    private func startGame() {
        isPlaying = true
        showEndSheet = false
        showFactBanner = false
        itemAppear = true
        leaderboard = loadLeaderboard()
        let count = data.items.count
        if let region = data.selectedRegion {
            print("[SortingChallenge] Starting new round with \(count) items. Region: \(region.regionName)")
        } else {
            print("[SortingChallenge] Starting new round with \(count) items. Region: <none>")
        }
        engine.start(items: data.items)
    }

    private func endGame() {
        isPlaying = false
        // Update high score
        if engine.score > bestScore { bestScore = engine.score }
        var scores = loadLeaderboard()
        scores.append(engine.score)
        scores.sort(by: >)
        if scores.count > 5 { scores = Array(scores.prefix(5)) }
        saveLeaderboard(scores)
        leaderboard = scores
        print("[SortingChallenge] Game ended. Final score: \(engine.score). Best: \(bestScore)")
        showEndSheet = true
    }

    private func timerString(from seconds: Int) -> String {
        let clamped = max(0, seconds)
        let m = clamped / 60
        let s = clamped % 60
        return String(format: "%01d:%02d", m, s)
    }

    private func showEducationalBanner(for item: TrashItem, correct: WasteCategory) {
        // Prefer human-friendly name; fallback to imageName
        let nameText = item.name.isEmpty ? item.imageName.capitalized : item.name
        let message = "\(nameText) belongs in \(correct.displayName)."
        print("[SortingChallenge] Teaching moment: \(message)")
        factBannerText = message
        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
            showFactBanner = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showFactBanner = false
            }
        }
    }

    private func iconName(for category: WasteCategory) -> String {
        switch category {
        case .recycle: return "arrow.2.circlepath"
        case .compost: return "leaf.fill"
        case .landfill: return "trash.fill"
        default: return "tray.fill" // in case WasteCategory has more cases
        }
    }

    private func displayName(for item: TrashItem) -> String {
        return item.name.isEmpty ? item.imageName.capitalized : item.name
    }

    private func accessibilityName(for item: TrashItem) -> String {
        displayName(for: item)
    }
}

