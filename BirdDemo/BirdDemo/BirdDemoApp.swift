
import RealityKit
import RealityKitContent
import SwiftUI

@main
struct BirdDemoApp: App {
    @State private var viewModel = ViewModel()

    init() {
        // register systems and components
    }

    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }.windowStyle(.plain)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(viewModel)
        }
    }
}
