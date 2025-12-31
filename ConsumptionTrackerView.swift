//
//  Project: SortMyStuff
//  File: ConsumptionTrackerView.swift
//  Created by Noah Carpenter
//  🐱 Follow me on YouTube! 🎥
//  https://www.youtube.com/@NoahDoesCoding97
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
//  Dream Big, Code Bigger

import SwiftUI

/// Main waste tracking interface with tabs for overview, insights, and history
struct ConsumptionTrackerView: View {
    @StateObject private var tracker = ConsumptionTracker()
    @State private var selectedTab: TrackerTab = .overview
    @State private var showingHistory = false
    @Namespace private var animation

    enum TrackerTab: String, CaseIterable {
        case overview = "Overview"
        case insights = "Insights"
        case history = "History"
        
        var icon: String {
            switch self {
            case .overview: return "house.fill"
            case .insights: return "chart.bar.fill"
            case .history: return "clock.fill"
            }
        }
    }

    private let brandGradient = LinearGradient(
        colors: [Color.green.opacity(0.85), Color.teal.opacity(0.85), Color.blue.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        ZStack {
            brandGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Tab Bar
                CustomTabBar(selectedTab: $selectedTab, animation: animation)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    overviewTab
                        .tag(TrackerTab.overview)
                    
                    insightsTab
                        .tag(TrackerTab.insights)
                    
                    historyTab
                        .tag(TrackerTab.history)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .navigationTitle("Waste Tracker")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(SensoryFeedbackModifier(trigger: selectedTab))
    }
    
    // MARK: - Overview Tab
    
    private var overviewTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                    .padding(.top, 4)
                    .padding(.horizontal)

                TodaySummaryCard(tracker: tracker)
                    .padding(.horizontal)
                
                // Quick action buttons for logging waste
                VStack(alignment: .leading, spacing: 12) {
                    Text("Log an Item")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                    
                    HStack(spacing: 14) {
                        CategoryActionButton(
                            title: "Trash",
                            subtitle: "Landfill",
                            systemImage: "trash.fill",
                            gradient: Gradient(colors: [Color.gray, Color.gray.opacity(0.8)]),
                            action: { 
                                tracker.log(.landfill)
                            }
                        )

                        CategoryActionButton(
                            title: "Recycling",
                            subtitle: "Paper/Plastic",
                            systemImage: "arrow.2.circlepath",
                            gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.85)]),
                            action: { 
                                tracker.log(.recycle)
                            }
                        )

                        CategoryActionButton(
                            title: "Compost",
                            subtitle: "Food/Organic",
                            systemImage: "leaf.fill",
                            gradient: Gradient(colors: [Color.green, Color.green.opacity(0.85)]),
                            action: { 
                                tracker.log(.compost)
                            }
                        )
                    }
                    .padding(.horizontal)
                }

                WeeklyStatsCard(tracker: tracker)
                    .padding(.horizontal)
                
                TipCard(tip: tracker.tip)
                    .padding(.horizontal)

                Spacer(minLength: 20)
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - Insights Tab
    
    private var insightsTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                ImpactMetricsCard(tracker: tracker)
                    .padding(.horizontal)
                    .padding(.top)
                
                StreakCard(streak: tracker.currentStreak)
                    .padding(.horizontal)
                
                WeeklyChartCard(data: tracker.last7DaysData)
                    .padding(.horizontal)
                
                DiversionRateCard(diversionRate: tracker.diversionRate)
                    .padding(.horizontal)
                
                Spacer(minLength: 20)
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - History Tab
    
    private var historyTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                if tracker.recentLogs.isEmpty {
                    EmptyHistoryView()
                        .padding(.top, 60)
                } else {
                    ForEach(tracker.recentLogs) { log in
                        HistoryRow(log: log, onDelete: {
                            withAnimation {
                                tracker.deleteLog(log)
                            }
                        })
                        .padding(.horizontal)
                    }
                }
                
                Spacer(minLength: 20)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Sensory Feedback Modifier

/// Applies haptic feedback on iOS 17+
private struct SensoryFeedbackModifier: ViewModifier {
    let trigger: ConsumptionTrackerView.TrackerTab
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .sensoryFeedback(.impact(flexibility: .soft), trigger: trigger)
        } else {
            content
        }
    }
}

