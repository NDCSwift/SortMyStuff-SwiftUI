//
    // Project: SortMyStuff
    //  File: ConsumptionTracker.swift
    //  Created by Noah Carpenter
    //  🐱 Follow me on YouTube! 🎥
    //  https://www.youtube.com/@NoahDoesCoding97
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
    //  Dream Big, Code Bigger
    


import Foundation
import SwiftUI

@MainActor
class ConsumptionTracker: ObservableObject {

    @Published var logs: [WasteLog] = []

    private let saveKey = "wasteLogs"

    init() {
        load()
    }

    // MARK: - Logging
    func log(_ category: WasteCategory) {
        let entry = WasteLog(date: Date(), category: category)
        logs.append(entry)
        save()
    }
    
    func delete(at offsets: IndexSet) {
        logs.remove(atOffsets: offsets)
        save()
    }
    
    func deleteLog(_ log: WasteLog) {
        logs.removeAll { $0.id == log.id }
        save()
    }

    // MARK: - Weekly Stats
    private var thisWeeksLogs: [WasteLog] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return logs.filter { $0.date >= weekAgo }
    }
    
    // MARK: - Today's Stats
    var todaysLogs: [WasteLog] {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        return logs.filter { $0.date >= startOfDay }
    }
    
    var todayCounts: (trash: Int, recycle: Int, compost: Int) {
        var t = 0, r = 0, c = 0
        for log in todaysLogs {
            switch log.category {
            case .landfill: t += 1
            case .recycle: r += 1
            case .compost: c += 1
            }
        }
        return (t, r, c)
    }

    var counts: (trash: Int, recycle: Int, compost: Int) {
        var t = 0, r = 0, c = 0
        for log in thisWeeksLogs {
            switch log.category {
            case .landfill: t += 1
            case .recycle: r += 1
            case .compost: c += 1
            }
        }
        return (t, r, c)
    }
    
    var weeklyTotal: Int {
        let c = counts
        return c.trash + c.recycle + c.compost
    }
    
    var todayTotal: Int {
        let c = todayCounts
        return c.trash + c.recycle + c.compost
    }

    var summaryText: String {
        let c = counts
        return "Trash: \(c.trash)\nRecycling: \(c.recycle)\nCompost: \(c.compost)"
    }
    
    // MARK: - Environmental Impact
    /// Estimated kg of CO2 saved by recycling and composting vs landfill
    var estimatedCO2Saved: Double {
        let c = counts
        // Rough estimates: recycling saves ~0.5kg CO2, composting saves ~0.3kg CO2 per item
        return Double(c.recycle) * 0.5 + Double(c.compost) * 0.3
    }
    
    /// Percentage of waste diverted from landfill
    var diversionRate: Double {
        let c = counts
        let total = c.trash + c.recycle + c.compost
        guard total > 0 else { return 0 }
        return Double(c.recycle + c.compost) / Double(total)
    }
    
    // MARK: - Streaks & Achievements
    /// Current streak of days with at least one eco-friendly action (recycle or compost)
    var currentStreak: Int {
        guard !logs.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
        
        while true {
            let nextDay = calendar.date(byAdding: .day, value: 1, to: checkDate)!
            let logsForDay = logs.filter { log in
                let logDay = calendar.startOfDay(for: log.date)
                return logDay == checkDate && (log.category == .recycle || log.category == .compost)
            }
            
            if logsForDay.isEmpty {
                break
            }
            
            streak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
        }
        
        return streak
    }
    
    // MARK: - Historical Data
    /// Get logs grouped by day for the past 7 days
    var last7DaysData: [(date: Date, trash: Int, recycle: Int, compost: Int)] {
        let calendar = Calendar.current
        var data: [(date: Date, trash: Int, recycle: Int, compost: Int)] = []
        
        for dayOffset in (0..<7).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let logsForDay = logs.filter { $0.date >= startOfDay && $0.date < endOfDay }
            
            var t = 0, r = 0, c = 0
            for log in logsForDay {
                switch log.category {
                case .landfill: t += 1
                case .recycle: r += 1
                case .compost: c += 1
                }
            }
            
            data.append((date: startOfDay, trash: t, recycle: r, compost: c))
        }
        
        return data
    }
    
    /// Get recent logs sorted by date (most recent first)
    var recentLogs: [WasteLog] {
        logs.sorted { $0.date > $1.date }.prefix(50).map { $0 }
    }

    // MARK: - Tips
    var tip: String {
        let c = counts

        if c.trash > (c.recycle + c.compost) {
            return "Try reducing landfill waste by choosing reusable containers or buying in bulk."
        }

        if c.recycle > c.compost {
            return "Great recycling! Consider composting more organic waste when possible."
        }

        if c.compost > c.recycle {
            return "Amazing composting! Keep separating organics to reduce methane emissions."
        }

        return "Keep going! Small daily choices make a big environmental difference."
    }

    // MARK: - Persistence
    func save() {
        if let data = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([WasteLog].self, from: data) {
            logs = decoded
        }
    }
}
