
import RealityKit
import RealityKitContent
import SwiftUI

struct ContentView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(ViewModel.self) var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        VStack(alignment: .leading) {
            Text("Everyday is more awesome!")
        }
        .padding(50)
        .glassBackgroundEffect()
        .onAppear {
            Task {
                await openImmersiveSpace(id: "ImmersiveSpace")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(ViewModel())
}

