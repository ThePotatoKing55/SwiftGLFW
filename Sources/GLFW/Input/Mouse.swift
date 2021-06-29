import CGLFW3

extension GLFWWindow {
    public var mouse: GLMouse {
        GLMouse(in: self)
    }
}

public final class GLMouse {
    private let window: GLFWWindow
    private var pointer: OpaquePointer? { window.pointer }
    public init(in window: GLFWWindow) {
        self.window = window
    }
    
    public var useRawMotionInput: Bool {
        get { glfwGetInputMode(pointer, Constant.rawMouseMotion).bool }
        set { glfwRawMouseMotionSupported().bool ? glfwSetInputMode(pointer, Constant.rawMouseMotion, newValue.int32) : () }
    }
    
    public var stickyButtons: Bool {
        get { glfwGetInputMode(pointer, Constant.stickyMouseButtons).bool }
        set { glfwSetInputMode(pointer, Constant.stickyMouseButtons, newValue.int32) }
    }
    
    public enum Button: Int32 {
        public enum State: Int32 {
            case released, pressed, unknown = -1
            public init(_ rawValue: Int32) {
                self = Self(rawValue: rawValue) ?? .unknown
            }
        }
        
        public func state(in window: GLFWWindow) -> State {
            State(glfwGetMouseButton(window.pointer, rawValue))
        }
        
        case button1, button2, button3, button4, button5, button6, button7, button8
        public static let last = button8
        public static let left = button1
        public static let right = button2
        public static let middle = button3
    }
    
    public func state(for button: Button) -> Button.State {
        button.state(in: window)
    }
    
    public var cursorPosition: GLPoint<Double> {
        get {
            var xpos = Double.zero, ypos = Double.zero
            glfwGetCursorPos(window.pointer, &xpos, &ypos)
            return GLPoint(x: xpos, y: ypos)
        }
        set {
            glfwSetCursorPos(window.pointer, newValue.x, newValue.y)
        }
    }
    
    public enum CursorMode: Int32 {
        case normal = 0x00034001, hidden = 0x00034002, disabled = 0x00034003
    }
    
    public var cursorMode: CursorMode {
        get { CursorMode(rawValue: glfwGetInputMode(pointer, Constant.cursor)) ?? .normal }
        set { glfwSetInputMode(pointer, Constant.cursor, newValue.rawValue) }
    }
    
    public enum Cursor {
        public enum StandardCursor: Int32 {
            case arrow = 0x00036001, iBeam, crosshair, hand, resizeHorizontal, resizeVertical
        }

        case standard(StandardCursor),
             image(GLImage),
             `default`
    }
    
    private var currentCursor: OpaquePointer?
    
    public func setCursor(to cursor: Cursor) {
        glfwDestroyCursor(currentCursor)
        switch cursor {
        case .standard(let shape):
            currentCursor = glfwCreateStandardCursor(shape.rawValue)
        case .image(let image):
            var glfwImage = image.glfwImage
            currentCursor = glfwCreateCursor(&glfwImage, .zero, .zero)
        case .default:
            currentCursor = nil
        }
        
        glfwSetCursor(pointer, currentCursor)
    }
}
