import CGLFW3

@MainActor
public enum GLFWSession {
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
    
    nonisolated public static var currentTime: Double {
        glfwGetTime()
    }
    
    nonisolated public static var version: Version {
        var major: Int32 = 0, minor: Int32 = 0, revision: Int32 = 0
        glfwGetVersion(&major, &minor, &revision)
        let string = String(cString: glfwGetVersionString())
        return Version(major: major.int, minor: minor.int, revision: revision.int, string: string)
    }
    
    nonisolated public static func checkForError() throws -> Void {
        var description: UnsafePointer<CChar>?
        let lastError = glfwGetError(&description)
        if lastError != GLFW_NO_ERROR {
            throw GLFWError(kind: lastError, description: description)
        }
    }
    
    public static var onReceiveError: ((GLFWError) -> Void)? {
        didSet {
            if GLFWSession.onReceiveError != nil {
                glfwSetErrorCallback { error, description in
                    GLFWSession.onReceiveError!(GLFWError(kind: error, description: description))
                }
            } else {
                glfwSetErrorCallback(nil)
            }
        }
    }
    
    public static func initialize() throws {
        guard glfwInit() == .true else {
            try checkForError()
            throw GLFWError(kind: .unknown, description: "GLFW init failed, but no error was thrown.")
        }
    }
    
    public static func terminate() {
        glfwTerminate()
    }
    
    public static var clipboard: String? {
        get { glfwGetClipboardString(nil).flatMap(String.init(cString:)) }
        set { glfwSetClipboardString(nil, newValue) }
    }
    
    public static func pollInputEvents() {
        glfwPollEvents()
        for index in 0 ..< 16 {
            if glfwGetGamepadState(index.int32 + .gamepad1, &Gamepad.states[index]) == .false {
                Gamepad.states[index] = GLFWgamepadstate()
            }
        }
    }
    
    public static func waitEvents() {
        glfwWaitEvents()
    }
    
    public static func waitEvents(timeout: Double) {
        glfwWaitEventsTimeout(timeout)
    }
    
    nonisolated public static func timeout() {
        glfwPostEmptyEvent()
    }
    
    @InitHint(.joystickHatButtons, default: false)
    public static var mapJoystickHatsToButtons: Bool
    
#if os(macOS)
    @InitHint(.cocoaChDirResources, default: false)
    public static var relativeToAppResources: Bool
    
    @InitHint(.cocoaMenuBar, default: true)
    public static var generateMenuBar: Bool
#endif
}

@propertyWrapper
public struct InitHint<Value: Int32Convertible> {
    let hint: Int32
    let defaultValue: Value
    var definedValue: Value?
    
    public var wrappedValue: Value {
        get {
            definedValue ?? defaultValue
        }
        set {
            glfwInitHint(hint, newValue.int32)
            definedValue = newValue
        }
    }
    
    init(_ hint: Int32, default: Value) {
        self.hint = hint
        self.defaultValue = `default`
    }
}
