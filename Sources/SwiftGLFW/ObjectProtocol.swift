import Foundation
import glfw3

protocol GLObject: Equatable {
    var pointer: OpaquePointer? { get set }
}

extension GLObject {
    public static func == <T: GLObject>(lhs: Self, rhs: T) -> Bool {
        lhs.pointer == rhs.pointer
    }
}
