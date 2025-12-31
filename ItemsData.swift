//
    // Project: SortMyStuff
    //  File: Untitled.swift
    //  Created by Noah Carpenter
    //  🐱 Follow me on YouTube! 🎥
    //  https://www.youtube.com/@NoahDoesCoding97
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
    //  Dream Big, Code Bigger
    
import Foundation

struct ItemsData {
    static let all: [TrashItem] = [
        
        // --- ORGANICS / COMPOST ---
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000001")!,
            name: "Banana Peel",
            imageName: "banana_peel",
            baseCategory: .compost,
            subcategory: .organic,
            fact: "Banana peels break down quickly and make great compost.",
            keywords: ["banana", "peel", "fruit", "food"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000002")!,
            name: "Apple Core",
            imageName: "apple_core",
            baseCategory: .compost,
            subcategory: .organic,
            fact: "Apple cores decompose naturally and belong in compost.",
            keywords: ["apple", "core", "fruit", "food"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000003")!,
            name: "Eggshells",
            imageName: "eggshells",
            baseCategory: .compost,
            subcategory: .organic,
            fact: "Eggshells add calcium to compost and break down over time.",
            keywords: ["egg", "shell", "breakfast"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000004")!,
            name: "Coffee Grounds",
            imageName: "coffee_grounds",
            baseCategory: .compost,
            subcategory: .organic,
            fact: "Coffee grounds are rich in nitrogen and perfect for compost.",
            keywords: ["coffee", "grounds"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000005")!,
            name: "Paper Towel",
            imageName: "paper_towel",
            baseCategory: .compost,
            subcategory: .paper,
            fact: "Used paper towels with no chemicals or oils can be composted.",
            keywords: ["paper", "towel", "napkin"]
        ),
        
        // --- PAPER / RECYCLING ---
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000006")!,
            name: "Cardboard",
            imageName: "cardboard",
            baseCategory: .recycle,
            subcategory: .paper,
            fact: "Clean cardboard is widely accepted in recycling.",
            keywords: ["cardboard", "box", "paper"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000007")!,
            name: "Newspaper",
            imageName: "newspaper",
            baseCategory: .recycle,
            subcategory: .paper,
            fact: "Newspapers can be recycled into new paper products.",
            keywords: ["newspaper", "paper", "news"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000008")!,
            name: "Office Paper",
            imageName: "office_paper",
            baseCategory: .recycle,
            subcategory: .paper,
            fact: "Clean office paper can be recycled easily.",
            keywords: ["paper", "office", "printer"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000009")!,
            name: "Envelopes",
            imageName: "envelope",
            baseCategory: .recycle,
            subcategory: .paper,
            fact: "Most envelopes can be recycled, even with plastic windows.",
            keywords: ["envelope", "mail", "paper"]
        ),
        
        // --- PLASTIC / RECYCLING ---
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000010")!,
            name: "Plastic Bottle",
            imageName: "plastic_bottle",
            baseCategory: .recycle,
            subcategory: .plastic,
            fact: "Plastic bottles can be recycled into new containers or textiles.",
            keywords: ["plastic", "bottle", "drink", "water"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000011")!,
            name: "Plastic Container",
            imageName: "plastic_container",
            baseCategory: .recycle,
            subcategory: .plastic,
            fact: "Clean plastic containers are widely recyclable.",
            keywords: ["plastic", "container", "food"]
        ),
        
        // --- METAL / RECYCLING ---
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000012")!,
            name: "Aluminum Can",
            imageName: "aluminum_can",
            baseCategory: .recycle,
            subcategory: .metal,
            fact: "Aluminum cans can be recycled endlessly with no quality loss.",
            keywords: ["aluminum", "can", "drink"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000013")!,
            name: "Tin Can",
            imageName: "tin_can",
            baseCategory: .recycle,
            subcategory: .metal,
            fact: "Tin cans can be recycled after rinsing leftover food.",
            keywords: ["tin", "can", "food"]
        ),
        
        // --- GLASS / RECYCLING ---
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000014")!,
            name: "Glass Bottle",
            imageName: "glass_bottle",
            baseCategory: .recycle,
            subcategory: .glass,
            fact: "Glass bottles are infinitely recyclable.",
            keywords: ["glass", "bottle", "drink"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000015")!,
            name: "Glass Jar",
            imageName: "glass_jar",
            baseCategory: .recycle,
            subcategory: .glass,
            fact: "Glass jars can be rinsed and recycled repeatedly.",
            keywords: ["glass", "jar", "container"]
        ),
        
        // --- CARTONS ---
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000016")!,
            name: "Milk Carton",
            imageName: "milk_carton",
            baseCategory: .recycle,
            subcategory: .paper,
            fact: "Milk cartons contain paper and can be recycled when clean.",
            keywords: ["milk", "carton", "paper"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000017")!,
            name: "Egg Carton",
            imageName: "egg_carton",
            baseCategory: .recycle,
            subcategory: .paper,
            fact: "Paper egg cartons are recyclable and biodegradable.",
            keywords: ["egg", "carton", "paper"]
        ),
        
        // --- FOOD WASTE ---
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000018")!,
            name: "Greasy Pizza Box",
            imageName: "pizza_box",
            baseCategory: .compost,
            subcategory: .paper,
            fact: "Greasy pizza boxes often belong in compost, not recycling.",
            keywords: ["pizza", "box", "cardboard"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000019")!,
            name: "Tea Bag",
            imageName: "tea_bag",
            baseCategory: .compost,
            subcategory: .organic,
            fact: "Most tea bags are compostable unless made with plastic mesh.",
            keywords: ["tea", "bag", "drink"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000020")!,
            name: "Bread",
            imageName: "bread",
            baseCategory: .compost,
            subcategory: .organic,
            fact: "Stale bread breaks down well in compost.",
            keywords: ["bread", "food", "slice"]
        ),
        
        // --- LANDFILL / MIXED MATERIALS ---
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000021")!,
            name: "Chip Bag",
            imageName: "chip_bag",
            baseCategory: .landfill,
            subcategory: .general,
            fact: "Chip bags are made of mixed materials and can't be recycled.",
            keywords: ["chip", "bag", "snack"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000022")!,
            name: "Candy Wrapper",
            imageName: "candy_wrapper",
            baseCategory: .landfill,
            subcategory: .general,
            fact: "Plastic/foil wrappers belong in landfill due to mixed materials.",
            keywords: ["candy", "wrapper", "snack"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000023")!,
            name: "Styrofoam Cup",
            imageName: "styrofoam_cup",
            baseCategory: .landfill,
            subcategory: .general,
            fact: "Most places do not recycle Styrofoam; it goes to landfill.",
            keywords: ["styrofoam", "cup"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000024")!,
            name: "Styrofoam Tray",
            imageName: "styrofoam_tray",
            baseCategory: .landfill,
            subcategory: .general,
            fact: "Food-soiled Styrofoam trays belong in landfill.",
            keywords: ["styrofoam", "tray"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000025")!,
            name: "Plastic Cutlery",
            imageName: "plastic_cutlery",
            baseCategory: .landfill,
            subcategory: .plastic,
            fact: "Most plastic cutlery is not recyclable due to its size and shape.",
            keywords: ["plastic", "fork", "knife", "cutlery"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000026")!,
            name: "Broken Mug",
            imageName: "broken_mug",
            baseCategory: .landfill,
            subcategory: .general,
            fact: "Ceramics like broken mugs cannot be recycled.",
            keywords: ["mug", "broken", "ceramic"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000027")!,
            name: "Toothbrush",
            imageName: "toothbrush",
            baseCategory: .landfill,
            subcategory: .plastic,
            fact: "Toothbrushes contain mixed plastics and typically go to landfill.",
            keywords: ["toothbrush", "brush", "teeth"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000028")!,
            name: "Paper Cup",
            imageName: "paper_cup",
            baseCategory: .landfill,
            subcategory: .paper,
            fact: "Most paper cups are lined with plastic that prevents recycling.",
            keywords: ["cup", "paper", "coffee"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000029")!,
            name: "Pizza Slice",
            imageName: "pizza_slice",
            baseCategory: .compost,
            subcategory: .organic,
            fact: "Leftover pizza scraps belong in compost when food waste is accepted.",
            keywords: ["pizza", "slice", "food"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000030")!,
            name: "Tissue",
            imageName: "tissue",
            baseCategory: .compost,
            subcategory: .paper,
            fact: "Used tissues can be composted unless heavily soiled with chemicals.",
            keywords: ["tissue", "kleenex"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000031")!,
            name: "Napkin",
            imageName: "napkin",
            baseCategory: .compost,
            subcategory: .paper,
            fact: "Napkins are compostable unless coated or laminated.",
            keywords: ["napkin", "paper"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000032")!,
            name: "Plastic Straw",
            imageName: "plastic_straw",
            baseCategory: .landfill,
            subcategory: .plastic,
            fact: "Plastic straws are too small to be recycled and go to landfill.",
            keywords: ["straw", "plastic"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000033")!,
            name: "Bread Bag",
            imageName: "bread_bag",
            baseCategory: .landfill,
            subcategory: .plastic,
            fact: "Soft plastic bags require special drop-off programs, not recycling bins.",
            keywords: ["bread", "bag", "plastic"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000034")!,
            name: "Paper Bag",
            imageName: "paper_bag",
            baseCategory: .recycle,
            subcategory: .paper,
            fact: "Clean paper bags are recyclable or compostable depending on region.",
            keywords: ["paper", "bag"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000035")!,
            name: "Yogurt Cup",
            imageName: "yogurt_cup",
            baseCategory: .recycle,
            subcategory: .plastic,
            fact: "Clean yogurt cups can be recycled in many regions.",
            keywords: ["yogurt", "cup", "plastic"]
        ),
        TrashItem(
            id: UUID(uuidString: "00000001-0001-0001-0001-000000000036")!,
            name: "Paper Plate",
            imageName: "paper_plate",
            baseCategory: .compost,
            subcategory: .paper,
            fact: "Uncoated paper plates can go into compost.",
            keywords: ["paper", "plate", "dishes"]
        )
    ]
}
