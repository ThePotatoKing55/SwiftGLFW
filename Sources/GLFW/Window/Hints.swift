import CGLFW3

extension GLFWSession {
    public struct Hints {
        @propertyWrapper public struct BoolHint {
            public var wrappedValue: Bool? = nil {
                didSet {
                    guard let value = wrappedValue else { return }
                    glfwInitHint(hintName, value.int32)
                }
            }
            
            private let hintName: Int32
            
            fileprivate init(wrappedValue: Bool? = nil, _ hintName: Int32) {
                self.wrappedValue = wrappedValue
                self.hintName = hintName
            }
        }
        
        @BoolHint(.joystickHatButtons)
        public var mapJoystickHatsToButtons: Bool?
        
        #if os(macOS)
        @BoolHint(.cocoaChDirResources)
        public var relativeToAppResources: Bool?
        
        @BoolHint(.cocoaMenuBar)
        public var generateMenuBar: Bool?
        #endif
    }
}

extension GLFWWindow {
    public struct Hints {
        public static let `default` = Hints()
        
        public mutating func reset() {
            glfwDefaultWindowHints()
            self = Hints()
        }
        
        @propertyWrapper public struct BoolHint {
            private var _value: Bool? = nil
            
            public var wrappedValue: Bool? {
                get { _value }
                set {
                    guard let value = _value?.int32 else { return }
                    glfwWindowHint(hintName, value)
                }
            }
            
            private let hintName: Int32
            
            fileprivate init(wrappedValue: Bool? = nil, _ hintName: Int32) {
                self._value = wrappedValue
                self.hintName = hintName
            }
        }
        
        @propertyWrapper public struct IntHint<Value: BinaryInteger> {
            public var wrappedValue: Value? {
                didSet {
                    wrappedValue.flatMap { glfwWindowHint(hintName, $0.int32) }
                }
            }
            
            fileprivate init(wrappedValue: Value? = nil, _ hint: Int32) {
                self.wrappedValue = wrappedValue
                self.hintName = hint
            }
            
            private let hintName: Int32
        }
        
        @propertyWrapper public struct RawHint<Value: RawRepresentable> where Value.RawValue: BinaryInteger {
            public var wrappedValue: Value? {
                didSet {
                    wrappedValue.flatMap { glfwWindowHint(hintName, $0.rawValue.int32) }
                }
            }
            
            fileprivate init(wrappedValue: Value? = nil, _ hint: Int32) {
                self.wrappedValue = wrappedValue
                self.hintName = hint
            }
            
            private let hintName: Int32
        }
        
        @propertyWrapper public struct StringHint {
            public var wrappedValue: String? = nil {
                didSet {
                    guard let wrappedValue = wrappedValue else { return }
                    glfwWindowHintString(hintName, wrappedValue)
                }
            }
            
            private let hintName: Int32
            
            fileprivate init(wrappedValue: String? = nil, _ hint: Int32) {
                self.wrappedValue = wrappedValue
                self.hintName = hint
            }
        }
        
        @BoolHint(.resizable)
        public var isResizable: Bool?
        
        @BoolHint(.visible)
        public var isVisible: Bool?
        
        @BoolHint(.decorated)
        public var isDecorated: Bool?
        
        @BoolHint(.focused)
        public var isInFocus: Bool?
        
        @BoolHint(.autoIconify)
        public var minimizeOnLoseFocus: Bool?
        
        @BoolHint(.floating)
        public var isFloating: Bool?
        
        @BoolHint(.maximized)
        public var maximized: Bool?
        
        @BoolHint(.centerCursor)
        public var centerCursorOnShow: Bool?
        
        @BoolHint(.transparentFramebuffer)
        public var transparentFramebuffer: Bool?
        
        @BoolHint(.focusOnShow)
        public var focusOnShow: Bool?
        
        @BoolHint(.scaleToMonitor)
        public var useMonitorContentScale: Bool?
        
        @IntHint(.redBits)
        public var redBitDepth: Int?
        
        @IntHint(.greenBits)
        public var greenBitDepth: Int?
        
        @IntHint(.blueBits)
        public var blueBitDepth: Int?
        
        @IntHint(.depthBits)
        public var depthBitDepth: Int?
        
        @IntHint(.stencilBits)
        public var stencilBitDepth: Int?
        
        @BoolHint(.stereoRendering)
        public var stereoRendering: Bool?
        
        @IntHint(.msaaSamples)
        public var msaaSamples: Int?
        
        @BoolHint(.srgbCapable)
        public var srgbCapable: Bool?
        
        @IntHint(.monitorRefreshRate)
        public var refreshRate: Int?
        
        public enum ClientAPI: Int32 {
            case noAPI = 0
            case openGL = 0x00030001, embeddedOpenGL
        }
        
        @RawHint(.clientAPI)
        public var clientAPI: ClientAPI? = .openGL
        
        public enum ContextCreationAPI: Int32 {
            case native = 0x00036001, egl, osMesa
        }
        
        @RawHint(.contextCreationAPI)
        public var contextCreationAPI: ContextCreationAPI?
        
        public enum OpenGLCompatibility: Int32 {
            case backwards, forward
        }
        
        public struct OpenGLVersion: Equatable {
            public let major, minor: Int
            internal init(major: Int, minor: Int) {
                (self.major, self.minor) = (major, minor)
            }
            
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
        
        @IntHint(.contextVersionMajor)
        private var openglMajor: Int?
        @IntHint(.contextVersionMinor)
        private var openglMinor: Int?
        
        public var openglVersion: OpenGLVersion? {
            didSet {
                openglMajor = openglVersion?.major
                openglMinor = openglVersion?.minor
            }
        }
        
        @RawHint(.openglForwardCompatibility)
        public var openglCompatibility: OpenGLCompatibility?
        
        public enum OpenGLProfile: Int32 {
            case any = 0, core = 0x00032001, compatibility
        }
        
        @BoolHint(.openglDebugContext)
        public var openglDebugMode: Bool?
        
        @RawHint(.openglProfile)
        public var openglProfile: OpenGLProfile?
        
        public enum Robustness: Int32 {
            case noResetNotification = 0x00031001, loseContext
        }
        
        @RawHint(.contextRobustness)
        public var robustness: Robustness?
        
        public enum ReleaseBehavior: Int32 {
            case any = 0, flushPipeline = 0x00035001, none
        }
        
        @RawHint(.contextReleaseBehavior)
        public var releaseBehavior: ReleaseBehavior?
        
        @BoolHint(.contextSuppressErrors)
        public var suppressErrors: Bool?
        
        #if os(macOS)
        @BoolHint(.cocoaRetinaFramebuffer)
        public var retinaFramebuffer: Bool?
        
        @StringHint(.cocoaFrameName)
        public var frameName: String?
        
        @BoolHint(.cocoaGraphicsSwitching)
        public var autoGraphicsSwitching: Bool?
        #endif
        
        #if os(Linux)
        @StringHint(.x11ClassName)
        public var x11ClassName: String?
        
        @StringHint(.x11InstanceName)
        public var x11InstanceName: String?
        #endif
    }
}
