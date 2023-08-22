import CGLFW3

@propertyWrapper
public struct WindowHint<Value: WindowHintValue> {
    let hint: Int32
    let defaultValue: Value
    var definedValue: Value?
    
    public var wrappedValue: Value {
        get {
            definedValue ?? defaultValue
        }
        set {
            definedValue = newValue
            definedValue?.setter(hint: hint)
        }
    }
    
    init(_ hint: Int32, default: Value) {
        self.hint = hint
        self.defaultValue = `default`
    }
}

extension WindowHint where Value: OptionalProtocol {
    init(_ hint: Int32) {
        self.init(hint, default: nil)
    }
}

@propertyWrapper
public struct WindowHintString<Value: WindowHintStringValue> {
    let hint: Int32
    let defaultValue: Value
    var definedValue: Value?
    
    public var wrappedValue: Value {
        get {
            definedValue ?? defaultValue
        }
        set {
            definedValue = newValue
            definedValue?.setter(hint: hint)
        }
    }
    
    init(_ hint: Int32, default: Value) {
        self.hint = hint
        self.defaultValue = `default`
    }
}

extension WindowHintString where Value: OptionalProtocol {
    init(_ hint: Int32) {
        self.init(hint, default: nil)
    }
}

extension GLFWWindow {
    @MainActor
    public struct Hints {
        public mutating func reset() {
            glfwDefaultWindowHints()
            self = Hints()
        }
        
        @WindowHint(.resizable, default: true)
        public var resizable: Bool
        
        @WindowHint(.visible, default: true)
        public var visible: Bool
        
        @WindowHint(.decorated, default: true)
        public var decorated: Bool
        
        @WindowHint(.focused, default: true)
        public var focused: Bool
        
        @WindowHint(.autoIconify, default: true)
        public var autoMinimizeInFullscreen: Bool
        
        @WindowHint(.floating, default: false)
        public var floating: Bool
        
        @WindowHint(.maximized, default: false)
        public var maximized: Bool
        
        @WindowHint(.centerCursor, default: false)
        public var centerCursorOnShow: Bool
        
        @WindowHint(.transparentFramebuffer, default: false)
        public var transparentFramebuffer: Bool
        
        @WindowHint(.focusOnShow, default: true)
        public var focusOnShow: Bool
        
        @WindowHint(.scaleToMonitor, default: false)
        public var scaleToMonitor: Bool
        
        @WindowHint(.redBits)
        public var redBits: Int?
        
        @WindowHint(.greenBits)
        public var greenBits: Int?
        
        @WindowHint(.blueBits)
        public var blueBits: Int?
        
        @WindowHint(.alphaBits)
        public var alphaBits: Int?
        
        @WindowHint(.depthBits)
        public var depthBits: Int?
        
        @WindowHint(.stencilBits)
        public var stencilBits: Int?
        
        @WindowHint(.stereoRendering, default: false)
        public var stereoRendering: Bool
        
        @WindowHint(.msaaSamples)
        public var msaaSampleCount: Int?
        
        @WindowHint(.srgbCapable, default: false)
        public var srgbFramebuffer: Bool
        
        @WindowHint(.doubleBuffer, default: true)
        public var doubleBuffer: Bool
        
        @WindowHint(.monitorRefreshRate)
        public var fullscreenRefreshRate: Int?
        
        public enum ClientAPI: Int32, Sendable {
            case noAPI = 0
            case openGL = 0x00030001, openGLES
        }
        
        @WindowHint(.clientAPI, default: .openGL)
        public var clientAPI: ClientAPI
        
        public enum ContextCreationAPI: Int32, Sendable {
            case native = 0x00036001, egl, osMesa
        }
        
        @WindowHint(.contextCreationAPI, default: .native)
        public var contextCreationAPI: ContextCreationAPI
        
        @WindowHint(.contextVersionMinor, default: 0)
        private var contextVersionMinor
        
        @WindowHint(.contextVersionMajor, default: 1)
        private var contextVersionMajor
        
        public var contextVersion: (major: Int, minor: Int) {
            get { return (contextVersionMajor, contextVersionMinor) }
            set { (contextVersionMajor, contextVersionMinor) = newValue }
        }
        
        public enum OpenGLCompatibility: Int32, Sendable {
            case backward, forward
        }
        
        @WindowHint(.openglForwardCompatibility, default: .backward)
        public var openGLCompatibility: OpenGLCompatibility
        
        @WindowHint(.openglDebugContext, default: false)
        public var openGLDebugMode: Bool
        
        public enum OpenGLProfile: Int32, Sendable {
            case any = 0, core = 0x00032001, compatibility
        }
        
        @WindowHint(.openglProfile, default: .any)
        public var openGLProfile: OpenGLProfile
        
        public enum Robustness: Int32, Sendable {
            case any = 0, noResetNotification = 0x00031001, loseContext
        }
        
        @WindowHint(.contextRobustness, default: .any)
        public var robustness: Robustness
        
        public enum ReleaseBehavior: Int32, Sendable {
            case any = 0, flushPipeline = 0x00035001, none
        }
        
        @WindowHint(.contextReleaseBehavior, default: .any)
        public var releaseBehavior: ReleaseBehavior
        
        @WindowHint(.contextSuppressErrors, default: false)
        public var suppressErrors: Bool
        
        #if os(macOS)
        @WindowHint(.cocoaRetinaFramebuffer, default: true)
        public var retinaFramebuffer: Bool
        
        @WindowHintString(.cocoaFrameName)
        public var frameName: String?
        
        @WindowHint(.cocoaGraphicsSwitching, default: true)
        public var autoGraphicsSwitching: Bool
        #endif
        
        #if os(Linux)
        @WindowHintString(.x11ClassName)
        public var x11ClassName: String?
        
        @WindowHintString(.x11InstanceName)
        public var x11InstanceName: String?
        #endif
    }
}
