import SwiftUI

@main
struct VRPlayerApp: App {
    @StateObject private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(container)
                .preferredColorScheme(.dark)
        }
    }
}
