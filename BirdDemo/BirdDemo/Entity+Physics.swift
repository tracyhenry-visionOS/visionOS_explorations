//
//  Entity+Physics.swift
//  BirdDemo
//
//  Created by Wenbo Tao on 9/9/23.
//

import Foundation
import RealityKit

extension Entity {
    func setPhysicsComponent(mode: PhysicsBodyMode, inertia: Float = 10, mass: Float = 1) async {
        // set collision shape
        if let collisionShape = (self as! ModelEntity).model?.mesh {
            self.components[CollisionComponent.self] = try? await .init(shapes: [.generateConvex(from: collisionShape)])
        }

        // set physics body component
        if mode == .static {
            self.components[PhysicsBodyComponent.self] = .init(massProperties: .default, material: nil, mode: .static)
        } else if mode == .dynamic {
            self.components[PhysicsBodyComponent.self] = .init(
                massProperties: .init(mass: mass, inertia: .one * inertia),
                material: nil,
                mode: .dynamic)
        }
    }
}
