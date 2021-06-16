import Foundation
import GLFW

public enum GLSession {
    public struct InitHint: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let joystickHatsAsButtons = InitHint(rawValue: 1 << 0)
        public static let useResourcesDir = InitHint(rawValue: 1 << 1)
        public static let createMenuBar = InitHint(rawValue: 1 << 2)
        public static let `default` = InitHint([.joystickHatsAsButtons, .useResourcesDir, .createMenuBar])
    }
    
    public struct Version: Hashable, Equatable, Comparable {
        public static func < (lhs: Version, rhs: Version) -> Bool {
            (lhs.major < rhs.major)
                || (lhs.major == rhs.major && lhs.minor < rhs.minor)
                || (lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.revision < rhs.revision)
        }
        
        public let major: Int
        public let minor: Int
        public let revision: Int
        public let string: String
    }
    
    public static var currentTime: TimeInterval {
        glfwGetTime()
    }
    
    public static var version: Version {
        var major: Int32 = 0, minor: Int32 = 0, revision: Int32 = 0
        glfwGetVersion(&major, &minor, &revision)
        let string = String(cString: glfwGetVersionString())
        return Version(major: major.int, minor: minor.int, revision: revision.int, string: string)
    }
    
    public static func getError() -> GLFWError {
        GLFWError(rawValue: glfwGetError(nil)) ?? .unknown
    }
    
    public static var errorHandler: ((GLFWError) -> Void)? {
        didSet {
            glfwSetErrorCallback { error, description in
                GLSession.errorHandler?(GLFWError(rawValue: error) ?? .unknown)
            }
        }
    }
    
    public static func initialize(hints: InitHint = .default) {
        setHint(hints)
        glfwInit()
    }
    
    public static func setHint(_ hint: InitHint) {
        glfwInitHint(Constant.joystickHatButtons, hint.contains(.joystickHatsAsButtons).int32)
        glfwInitHint(Constant.cocoaChDirResources, hint.contains(.useResourcesDir).int32)
        glfwInitHint(Constant.cocoaMenuBar, hint.contains(.createMenuBar).int32)
    }
    
    public static func terminate() {
        glfwTerminate()
    }
    
    public static func getClipboardContents() -> String? {
        glfwGetClipboardString(nil).flatMap(String.init(cString:))
    }
    
    public static func setClipboardContents(_ string: String?) {
        glfwSetClipboardString(nil, string)
    }
    
    public static func pollInputEvents() {
        glfwPollEvents()
    }
    
    public static func waitEvents(timeout: TimeInterval = 0.0) {
        timeout > 0 ? glfwWaitEventsTimeout(timeout) : glfwWaitEvents()
    }
    
    public static func timeout() {
        glfwPostEmptyEvent()
    }
}
