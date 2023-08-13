//
//  ContentView.swift
//  GroundingShadow
//
//  Created by Wenbo Tao on 8/12/23.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ContentView: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    private let rootMoveIncrement: Float = 0.1

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Button("-X") {
                    viewModel.rootPosition += [-rootMoveIncrement, 0, 0]
                }

                Button("+X") {
                    viewModel.rootPosition += [rootMoveIncrement, 0, 0]
                }
            }

            HStack(spacing: 20) {
                Button("-Y") {
                    viewModel.rootPosition += [0, -rootMoveIncrement, 0]
                }

                Button("+Y") {
                    viewModel.rootPosition += [0, rootMoveIncrement, 0]
                }
            }

            HStack(spacing: 20) {
                Button("-Z") {
                    viewModel.rootPosition += [0, 0, -rootMoveIncrement]
                }

                Button("+Z") {
                    viewModel.rootPosition += [0, 0, rootMoveIncrement]
                }
            }
        }
        .padding(50)
        .glassBackgroundEffect(in: .rect(cornerRadius: 30))
        .onAppear {
            Task {
                await openImmersiveSpace(id: "ImmersiveSpace")
            }
        }
    }
}

#Preview {
    ContentView().environment(ViewModel())
}