// MARK: - Header
private extension ConsumptionTrackerView {
    var header: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.ultraThinMaterial)
                Image(systemName: "leaf.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white.opacity(0.95), .green)
                    .font(.system(size: 28, weight: .bold))
            }
            .frame(width: 52, height: 52)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 6)

            VStack(alignment: .leading, spacing: 2) {
                Text("Track Your Waste")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                Text("Build better habits and reduce waste.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
            }
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Track your waste. Build better habits and reduce waste.")
    }
}

// MARK: - Custom Tab Bar

/// Animated tab selector with matched geometry effect
private struct CustomTabBar: View {
    @Binding var selectedTab: ConsumptionTrackerView.TrackerTab
    let animation: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(ConsumptionTrackerView.TrackerTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 16, weight: .semibold))
                        Text(tab.rawValue)
                            .font(.system(.caption, design: .rounded, weight: .medium))
                    }
                    .foregroundStyle(selectedTab == tab ? .white : .white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background {
                        if selectedTab == tab {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.thinMaterial.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Today's Summary Card

/// Displays today's waste counts by category
private struct TodaySummaryCard: View {
    @ObservedObject var tracker: ConsumptionTracker
    
    var body: some View {
        let counts = tracker.todayCounts
        
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "calendar")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
                Text("Today")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Text("\(tracker.todayTotal) items")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }
            
            HStack(spacing: 12) {
                StatPill(icon: "trash.fill", count: counts.trash, color: .gray)
                StatPill(icon: "arrow.2.circlepath", count: counts.recycle, color: .blue)
                StatPill(icon: "leaf.fill", count: counts.compost, color: .green)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 10)
    }
}

private struct StatPill: View {
    let icon: String
    let count: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
            Text("\(count)")
                .font(.system(.subheadline, design: .rounded, weight: .bold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(color.opacity(0.2))
                .overlay(
                    Capsule()
                        .strokeBorder(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Weekly Stats Card

/// Shows weekly breakdown with progress bars
private struct WeeklyStatsCard: View {
    @ObservedObject var tracker: ConsumptionTracker
    
    var body: some View {
        let counts = tracker.counts
        
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "chart.bar.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
                Text("This Week")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Text("\(tracker.weeklyTotal) items")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }
            
            VStack(spacing: 10) {
                CategoryBar(
                    title: "Trash",
                    count: counts.trash,
                    total: tracker.weeklyTotal,
                    color: .gray,
                    icon: "trash.fill"
                )
                
                CategoryBar(
                    title: "Recycling",
                    count: counts.recycle,
                    total: tracker.weeklyTotal,
                    color: .blue,
                    icon: "arrow.2.circlepath"
                )
                
                CategoryBar(
                    title: "Compost",
                    count: counts.compost,
                    total: tracker.weeklyTotal,
                    color: .green,
                    icon: "leaf.fill"
                )
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 10)
    }
}

private struct CategoryBar: View {
    let title: String
    let count: Int
    let total: Int
    let color: Color
    let icon: String
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(.white.opacity(0.9))
                Spacer()
                Text("\(count)")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(Color.white.opacity(0.15))
                    
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(color)
                        .frame(width: geometry.size.width * percentage)
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Category Button

/// Action button for logging waste items
private struct CategoryActionButton: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let gradient: Gradient
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .semibold))
                Text(title)
                    .font(.system(.headline, design: .rounded))
                Text(subtitle)
                    .font(.system(.footnote, design: .rounded))
                    .opacity(0.9)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title). \(subtitle)")
        .accessibilityHint("Double tap to log an item to this category")
    }
}

// MARK: - Tip Card
private struct TipCard: View {
    let tip: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundStyle(.yellow)
                .font(.system(size: 20))
            VStack(alignment: .leading, spacing: 4) {
                Text("Eco Tip")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                Text(tip)
                    .font(.system(.callout, design: .rounded))
                    .foregroundStyle(.white.opacity(0.95))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 10)
    }
}

// MARK: - Impact Metrics Card

