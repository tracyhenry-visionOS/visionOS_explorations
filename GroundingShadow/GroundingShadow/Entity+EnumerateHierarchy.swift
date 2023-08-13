import RealityKit

extension Entity {
    /// Executes a closure for each of the entity's child and descendant
    /// entities, as well as for the entity itself.
    ///
    /// Set `stop` to true in the closure to abort further processing of the child entity subtree.
    func enumerateHierarchy(_ body: (Entity, UnsafeMutablePointer<Bool>) -> Void) {
        var stop = false

        func enumerate(_ body: (Entity, UnsafeMutablePointer<Bool>) -> Void) {
            guard !stop else {
                return
            }

            body(self, &stop)

            for child in children {
                guard !stop else {
                    break
                }
                child.enumerateHierarchy(body)
            }
        }

        enumerate(body)
    }
}
