import CGLFW3

extension GLFWWindow {
    public var mouse: Mouse {
        get { Mouse(in: self) }
        set { }
    }
}

@MainActor
public struct Mouse {
    private weak var window: GLFWWindow!
    
    init(in window: GLFWWindow) {
        self.window = window
    }
    
    public var useRawInput: Bool {
        get { Bool(glfwGetInputMode(window.pointer, .rawMouseMotion)) }
        set { Bool(glfwRawMouseMotionSupported()) ? glfwSetInputMode(window.pointer, .rawMouseMotion, newValue.int32) : () }
    }
    
    public var stickyButtons: Bool {
        get { Bool(glfwGetInputMode(window.pointer, .stickyMouseButtons)) }
        set { glfwSetInputMode(window.pointer, .stickyMouseButtons, newValue.int32) }
    }
    
    public enum Button: Int32 {
        case button1, button2, button3, button4, button5, button6, button7, button8
        public static let left = button1
        public static let right = button2
        public static let middle = button3
    }
    
    public func state(of button: Button) -> ButtonState {
        ButtonState(glfwGetMouseButton(window.pointer, button.rawValue))
    }
    
    public var position: Point {
        get {
            var xpos = Double.zero, ypos = Double.zero
            glfwGetCursorPos(window.pointer, &xpos, &ypos)
            return Point(x: xpos, y: ypos)
        }
        set {
            glfwSetCursorPos(window.pointer, newValue.x, newValue.y)
        }
    }
    
    public enum CursorMode: Int32, Sendable {
        case normal = 0x00034001, hidden = 0x00034002, disabled = 0x00034003
    }
    
    public var cursorMode: CursorMode {
        get { CursorMode(rawValue: glfwGetInputMode(window.pointer, .cursor)) ?? .normal }
        set { glfwSetInputMode(window.pointer, .cursor, newValue.rawValue) }
    }
    
    public enum Cursor: Sendable {
        case arrow, ibeam, crosshair, hand, resizeHorizontal, resizeVertical, resizeNWSE, resizeNESW, move, notAllowed
        case custom(Image, center: Point = .zero)
        case `default`
        
        @MainActor func create() -> OpaquePointer? {
            switch self {
                case .arrow:
                    return glfwCreateStandardCursor(.arrowCursor)
                case .ibeam:
                    return glfwCreateStandardCursor(.iBeamCursor)
                case .crosshair:
                    return glfwCreateStandardCursor(.crosshairCursor)
                case .hand:
                    return glfwCreateStandardCursor(.handCursor)
                case .resizeHorizontal:
                    return glfwCreateStandardCursor(.horizontalResizeCursor)
                case .resizeVertical:
                    return glfwCreateStandardCursor(.verticalResizeCursor)
                case .resizeNWSE:
                    return glfwCreateStandardCursor(.resizeNWSECursor)
                case .resizeNESW:
                    return glfwCreateStandardCursor(.resizeNESWCursor)
                case .move:
                    return glfwCreateStandardCursor(.resizeAllCursor)
                case .notAllowed:
                    return glfwCreateStandardCursor(.notAllowedCursor)
                case let .custom(image, center: center):
                    return withUnsafePointer(to: image.glfwImage) { ptr in
                        glfwCreateCursor(ptr, Int32(center.x), Int32(center.y))
                    }
                case .default:
                    return nil
            }
        }
    }
    
    public func setCursor(to cursor: Cursor) {
        window.cursor = cursor
    }
}
