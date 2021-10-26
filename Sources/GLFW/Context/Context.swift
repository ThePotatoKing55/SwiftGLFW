import CGLFW3

public class GLFWContext: GLFWObject {
    internal(set) public var pointer: OpaquePointer?
    
    internal init(_ pointer: OpaquePointer?) {
        self.pointer = pointer
    }
    
    public static var current: GLFWContext {
        GLFWContext(glfwGetCurrentContext())
    }
    
    public func makeCurrent() {
        glfwMakeContextCurrent(pointer)
    }
    
    public static var syncSwapWithMonitor: Bool = false {
        didSet {
            glfwSwapInterval(syncSwapWithMonitor.int32)
        }
    }
    
    private var attributes: GLFWWindow.AttributeManager { .init(pointer) }
    
    public typealias Hints = GLFWWindow.Hints
    
    public var clientAPI: Hints.ClientAPI {
        return .init(rawValue: attributes[Constant.clientAPI]) ?? .openGL
    }
    
    public var creationAPI: Hints.ContextCreationAPI {
        return .init(rawValue: attributes[Constant.contextCreationAPI]) ?? .native
    }
    
    public var openGLVersion: Hints.OpenGLVersion {
        let major = attributes[Constant.contextVersionMajor].int
        let minor = attributes[Constant.contextVersionMinor].int
        return .init(major: major, minor: minor)
    }
    
    public var openglCompatibility: Hints.OpenGLCompatibility {
        return .init(rawValue: attributes[Constant.openglForwardCompatibility]) ?? .backwards
    }
    
    public var debugMode: Bool {
        attributes[Constant.openglDebugContext].bool
    }
    
    public var openglProfile: Hints.OpenGLProfile {
        return .init(rawValue: attributes[Constant.openglProfile]) ?? .any
    }
    
    public var releaseBehavior: Hints.ReleaseBehavior {
        return .init(rawValue: attributes[Constant.contextReleaseBehavior]) ?? .any
    }
    
    public var suppressErrors: Bool {
        return attributes[Constant.contextSuppressErrors].bool
    }
    
    public var robustness: Hints.Robustness {
        return .init(rawValue: attributes[Constant.contextRobustness]) ?? .loseContext
    }
}

extension GLFWWindow {
    public var context: GLFWContext {
        GLFWContext(pointer)
    }
}
