//
    // Project: SortMyStuff
    //  File: WasteCategory.swift
    //  Created by Noah Carpenter
    //  🐱 Follow me on YouTube! 🎥
    //  https://www.youtube.com/@NoahDoesCoding97
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
    //  Dream Big, Code Bigger
    

import SwiftUI

enum WasteCategory: String, Codable, CaseIterable, Identifiable {
    case recycle
    case compost
    case landfill
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .recycle: return .blue
        case .compost: return .green
        case .landfill: return .gray
        }
    }
    
    var displayName: String {
        rawValue.capitalized
    }
}
