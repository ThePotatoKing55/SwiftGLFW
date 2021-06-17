import Foundation
import CGLFW3

@frozen
public struct GLWindowHints: ExpressibleByArrayLiteral, IteratorProtocol, Sequence {
    
    public typealias Element = Hint
    
    private var _curPos = Int.zero
    mutating public func next() -> Hint? {
        if _curPos < array.count {
            _curPos += 1
            return array[_curPos - 1]
        } else {
            return nil
        }
    }
    
    var array: [Hint] = []
    
    public init(arrayLiteral elements: Hint...) {
        array = elements
    }
    
    private init() {
        array = []
    }
    
    mutating public func add(_ hint: Hint) {
        array.append(hint)
    }
    
    mutating public func remove(_ hint: Hint) {
        array.removeAll(where: { hint == $0 })
    }
    
    public var count: Int {
        array.count
    }
    
    public static let `default` = GLWindowHints()
    
    public enum Hint: Equatable {
        case resizable(Bool)
        case initiallyVisible(Bool)
        case decorated(Bool)
        case focused(Bool)
        case autoMinimize(Bool)
        case floating(Bool)
        case initiallyMaximized(Bool)
        case centerCursorOnShow(Bool)
        case transparentFramebuffer(Bool)
        case focusWhenShown(Bool)
        case scaleToMonitor(Bool)
        
        case colorBitDepth(Int)
        case alphaBitDepth(Int)
        case depthBitDepth(Int)
        case stencilBitDepth(Int)
        case useStereoscopicRendering(Bool)
        case msaaSamples(Int)
        case srgbCapable(Bool)
        case refreshRate(Int)
        
        public enum ClientAPI: Int32 {
            case openGL = 0x00030001, embeddedOpenGL = 0x00030002, none = 0
        }
        
        public enum ContextCreationAPI: Int32 {
            case native = 0x00036001, egl, osMesa
        }
        
        public enum OpenGLCompatibility: Int32 {
            case backwards, forward
        }
        
        public enum OpenGLProfile: Int32 {
            case core = 0x00032001, compatibility = 0x00032002, any = 0
        }
        
        public enum Robustness: Int32 {
            case noResetNotification = 0x00031001, loseContext = 0x00031002, none = 0
        }
        
        public enum ReleaseBehavior: Int32 {
            case any = 0, flushPipeline = 0x00035001, none
        }
        
        @frozen
        public struct OpenGLVersion: Equatable, Hashable, Codable {
            public let major, minor: Int
            
            public static let v1_0 = OpenGLVersion(major: 1, minor: 0)
            public static let v1_1 = OpenGLVersion(major: 1, minor: 1)
            public static let v1_2 = OpenGLVersion(major: 1, minor: 2)
            public static let v1_3 = OpenGLVersion(major: 1, minor: 3)
            public static let v1_4 = OpenGLVersion(major: 1, minor: 4)
            public static let v1_5 = OpenGLVersion(major: 1, minor: 5)
            
            public static let v2_0 = OpenGLVersion(major: 2, minor: 0)
            public static let v2_1 = OpenGLVersion(major: 2, minor: 1)
            
            public static let v3_0 = OpenGLVersion(major: 3, minor: 0)
            public static let v3_1 = OpenGLVersion(major: 3, minor: 1)
            public static let v3_2 = OpenGLVersion(major: 3, minor: 2)
            public static let v3_3 = OpenGLVersion(major: 3, minor: 3)
            
            public static let v4_0 = OpenGLVersion(major: 4, minor: 0)
            public static let v4_1 = OpenGLVersion(major: 4, minor: 1)
            public static let v4_2 = OpenGLVersion(major: 4, minor: 2)
            public static let v4_3 = OpenGLVersion(major: 4, minor: 3)
            public static let v4_4 = OpenGLVersion(major: 4, minor: 4)
            public static let v4_5 = OpenGLVersion(major: 4, minor: 5)
            public static let v4_6 = OpenGLVersion(major: 4, minor: 6)
        }
        
