#if os(macOS) && canImport(AppKit)
import AppKit
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

@available(macOS, deprecated: 10.14, message: "Please use Metal or MetalKit.")
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
