//
    // Project: SortMyStuff
    //  File: TrashItem.swift
    //  Created by Noah Carpenter
    //  🐱 Follow me on YouTube! 🎥
    //  https://www.youtube.com/@NoahDoesCoding97
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
    //  Dream Big, Code Bigger
    

import Foundation
import SwiftUI
import Combine

struct TrashItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let imageName: String
    let baseCategory: WasteCategory
    let subcategory: WasteSubcategory?
    let fact: String
    let keywords: [String]
}
