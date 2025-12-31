import SwiftUI

@main
struct MyApp: App {
    @StateObject private var dataManager = DataManager()

    var body: some Scene {
        WindowGroup {
            MainMenuView()
            
                .environmentObject(dataManager)
        }
    }
}
