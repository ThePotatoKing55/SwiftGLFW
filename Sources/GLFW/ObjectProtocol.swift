import CGLFW3

protocol GLFWObject: Equatable {
    var pointer: OpaquePointer? { get set }
}

extension GLFWObject {
    public static func == (lhs: Self, rhs: any GLFWObject) -> Bool {
        lhs.pointer == rhs.pointer
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.pointer == rhs.pointer
    }
}
