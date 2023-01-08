import CGLFW3

@MainActor
public final class GLFWContext: GLFWObject {
    public let pointer: OpaquePointer?
    
    nonisolated init(_ pointer: OpaquePointer?) {
        self.pointer = pointer
    }
    
    nonisolated public static var current: GLFWContext {
        GLFWContext(glfwGetCurrentContext())
    }
    
    nonisolated public func makeCurrent() {
        glfwMakeContextCurrent(pointer)
    }
    
    public func setSwapInterval(_ interval: Int) {
        glfwSwapInterval(Int32(interval))
    }
    
    @available(*, renamed: "setSwapInterval")
    public func setVsync(_ enabled: Bool) {
        glfwSwapInterval(enabled ? 1 : 0)
    }
    
    public typealias Hints = GLFWWindow.Hints
    
    @ContextAttribute(.clientAPI)
    public private(set) var clientAPI: Hints.ClientAPI
    
    @ContextAttribute(.contextCreationAPI)
    public private(set) var contextCreationAPI: Hints.ContextCreationAPI
    
    @ContextAttribute(.contextVersionMajor)
    private var contextMajor: Int
    
    @ContextAttribute(.contextVersionMinor)
    private var contextMinor: Int
    
    public var version: (major: Int, minor: Int) {
        return (major: contextMajor, minor: contextMinor)
    }
    
    @ContextAttribute(.openglForwardCompatibility)
    public private(set) var openGLCompatibility: Hints.OpenGLCompatibility
    
    @ContextAttribute(.openglDebugContext)
    public private(set) var debugMode: Bool
    
    @ContextAttribute(.openglProfile)
    public private(set) var openGLProfile: Hints.OpenGLProfile
    
    @ContextAttribute(.contextReleaseBehavior)
    public private(set) var releaseBehavior: Hints.ReleaseBehavior
    
    @ContextAttribute(.contextSuppressErrors)
    public private(set) var suppressErrors: Bool
    
    @ContextAttribute(.contextRobustness)
    public private(set) var robustness: Hints.Robustness
}

extension GLFWWindow {
    nonisolated public var context: GLFWContext {
        GLFWContext(pointer)
    }
}
