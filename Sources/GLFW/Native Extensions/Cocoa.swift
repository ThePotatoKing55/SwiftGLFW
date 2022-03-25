#if os(macOS) && canImport(Cocoa)
import Cocoa
import CGLFW3

extension GLFWMonitor {
    nonisolated public var directDisplayID: CGDirectDisplayID {
        return glfwGetCocoaMonitor(pointer)
    }
}

extension GLFWWindow {
    nonisolated public var nsWindow: NSWindow? {
        return glfwGetCocoaWindow(pointer) as? NSWindow
    }
}

extension GLFWContext {
    @available(macOS, deprecated: 10.14, message: "Please use Metal or MetalKit.")
    nonisolated public var nsOpenGLContext: NSOpenGLContext? {
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
