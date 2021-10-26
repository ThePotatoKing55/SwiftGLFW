#if os(macOS) && canImport(AppKit)
import AppKit
import CGLFW3

extension Monitor {
    public var directDisplayID: CGDirectDisplayID {
        return glfwGetCocoaMonitor(pointer)
    }
}

extension GLFWWindow {
    public var nsWindow: NSWindow! {
        return glfwGetCocoaWindow(pointer) as? NSWindow
    }
    
    public var nsOpenGLContext: NSOpenGLContext! {
        return glfwGetNSGLContext(pointer) as? NSOpenGLContext
    }
}
#endif
