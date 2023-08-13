//
//  MovementSystem.swift
//  GroundingShadow
//
//  Created by Wenbo Tao on 8/12/23.
//

import RealityKit

public enum MovementType: Codable {
    case upAndDown
    case rotateY
    case rotateX
    case rotateZ
}

public struct MovementComponent: Component, Codable {
    public var movementType: MovementType
    public var verticalMoveDirection: Float = -1.0
    public var verticalMoveUpperBound: Float = 0.3
    public var verticalMoveLowerBound: Float = 0.1

    public init(movementType _movementType: MovementType) { self.movementType = _movementType }
}

public struct MovementSystem: System {
    static let query = EntityQuery(where: .has(MovementComponent.self))

    public init(scene: RealityKit.Scene) {}

    public func update(context: SceneUpdateContext) {
        let objects = context.scene.performQuery(Self.query)
        for obj in objects {
            guard var movementComponent = obj.components[MovementComponent.self] else {
                print("movement component missing!!!")
                continue
            }
            var currentTransform = obj.transform
            let radians = 5 * Float.pi / 180
            let rotationX = simd_quatf(angle: radians, axis: [1, 0, 0])
            let rotationY = simd_quatf(angle: radians, axis: [0, 1, 0])
            let rotationZ = simd_quatf(angle: radians, axis: [0, 0, 1])
            switch movementComponent.movementType {
                case .rotateX:
                    currentTransform.rotation = rotationX * currentTransform.rotation
                case .rotateY:
                    currentTransform.rotation = rotationY * currentTransform.rotation
                case .rotateZ:
                    currentTransform.rotation = rotationZ * currentTransform.rotation
                case .upAndDown:
                    currentTransform.translation += [0, 0.005, 0] * movementComponent.verticalMoveDirection
                    if currentTransform.translation.y >= movementComponent.verticalMoveUpperBound {
                        movementComponent.verticalMoveDirection = -1
                    } else if currentTransform.translation.y <= movementComponent.verticalMoveLowerBound {
                        movementComponent.verticalMoveDirection = 1.0
                    }
            }
            // Apply the new transform to the entity
            obj.transform = currentTransform
            obj.components[MovementComponent.self] = movementComponent
        }
    }
}
