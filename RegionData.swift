//
    // Project: SortMyStuff
    //  File: RegionData.swift
    //  Created by Noah Carpenter
    //  🐱 Follow me on YouTube! 🎥
    //  https://www.youtube.com/@NoahDoesCoding97
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
    //  Dream Big, Code Bigger
    


import Foundation

struct RegionData {

    // MARK: - Ontario
    static let ontario = RegionRules(
        regionName: "Ontario",
        overrides: [
            "pizza_box": .init(category: .compost, subcategory: .paper),
            "paper_cup": .init(category: .landfill, subcategory: .paper),
            "bread_bag": .init(category: .landfill, subcategory: .plastic),
            "plastic_straw": .init(category: .landfill, subcategory: .plastic),
            "plastic_cutlery": .init(category: .landfill, subcategory: .plastic),
            "glass_bottle": .init(category: .recycle, subcategory: .glass),
            "glass_jar": .init(category: .recycle, subcategory: .glass),
            "tin_can": .init(category: .recycle, subcategory: .metal),
            "aluminum_can": .init(category: .recycle, subcategory: .metal),
            "paper_bag": .init(category: .recycle, subcategory: .paper),
            "milk_carton": .init(category: .recycle, subcategory: .paper),
            "yogurt_cup": .init(category: .recycle, subcategory: .plastic)
        ]
    )

    // MARK: - British Columbia
    static let bc = RegionRules(
        regionName: "British Columbia",
        overrides: [
            "pizza_box": .init(category: .compost, subcategory: .paper),
            "paper_cup": .init(category: .landfill, subcategory: .paper),
            "bread_bag": .init(category: .landfill, subcategory: .plastic),
            "plastic_straw": .init(category: .landfill, subcategory: .plastic),
            "yogurt_cup": .init(category: .recycle, subcategory: .plastic),
            "milk_carton": .init(category: .recycle, subcategory: .paper),
            "plastic_bottle": .init(category: .recycle, subcategory: .plastic),
            "glass_bottle": .init(category: .recycle, subcategory: .glass),
            "tin_can": .init(category: .recycle, subcategory: .metal)
        ]
    )

    // MARK: - California
    static let california = RegionRules(
        regionName: "California",
        overrides: [
            "pizza_box": .init(category: .compost, subcategory: .paper),
            "paper_cup": .init(category: .landfill, subcategory: .paper),
            "bread_bag": .init(category: .landfill, subcategory: .plastic),
            "plastic_straw": .init(category: .landfill, subcategory: .plastic),
            "plastic_cutlery": .init(category: .landfill, subcategory: .plastic),
            "glass_bottle": .init(category: .recycle, subcategory: .glass),
            "glass_jar": .init(category: .recycle, subcategory: .glass),
            "aluminum_can": .init(category: .recycle, subcategory: .metal),
            "tin_can": .init(category: .recycle, subcategory: .metal),
            "yogurt_cup": .init(category: .recycle, subcategory: .plastic),
            "milk_carton": .init(category: .recycle, subcategory: .paper)
        ]
    )

    // MARK: - United Kingdom
    static let uk = RegionRules(
        regionName: "United Kingdom",
        overrides: [
            "pizza_box": .init(category: .recycle, subcategory: .paper),
            "paper_cup": .init(category: .landfill, subcategory: .paper),
            "bread_bag": .init(category: .landfill, subcategory: .plastic),
            "plastic_straw": .init(category: .landfill, subcategory: .plastic),
            "plastic_cutlery": .init(category: .landfill, subcategory: .plastic),
            "glass_bottle": .init(category: .recycle, subcategory: .glass),
            "glass_jar": .init(category: .recycle, subcategory: .glass),
            "aluminum_can": .init(category: .recycle, subcategory: .metal),
            "tin_can": .init(category: .recycle, subcategory: .metal),
            "paper_bag": .init(category: .recycle, subcategory: .paper),
            "milk_carton": .init(category: .recycle, subcategory: .paper),
            "yogurt_cup": .init(category: .recycle, subcategory: .plastic)
        ]
    )

    // MARK: - Australia
    static let australia = RegionRules(
        regionName: "Australia",
        overrides: [
            "pizza_box": .init(category: .compost, subcategory: .paper),
            "paper_cup": .init(category: .landfill, subcategory: .paper),
            "bread_bag": .init(category: .landfill, subcategory: .plastic),
            "plastic_straw": .init(category: .landfill, subcategory: .plastic),
            "plastic_cutlery": .init(category: .landfill, subcategory: .plastic),
            "plastic_bottle": .init(category: .recycle, subcategory: .plastic),
            "plastic_container": .init(category: .recycle, subcategory: .plastic),
            "yogurt_cup": .init(category: .recycle, subcategory: .plastic),
            "aluminum_can": .init(category: .recycle, subcategory: .metal),
            "tin_can": .init(category: .recycle, subcategory: .metal),
            "glass_bottle": .init(category: .recycle, subcategory: .glass),
            "glass_jar": .init(category: .recycle, subcategory: .glass),
            "cardboard": .init(category: .recycle, subcategory: .paper),
            "paper_bag": .init(category: .recycle, subcategory: .paper),
            "milk_carton": .init(category: .recycle, subcategory: .paper),
            "tissue": .init(category: .compost, subcategory: .paper),
            "napkin": .init(category: .compost, subcategory: .paper),
            "bread": .init(category: .compost, subcategory: .organic),
            "tea_bag": .init(category: .compost, subcategory: .organic),
            "apple_core": .init(category: .compost, subcategory: .organic),
            "banana_peel": .init(category: .compost, subcategory: .organic),
            "coffee_grounds": .init(category: .compost, subcategory: .organic)
        ]
    )

    // MARK: - All Regions
    static let all: [RegionRules] = [
        ontario,
        bc,
        california,
        uk,
        australia
    ]
}