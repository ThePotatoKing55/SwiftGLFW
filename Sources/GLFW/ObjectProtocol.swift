import CGLFW3

public protocol GLFWObject: Equatable {
    var pointer: OpaquePointer? { get }
}

extension GLFWObject {
    public static func == (lhs: Self, rhs: some GLFWObject) -> Bool {
        lhs.pointer == rhs.pointer
    }
}
