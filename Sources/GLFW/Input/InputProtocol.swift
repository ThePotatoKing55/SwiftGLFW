import CGLFW3

protocol GLInputDevice {
    var window: GLFWWindow { get }
    init(in window: GLFWWindow)
}

extension GLInputDevice {
    var pointer: OpaquePointer? {
        window.pointer
    }
}
