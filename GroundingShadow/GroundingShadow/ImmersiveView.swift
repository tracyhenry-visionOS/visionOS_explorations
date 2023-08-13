//
//  ImmersiveView.swift
//  GroundingShadow
//
//  Created by Wenbo Tao on 8/12/23.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ImmersiveView: View {
    @Environment(ViewModel.self) private var viewModel
    @State private var root: Entity? = nil
    var body: some View {
        RealityView { content in
            do {
//                let sphere = ModelEntity(mesh: .generateSphere(radius: 0.2), materials: [SimpleMaterial(color: .white, roughness: 1, isMetallic: false)])
//                let sphere = ModelEntity(mesh: .generateBox(width: 1.8, height: 0.3, depth: 0.5), materials: [PhysicallyBasedMaterial()])

//                sphere.components.set(GroundingShadowComponent(castsShadow: true))
//                sphere.position = [0, 0.1, 0]
//                content.add(sphere)

                let immersiveSceneEntity = try await Entity(named: "Immersive", in: realityKitContentBundle)
                let cube = ModelEntity(mesh: .generateBox(width: 1.8, height: 0.2, depth: 0.5), materials: [SimpleMaterial(color: .white, roughness: 0.3, isMetallic: false)])
                cube.position = [0, 0.1, 0]
                cube.components.set(GroundingShadowComponent(castsShadow: true))

                immersiveSceneEntity.addChild(cube)

                let robot = immersiveSceneEntity.findEntity(named: "Robot")
                let car = immersiveSceneEntity.findEntity(named: "Toy_Car")
                let airplane = immersiveSceneEntity.findEntity(named: "Toy_Biplane")
                let drummer = immersiveSceneEntity.findEntity(named: "Toy_Drummer")
//                let cube = immersiveSceneEntity.findEntity(named: "Cube_2")
//
//                cube?.components.set(GroundingShadowComponent(castsShadow: true))
//                cube?.position = [0, 0.1, 0]

                robot?.components.set(MovementComponent(movementType: .upAndDown))
                car?.components.set(MovementComponent(movementType: .rotateY))
                airplane?.components.set(MovementComponent(movementType: .rotateZ))
                drummer?.components.set(MovementComponent(movementType: .rotateY))

                content.add(immersiveSceneEntity)

                Task {
                    self.root = immersiveSceneEntity
//                    self.root = cube
                }
            }
            catch {
                print("Error in RealityView's make: \(error)")
            }
        }
        .onChange(of: viewModel.rootPosition) { _, newValue in
            self.root?.position = newValue
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
        .environment(ViewModel())
}
