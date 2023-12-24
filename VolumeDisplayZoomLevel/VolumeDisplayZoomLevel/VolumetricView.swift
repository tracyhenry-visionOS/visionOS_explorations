
import RealityKit
import RealityKitContent
import SwiftUI

struct VolumetricView: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.physicalMetrics) var physicalMetrics

    var body: some View {
        GeometryReader3D { proxy in
            // update scale of the root based on geometry reader
            // proxy.size is size in points
            let sizeInMeters = physicalMetrics.convert(proxy.size, to: .meters)
            let _ = viewModel.updateRootScaleFactor(sizeInMeters)
            RealityView { content, attachments in
                content.add(await viewModel.createRootEntity(attachments: attachments))
            }
            attachments: {
                Attachment(id: "demo") {
                    VStack {
                        Text("A big piece of text")
                            .font(.system(size: 96))
                    }
                    .padding(96)
                    .glassBackgroundEffect()
                    .frame(width: 800, height: 600)
                }
            }
        }
    }
}
