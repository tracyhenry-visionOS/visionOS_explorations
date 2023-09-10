
import Foundation
import Observation
import RealityKit
import SwiftUI

@Observable
class ViewModel {
    var root = Entity()

    private let planeWidth: Float = 5
    private let planeHeight: Float = 3.5
    private var wallAnchor = AnchorEntity(.plane(.vertical, classification: .wall, minimumBounds: .init(_: 0.6, _: 0.6)))

    @MainActor
    func createRootEntity() async -> Entity {
        do {
            // add wall anchor entity
            root.addChild(wallAnchor)

            // construct plane entity attached to wall
            let planeMesh = MeshResource.generatePlane(width: planeWidth, depth: planeHeight)
            var planeMaterial = UnlitMaterial()
            planeMaterial.color = try await .init(tint: .white.withAlphaComponent(0.9999),
                                                  texture: MaterialParameters.Texture(.init(named: "twitter_transparent_outline")))
            let planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
            planeEntity.name = "TransparentBirdPNG"
            wallAnchor.addChild(planeEntity)

            // construct big floor entity
            let floorEntity = Entity()
            floorEntity.position = [0, -0.1, 0]
            floorEntity.components[PhysicsBodyComponent.self] = .init(massProperties: .default, material: nil, mode: .static)
            floorEntity.components[CollisionComponent.self] = .init(shapes: [.generateBox(width: 30, height: 0.2, depth: 30)])
            root.addChild(floorEntity)

        } catch {
            print("Failed to generate root entity: \(error)")
        }
        return root
    }

    @MainActor
    func startAnimationSequence() async {
        let baseBird = try! await ModelEntity(named: "TwitterBird3D")

        // =================== Large Bird ===================
        // load Bird 3D
        try? await Task.sleep(for: .seconds(2.5))
        let bird3DEntity = baseBird.clone(recursive: false)
        bird3DEntity.position = [2, 3, -3]
        bird3DEntity.scale = .one * 0.4
        bird3DEntity.components[GroundingShadowComponent.self] = .init(castsShadow: true)
        root.addChild(bird3DEntity)

        // beginning animation
        let destTransform = Transform(scale: bird3DEntity.scale, rotation: simd_quatf(angle: 0, axis: [0, 1, 1]),
                                      translation: [0, 3, -2.5])
        bird3DEntity.move(to: destTransform, relativeTo: root, duration: 2)
        try? await Task.sleep(for: .seconds(2.2))

        // make bird fall
        await bird3DEntity.setPhysicsComponent(mode: .dynamic, inertia: 20, mass: 10)

        // =================== spawn 10 birds ===================
        try? await Task.sleep(for: .seconds(2.5))
//        let lowInertiaBirds: [ModelEntity] = []
        for _ in 0 ..< 50 {
            let curBird = baseBird.clone(recursive: false)
            root.addChild(curBird)
            let loX: Float = -1.5, hiX: Float = 1.5
            let loY: Float = 3.0, hiY: Float = 10.0
            let loZ: Float = -5.0, hiZ: Float = -3.0
            curBird.position = [Float.random(in: loX ... hiX), Float.random(in: loY ... hiY), Float.random(in: loZ ... hiZ)]
            curBird.scale = .one * 0.2
            curBird.transform.rotation = simd_quatf(angle: Float.random(in: 0 ... 90), axis: [0, 1, 0])
            curBird.components[GroundingShadowComponent.self] = .init(castsShadow: true)
            await curBird.setPhysicsComponent(mode: .dynamic, inertia: 5, mass: 10)
        }

        // =================== impulse 10 birds ===================
        try? await Task.sleep(for: .seconds(2.5))
        for _ in 0 ..< 200 {
            let curBird = baseBird.clone(recursive: false)
            curBird.position = [-2, 3, -3]
            root.addChild(curBird)
            curBird.scale = .one * 0.3
            curBird.components[GroundingShadowComponent.self] = .init(castsShadow: true)
            await curBird.setPhysicsComponent(mode: .dynamic, inertia: 5, mass: 10)
            let lo: Float = -5.0
            let hi: Float = 5.0
            curBird.applyLinearImpulse(normalize([Float.random(in: lo ... hi), Float.random(in: lo ... hi), Float.random(in: lo ... hi)]) * Float.random(in: 1 ... 3), relativeTo: root)
        }
    }
}
