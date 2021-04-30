import Foundation
import glfw3

protocol GLInputDevice {
    var window: GLWindow { get }
    init(in window: GLWindow)
}

extension GLInputDevice {
    var pointer: OpaquePointer? {
        window.pointer
    }
}
