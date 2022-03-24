#if os(macOS) && canImport(Cocoa)
import Cocoa
import CGLFW3

extension GLFWMonitor {
    public var directDisplayID: CGDirectDisplayID {
        return glfwGetCocoaMonitor(pointer)
    }
}

extension GLFWWindow {
    public var nsWindow: NSWindow? {
        return glfwGetCocoaWindow(pointer) as? NSWindow
    }
    
    @available(*, deprecated, renamed: "GLFWWindow.context.nsOpenGLContext")
    public var nsOpenGLContext: NSOpenGLContext? {
        return context.nsOpenGLContext
    }
}

extension GLFWContext {
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
