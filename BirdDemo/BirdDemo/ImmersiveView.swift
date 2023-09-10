
import RealityKit
import RealityKitContent
import SwiftUI

struct ImmersiveView: View {
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        RealityView { content in
            content.add(await viewModel.createRootEntity())
            Task {
                await viewModel.startAnimationSequence()
            }
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
