# ♻️ SortMyStuff — TrashSort Challenge

A SwiftUI Playground app that teaches you how to sort and recycle waste correctly — with a sorting challenge game, a smart item lookup tool, and a consumption tracker.

---

## 🤔 What this is

SortMyStuff is a fully featured recycling education app built as a Swift Playgrounds package. It has three modes: a Sorting Challenge game that tests your knowledge of what goes where, a "Help Me Sort" lookup tool for identifying how to dispose of specific items, and a Consumption Tracker to build better waste habits. Sorting rules are region-aware, so advice adapts to where you live.

## ✅ Why you'd use it

- **Full app in Swift Playgrounds** — builds and runs as a `.swiftpm` package, no Xcode project required
- **Three-mode structure** — Sorting Challenge, Help Me Sort, and Consumption Tracker in one codebase
- **Region-aware rules** — `RegionData.swift` and `ItemsData.swift` drive location-specific sorting answers
- **Polished SwiftUI UI** — gradient cards, `NavigationStack`, accessibility labels, and `.hoverEffect`
- **`DataManager` + `@EnvironmentObject`** — clean MVVM state sharing across all views

---

## 🚀 Getting Started

### 1. Clone the Repo
```bash
git clone https://github.com/NDCSwift/SortMyStuff-SwiftUI.git
```

### 2. Open in Swift Playgrounds or Xcode
- Open `Package.swift` in Xcode, or open the folder directly in Swift Playgrounds on iPad/Mac.

### 3. Set Your Development Team
TARGET → Signing & Capabilities → Team

### 4. Update the Bundle Identifier
Change `com.example.MyApp` to a unique identifier.

---

## 🛠️ Notes
- Source files live at the package root (no nested folder).
- Customize sorting rules by editing `RegionData.swift` and `ItemsData.swift`.

## 📦 Requirements
- Swift Playgrounds 4+ or Xcode 16+
- iOS 17+