        case clientAPI(ClientAPI)
        case contextCreationAPI(ContextCreationAPI)
        case openGLVersion(OpenGLVersion)
        case openGLCompatibility(OpenGLCompatibility)
        case enableDebugMode(Bool)
        case openGLProfile(OpenGLProfile)
        case robustness(Robustness)
        case releaseBehavior(ReleaseBehavior)
        case suppressErrors(Bool)
        case useRetinaFramebuffer(Bool)
        case macosFrameName(String)
        case automaticGraphicsSwitching(Bool)
        case x11ClassName(String)
        case x11InstanceName(String)
    }
    
    static func setHint(_ hint: Hint) {
        switch hint {
        case .resizable(let bool): glfwWindowHint(Constant.resizable, bool.int32)
        case .initiallyVisible(let bool): glfwWindowHint(Constant.visible, bool.int32)
        case .decorated(let bool): glfwWindowHint(Constant.decorated, bool.int32)
        case .focused(let bool): glfwWindowHint(Constant.focused, bool.int32)
        case .autoMinimize(let bool): glfwWindowHint(Constant.autoIconify, bool.int32)
        case .floating(let bool): glfwWindowHint(Constant.floating, bool.int32)
        case .initiallyMaximized(let bool): glfwWindowHint(Constant.maximized, bool.int32)
        case .centerCursorOnShow(let bool): glfwWindowHint(Constant.centerCursor, bool.int32)
        case .transparentFramebuffer(let bool): glfwWindowHint(Constant.transparentFramebuffer, bool.int32)
        case .focusWhenShown(let bool): glfwWindowHint(Constant.focusOnShow, bool.int32)
        case .scaleToMonitor(let bool): glfwWindowHint(Constant.scaleToMonitor, bool.int32)
        case .colorBitDepth(let depth):
            glfwWindowHint(Constant.redBits, depth.int32)
            glfwWindowHint(Constant.greenBits, depth.int32)
            glfwWindowHint(Constant.blueBits, depth.int32)
        case .alphaBitDepth(let depth): glfwWindowHint(Constant.alphaBits, depth.int32)
        case .depthBitDepth(let depth): glfwWindowHint(Constant.depthBits, depth.int32)
        case .stencilBitDepth(let depth): glfwWindowHint(Constant.stencilBits, depth.int32)
        case .useStereoscopicRendering(let bool): glfwWindowHint(Constant.stereoRendering, bool.int32)
        case .msaaSamples(let samples): glfwWindowHint(Constant.msaaSamples, samples.int32)
        case .srgbCapable(let bool): glfwWindowHint(Constant.srgbCapable, bool.int32)
        case .refreshRate(let rate): glfwWindowHint(Constant.monitorRefreshRate, rate.int32)
        case .clientAPI(let api): glfwWindowHint(Constant.clientAPI, api.rawValue)
        case .contextCreationAPI(let api): glfwWindowHint(Constant.contextCreationAPI, api.rawValue)
        case .openGLVersion(let version):
            glfwWindowHint(Constant.contextVersionMajor, version.major.int32)
            glfwWindowHint(Constant.contextVersionMinor, version.minor.int32)
        case .openGLCompatibility(let level): glfwWindowHint(Constant.openglForwardCompatibility, level.rawValue)
        case .enableDebugMode(let bool): glfwWindowHint(Constant.openglDebugContext, bool.int32)
        case .openGLProfile(let profile): glfwWindowHint(Constant.openglProfile, profile.rawValue)
        case .robustness(let level): glfwWindowHint(Constant.contextRobustness, level.rawValue)
        case .releaseBehavior(let behavior): glfwWindowHint(Constant.contextReleaseBehavior, behavior.rawValue)
        case .suppressErrors(let bool): glfwWindowHint(Constant.contextSuppressErrors, bool.int32)
        case .useRetinaFramebuffer(let bool): glfwWindowHint(Constant.cocoaRetinaFramebuffer, bool.int32)
        case .macosFrameName(let name): glfwWindowHintString(Constant.cocoaFrameName, name)
        case .automaticGraphicsSwitching(let bool): glfwWindowHint(Constant.cocoaGraphicsSwitching, bool.int32)
        case .x11ClassName(let name): glfwWindowHintString(Constant.x11ClassName, name)
        case .x11InstanceName(let name): glfwWindowHintString(Constant.x11InstanceName, name)
        }
    }
}

extension GLWindowHints: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.array == rhs.array
    }
}
