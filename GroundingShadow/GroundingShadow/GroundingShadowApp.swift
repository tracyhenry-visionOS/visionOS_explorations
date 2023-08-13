//
//  GroundingShadowApp.swift
//  GroundingShadow
//
//  Created by Wenbo Tao on 8/12/23.
//

import SwiftUI

@main
struct GroundingShadowApp: App {
    @State private var viewModel = ViewModel()

    init() {
        MovementSystem.registerSystem()
        MovementComponent.registerComponent()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }.windowStyle(.plain)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView().environment(viewModel)
        }
    }
}
