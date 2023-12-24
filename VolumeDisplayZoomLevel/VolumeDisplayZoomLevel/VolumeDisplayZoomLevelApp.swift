
import RealityKit
import RealityKitContent
import SwiftUI

@main
struct InfiniteGPTApp: App {
    @State private var viewModel = ViewModel()

    init() {}

    var body: some SwiftUI.Scene {
        WindowGroup(id: "volumetric") {
            VolumetricView()
                .environment(viewModel)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: viewModel.volWidth, height: viewModel.volHeight, depth: viewModel.volDepth, in: .meters)
    }
}
