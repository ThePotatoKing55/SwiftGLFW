import Foundation
import glfw3

protocol GLFWObject: Equatable {
    var pointer: OpaquePointer? { get set }
}

extension GLFWObject {
    public static func == <T: GLFWObject>(lhs: Self, rhs: T) -> Bool {
        lhs.pointer == rhs.pointer
    }
}
