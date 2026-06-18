//
    // Project: SortMyStuff
    //  File: WasteLog.swift
    //  Created by Noah Carpenter
    //  🐱 Follow me on YouTube! 🎥
    //  https://www.youtube.com/@noahdoescoding
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
    //  Dream Big, Code Bigger
import Foundation
    
struct WasteLog: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let category: WasteCategory
}
