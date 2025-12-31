//
// Project: SortMyStuff
//  File: DataManager.swift
//  Created by Noah Carpenter
//  🐱 Follow me on YouTube! 🎥
//  https://www.youtube.com/@NoahDoesCoding97
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
//  Dream Big, Code Bigger

import Foundation
import Combine
import SwiftUI
import Playgrounds

@MainActor
class DataManager: ObservableObject {
    @Published var items: [TrashItem] = []
    @Published var regions: [RegionRules] = []
    
    private let selectedRegionKey = "selectedRegionName"
    @Published var selectedRegion: RegionRules? {
        didSet {
            if let name = selectedRegion?.regionName {
                UserDefaults.standard.set(name, forKey: selectedRegionKey)
                print("[DataManager] Persisted selected region: \(name)")
            } else {
                UserDefaults.standard.removeObject(forKey: selectedRegionKey)
                print("[DataManager] Cleared selected region preference")
            }
        }
    }
    
    func loadItems() {
        items = ItemsData.all
        print("[DataManager] Loaded \(items.count) items (static Swift).")
    }
    
    func loadRegions() {
        regions = RegionData.all
        print("[DataManager] Total regions loaded (static Swift): \(regions.count)")
    }
    
    func category(for item: TrashItem) -> WasteCategory {
        if let region = selectedRegion,
           let override = region.overrides[item.imageName] {
            return override.category
        }
        return item.baseCategory
    }
}