/// Environmental impact stats (CO2 saved, diversion rate)
private struct ImpactMetricsCard: View {
    @ObservedObject var tracker: ConsumptionTracker
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "leaf.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .green)
                Text("Your Impact")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
            }
            
            HStack(spacing: 12) {
                MetricBox(
                    value: String(format: "%.1f", tracker.estimatedCO2Saved),
                    unit: "kg",
                    label: "CO₂ Saved",
                    icon: "cloud.fill",
                    color: .mint
                )
                
                MetricBox(
                    value: "\(Int(tracker.diversionRate * 100))",
                    unit: "%",
                    label: "Diverted",
                    icon: "arrow.triangle.branch",
                    color: .cyan
                )
            }
            
            Text("By recycling and composting, you're helping reduce greenhouse gas emissions and conserve natural resources.")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 10)
    }
}

private struct MetricBox: View {
    let value: String
    let unit: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(color)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                Text(unit)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Text(label)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Streak Card

/// Displays consecutive days of eco-friendly behavior
private struct StreakCard: View {
    let streak: Int
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.orange, .orange.opacity(0.7)],
                            center: .center,
                            startRadius: 5,
                            endRadius: 30
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(streak) Day\(streak != 1 ? "s" : "")")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                Text("Current Streak")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                if streak > 0 {
                    Text("Keep it up!")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.orange)
                } else {
                    Text("Log a recycle or compost to start!")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 10)
    }
}

// MARK: - Weekly Chart Card

/// 7-day stacked bar chart
private struct WeeklyChartCard: View {
    let data: [(date: Date, trash: Int, recycle: Int, compost: Int)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "chart.xyaxis.line")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
                Text("7-Day Trend")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
            }
            
            MiniBarChart(data: data)
                .frame(height: 120)
            
            // Legend for chart categories
            HStack(spacing: 16) {
                LegendItem(color: .gray, label: "Trash")
                LegendItem(color: .blue, label: "Recycle")
                LegendItem(color: .green, label: "Compost")
            }
            .font(.system(.caption, design: .rounded))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 10)
    }
}

private struct LegendItem: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
                .foregroundStyle(.white.opacity(0.9))
        }
    }
}

private struct MiniBarChart: View {
    let data: [(date: Date, trash: Int, recycle: Int, compost: Int)]
    
    private var maxValue: Int {
        data.map { $0.trash + $0.recycle + $0.compost }.max() ?? 1
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, day in
                VStack(spacing: 4) {
                    VStack(spacing: 2) {
                        BarSegment(value: day.compost, max: maxValue, color: .green)
                        BarSegment(value: day.recycle, max: maxValue, color: .blue)
                        BarSegment(value: day.trash, max: maxValue, color: .gray)
                    }
                    
                    Text(dayLabel(for: day.date))
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func dayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return String(formatter.string(from: date).prefix(1))
    }
}

private struct BarSegment: View {
    let value: Int
    let max: Int
    let color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .fill(color)
            .frame(height: CGFloat(value) / CGFloat(max) * 80)
            .frame(maxHeight: 80, alignment: .bottom)
    }
}

// MARK: - Diversion Rate Card

/// Circular progress indicator for waste diversion percentage
private struct DiversionRateCard: View {
    let diversionRate: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
                Text("Waste Diversion")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
            }
            
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 12)
                
                Circle()
                    .trim(from: 0, to: diversionRate)
                    .stroke(
                        LinearGradient(
                            colors: [.green, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text("\(Int(diversionRate * 100))%")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Diverted")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .frame(width: 140, height: 140)
            .frame(maxWidth: .infinity)
            
            Text("Percentage of waste diverted from landfills through recycling and composting.")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 10)
    }
}

// MARK: - History Row

/// Individual log entry with delete option
private struct HistoryRow: View {
    let log: WasteLog
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(log.category.color.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: iconForCategory(log.category))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(log.category.color)
            }
            
            // Details
            VStack(alignment: .leading, spacing: 2) {
                Text(log.category.displayName)
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white)
                Text(formattedDate(log.date))
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            // Delete button
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.red)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    /// Returns SF Symbol name for waste category
    private func iconForCategory(_ category: WasteCategory) -> String {
        switch category {
        case .landfill: return "trash.fill"
        case .recycle: return "arrow.2.circlepath"
        case .compost: return "leaf.fill"
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Empty History View
private struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.badge.questionmark")
                .font(.system(size: 60, weight: .light))
                .foregroundStyle(.white.opacity(0.5))
            
            Text("No History Yet")
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(.white)
            
            Text("Start logging your waste to see your history here.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        ConsumptionTrackerView()
    }
}
