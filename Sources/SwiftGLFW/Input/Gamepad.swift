import Foundation
import glfw3

public struct GLGamepad: Hashable, Codable, Equatable {
    public static subscript(id: ID) -> GLGamepad? {
        get {
            if glfwJoystickIsGamepad(id.rawValue) == true {
                return GLGamepad(gamepadID: id)
            } else {
                return nil
            }
        }
    }
    
    public enum ID: Int32, Codable, Hashable, Equatable, ExpressibleByIntegerLiteral {
        case gamepad1, gamepad2, gamepad3, gamepad4, gamepad5, gamepad6, gamepad7, gamepad8, gamepad9, gamepad10, gamepad11, gamepad12, gamepad13, gamepad14, gamepad15, gamepad16, unknown = -1
        public static let last = gamepad16
        public init(integerLiteral value: Int32) {
            self = Self(rawValue: value) ?? .unknown
        }
    }
    
    public static var allConnected: [GLGamepad] {
        (0...15).compactMap { GLGamepad[ID(rawValue: $0) ?? .unknown] }
    }
    
    public var gamepadID: ID
    
    public var name: String {
        return String(cString: glfwGetGamepadName(gamepadID.rawValue))
    }
    
    public enum Axis: Int {
        case leftX, leftY
        case rightX, rightY
        case leftTrigger, rightTrigger
        public static let last = rightTrigger
    }
    
    public struct Input {
        public enum State: Int {
            case released, pressed, unknown = -1
            public init(_ rawValue: Int) {
                self = Self(rawValue: rawValue) ?? .unknown
            }
        }
        
        fileprivate var buttons: [State], axes: [Float]
        fileprivate init(state: GLFWgamepadstate) {
            let reflection = Mirror(reflecting: state.buttons)
            let buttons = (reflection.children.map(\.value) as! [UInt8]).map(\.int)
            self.buttons = buttons.map(State.init)
            
            let axisReflection = Mirror(reflecting: state.axes)
            self.axes = (axisReflection.children.map(\.value) as! [Float])
        }
        
        public var a: State { buttons[GLFW_GAMEPAD_BUTTON_A.int] },
                   b: State { buttons[GLFW_GAMEPAD_BUTTON_B.int] },
                   x: State { buttons[GLFW_GAMEPAD_BUTTON_X.int] },
                   y: State { buttons[GLFW_GAMEPAD_BUTTON_Y.int] }
        
        public var bumper: (left: State, right: State) {
            (buttons[GLFW_GAMEPAD_BUTTON_LEFT_BUMPER.int], buttons[GLFW_GAMEPAD_BUTTON_RIGHT_BUMPER.int])
        }
        
        public var back: State { buttons[GLFW_GAMEPAD_BUTTON_BACK.int] },
                   start: State { buttons[GLFW_GAMEPAD_BUTTON_START.int] },
                   guide: State { buttons[GLFW_GAMEPAD_BUTTON_GUIDE.int] }
        
        public var dpad: (up: State, right: State, down: State, left: State) {
            (buttons[GLFW_GAMEPAD_BUTTON_DPAD_UP.int], buttons[GLFW_GAMEPAD_BUTTON_DPAD_RIGHT.int], buttons[GLFW_GAMEPAD_BUTTON_DPAD_DOWN.int], buttons[GLFW_GAMEPAD_BUTTON_DPAD_LEFT.int])
        }
        
        public var cross: State { a },
                   circle: State { b },
                   square: State { x },
                   triangle: State { y }
        
        public var switchA: State { b },
                   switchB: State { a },
                   switchX: State { y },
                   switchY: State { x }
        
        public var minus: State { back },
                   plus: State { start },
                   home: State { guide }
        
        public struct Thumbstick: Equatable {
            public var x, y: Float
            public var button: State
            public var magnitude: Float { sqrt(pow(x, 2) + pow(y, 2)) }
            public var angle: Float { atan(y / x) }
        }
        
        public var thumbstick: (left: Thumbstick, right: Thumbstick) {
            (Thumbstick(x: axes[GLFW_GAMEPAD_AXIS_LEFT_X.int], y: axes[GLFW_GAMEPAD_AXIS_LEFT_Y.int], button: buttons[GLFW_GAMEPAD_BUTTON_LEFT_THUMB.int]),
             Thumbstick(x: axes[GLFW_GAMEPAD_AXIS_RIGHT_X.int], y: axes[GLFW_GAMEPAD_AXIS_RIGHT_Y.int], button: buttons[GLFW_GAMEPAD_BUTTON_RIGHT_THUMB.int]))
        }
        
        public var trigger: (left: Float, right: Float) {
            (axes[GLFW_GAMEPAD_AXIS_LEFT_TRIGGER.int], axes[GLFW_GAMEPAD_AXIS_RIGHT_TRIGGER.int])
        }
    }
    
    public var input: Input {
        var state = GLFWgamepadstate()
        glfwGetGamepadState(gamepadID.rawValue, &state)
        return Input(state: state)
    }
}
