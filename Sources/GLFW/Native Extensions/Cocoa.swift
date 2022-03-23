#if os(macOS) && canImport(Cocoa)
import Cocoa
import CGLFW3

extension Monitor {
    public var directDisplayID: CGDirectDisplayID {
        return glfwGetCocoaMonitor(pointer)
    }
}

extension GLFWWindow {
    public var nsWindow: NSWindow? {
        return glfwGetCocoaWindow(pointer) as? NSWindow
    }
}

extension GLFWWindow {
    public var nsOpenGLContext: NSOpenGLContext? {
        return glfwGetNSGLContext(pointer) as? NSOpenGLContext
    }
}

#if GLFW_METAL_LAYER_SUPPORT
@available(macOS 10.11, *)
extension GLFWWindow {
    public var metalLayer: CAMetalLayer? {
        return glfwGetMetalLayer(pointer) as? CAMetalLayer
    }
}
#endif
#endif
