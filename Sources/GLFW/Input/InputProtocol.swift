import CGLFW3

protocol GLFWInputDevice {
    var window: GLFWWindow { get }
    init(in window: GLFWWindow)
}

extension GLFWInputDevice {
    var pointer: OpaquePointer? {
        window.pointer
    }
}
