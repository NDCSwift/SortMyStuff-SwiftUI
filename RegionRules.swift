//
    // Project: SortMyStuff
    //  File: RegionRules.swift
    //  Created by Noah Carpenter
    //  🐱 Follow me on YouTube! 🎥
    //  https://www.youtube.com/@noahdoescoding
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
    //  Dream Big, Code Bigger
    

import Foundation

struct RegionRules: Identifiable, Codable {
    let id = UUID()
    let regionName: String
    let overrides: [String: RuleOverride]
    
    struct RuleOverride: Codable {
        let category: WasteCategory
        let subcategory: WasteSubcategory?
    }
}
