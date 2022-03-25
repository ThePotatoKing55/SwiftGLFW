import CGLFW3

public protocol GLFWObject: Equatable {
    var pointer: OpaquePointer? { get }
}

extension GLFWObject {
    public static func == <T: GLFWObject>(lhs: Self, rhs: T) -> Bool {
        lhs.pointer == rhs.pointer
    }
}
