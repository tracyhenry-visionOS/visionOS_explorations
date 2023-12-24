import AVFoundation
import Observation
import RealityKit
import RealityKitContent
import SwiftUI

@Observable
class ViewModel {
    let volWidth: CGFloat = 1.2
    let volHeight: CGFloat = 1.2
    let volDepth: CGFloat = 0.8
    var vw: Float { Float(volWidth) }
    var vh: Float { Float(volHeight) }
    var vd: Float { Float(volDepth) }
    var root: Entity = .init()
    var attachmentEntity: ViewAttachmentEntity?

    @MainActor
    func createRootEntity(attachments: RealityViewAttachments) async -> Entity {
        do {
            // add a 3D model
            let cat = try await ModelEntity(named: "Knight_Cat")
            cat.scale = .one * 0.0016
            cat.position = [-0.4, -0.5, 0.1]
            root.addChild(cat)

            // UI attachment
            attachmentEntity = attachments.entity(for: "demo")!
            attachmentEntity!.position = [0, 0, 0]
            root.addChild(attachmentEntity!)

            // add a bottom plane
            let planeMaterial = SimpleMaterial(color: .white.withAlphaComponent(0.5), roughness: 1, isMetallic: false)
            let planeBottom = ModelEntity(mesh: .generateBox(width: vw, height: 0.01, depth: vd), materials: [planeMaterial])
            planeBottom.position = [0, -vh / 2, 0]
            root.addChild(planeBottom)
        } catch {
            print("Failed to generate root entity: \(error)")
        }
        return root
    }

    func updateRootScaleFactor(_ sizeInMeters: Size3D) {
        root.scale = .one * Float(sizeInMeters.width) / vw
        // making sure we cancel the scale added by system zoom levels
        attachmentEntity?.scale = 1 / root.scale
    }
}
