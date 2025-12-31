//
    // Project: SortMyStuff
    //  File: GameEngine.swift
    //  Created by Noah Carpenter
    //  🐱 Follow me on YouTube! 🎥
    //  https://www.youtube.com/@NoahDoesCoding97
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
    //  Dream Big, Code Bigger
    

import Foundation
import SwiftUI

@MainActor
class GameEngine: ObservableObject {
    @Published var currentItem: TrashItem?
    @Published var score: Int = 0
    @Published var timeRemaining: Int = 60
    @Published var isGameOver = false
    
    private var timer: Timer?
    var allItems: [TrashItem] = []
    
    func start(items: [TrashItem]) {
        allItems = items.shuffled()
        score = 0
        timeRemaining = 60
        isGameOver = false
        nextItem()
        startTimer()
    }
    
    func nextItem() {
        currentItem = allItems.randomElement()
    }
    
    func sort(item: TrashItem, into category: WasteCategory, correctCategory: WasteCategory) {
        if category == correctCategory {
            score += 1
        } else {
            score -= 1
        }
        nextItem()
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeRemaining -= 1
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
                self.isGameOver = true
            }
        }
    }
}
