import CGLFW3

@available(*, unavailable, renamed: "Gamepad")
public struct GLFWGamepad {}

public struct Gamepad: Hashable, Codable, Equatable {
    public init?(withID id: ID) {
        if glfwJoystickIsGamepad(id.rawValue + GLFW_JOYSTICK_1) == true {
            self.id = id
        } else {
            return nil
        }
    }
    
    public enum ID: Int32, Codable, Hashable, Equatable {
        case gamepad1, gamepad2, gamepad3, gamepad4, gamepad5, gamepad6, gamepad7, gamepad8, gamepad9, gamepad10, gamepad11, gamepad12, gamepad13, gamepad14, gamepad15, gamepad16
        public static let last = gamepad16
    }
    
    public static var connectedGamepads: [Gamepad] {
        return (0..<16).compactMap(ID.init(rawValue:)).compactMap(Gamepad.init(withID:))
    }
    
    public let id: ID
    
    public static func name(id: ID) -> String {
        String(cString: glfwGetGamepadName(id.rawValue))
    }
    
    public var name: String {
        return String(cString: glfwGetGamepadName(id.rawValue))
    }
    
    public static func buttons(id: ID) -> [ButtonState] {
        var state = GLFWgamepadstate()
        glfwGetGamepadState(id.rawValue, &state)
        return withUnsafePointer(to: state.buttons) { ptr in
            ptr.withMemoryRebound(to: UInt8.self, capacity: 15) { buttonPtr in
                Array(UnsafeBufferPointer(start: buttonPtr, count: 15)).map(\.int).map(ButtonState.init)
            }
        }
    }
    
    public static func axes(id: ID) -> [Float] {
        var state = GLFWgamepadstate()
        glfwGetGamepadState(id.rawValue, &state)
        return withUnsafePointer(to: state.axes) { ptr in
            ptr.withMemoryRebound(to: Float.self, capacity: 6) { axisPtr in
                Array(UnsafeBufferPointer(start: axisPtr, count: 6))
            }
        }
    }
    
    public struct Input {
        fileprivate var buttons: [ButtonState], axes: [Float]
        fileprivate init(state: GLFWgamepadstate) {
            self.buttons = withUnsafePointer(to: state.buttons) { ptr in
                ptr.withMemoryRebound(to: UInt8.self, capacity: 15) { buttonPtr in
                    Array(UnsafeBufferPointer(start: buttonPtr, count: 15)).map(\.int).map(ButtonState.init)
                }
            }
            
            self.axes = withUnsafePointer(to: state.axes) { ptr in
                ptr.withMemoryRebound(to: Float.self, capacity: 6) { axisPtr in
                    Array(UnsafeBufferPointer(start: axisPtr, count: 6))
                }
            }
        }
        
        public var a: ButtonState { buttons[GLFW_GAMEPAD_BUTTON_A.int] }
        public var b: ButtonState { buttons[GLFW_GAMEPAD_BUTTON_B.int] }
        public var x: ButtonState { buttons[GLFW_GAMEPAD_BUTTON_X.int] }
        public var y: ButtonState { buttons[GLFW_GAMEPAD_BUTTON_Y.int] }
        
        public var back: ButtonState { buttons[GLFW_GAMEPAD_BUTTON_BACK.int] }
        public var start: ButtonState { buttons[GLFW_GAMEPAD_BUTTON_START.int] }
        public var guide: ButtonState { buttons[GLFW_GAMEPAD_BUTTON_GUIDE.int] }
        
        public var dpadUp: ButtonState { buttons[GLFW_GAMEPAD_BUTTON_DPAD_UP.int] }
        public var dpadRight: ButtonState { buttons[GLFW_GAMEPAD_BUTTON_DPAD_RIGHT.int] }
        public var dpadDown: ButtonState { buttons[GLFW_GAMEPAD_BUTTON_DPAD_DOWN.int] }
        public var dpadLeft: ButtonState { buttons[GLFW_GAMEPAD_BUTTON_DPAD_LEFT.int] }
        
        public var cross: ButtonState { a }
        public var circle: ButtonState { b }
        public var square: ButtonState { x }
        public var triangle: ButtonState { y }
        
        public var switchA: ButtonState { b }
        public var switchB: ButtonState { a }
        public var switchX: ButtonState { y }
        public var switchY: ButtonState { x }
        
        public var minus: ButtonState { back }
        public var plus: ButtonState { start }
        public var home: ButtonState { guide }
        
        public struct Thumbstick: Equatable {
            public var x, y: Float
            public var button: ButtonState
            public var magnitude: Float { sqrt(pow(x, 2) + pow(y, 2)) }
            public var angle: Float { atan(y / x) }
        }
        
        public var leftThumbstick: Thumbstick {
            return Thumbstick(
                x: axes[GLFW_GAMEPAD_AXIS_LEFT_X.int],
                y: axes[GLFW_GAMEPAD_AXIS_LEFT_Y.int],
                button: buttons[GLFW_GAMEPAD_BUTTON_LEFT_THUMB.int]
            )
        }
        
        public var rightThumbstick: Thumbstick {
            return Thumbstick(
                x: axes[GLFW_GAMEPAD_AXIS_RIGHT_X.int],
                y: axes[GLFW_GAMEPAD_AXIS_RIGHT_Y.int],
                button: buttons[GLFW_GAMEPAD_BUTTON_RIGHT_THUMB.int]
            )
        }
        
        public var leftTrigger: Float { axes[GLFW_GAMEPAD_AXIS_LEFT_TRIGGER.int] }
        public var rightTrigger: Float { axes[GLFW_GAMEPAD_AXIS_RIGHT_TRIGGER.int] }
        
        public var leftBumper: ButtonState { buttons[GLFW_GAMEPAD_BUTTON_LEFT_BUMPER.int] }
        public var rightBumper: ButtonState { buttons[GLFW_GAMEPAD_BUTTON_RIGHT_BUMPER.int] }
    }
    
    public var input: Input {
        var state = GLFWgamepadstate()
        glfwGetGamepadState(id.rawValue, &state)
        return Input(state: state)
    }
}
