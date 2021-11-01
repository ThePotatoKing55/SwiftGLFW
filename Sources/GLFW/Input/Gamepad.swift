import CGLFW3

@available(*, renamed: "Gamepad")
public struct GLFWGamepad {}

public struct Gamepad: Hashable, Codable, Equatable {
    public static subscript(id: ID) -> Gamepad? {
        get {
            if glfwJoystickIsGamepad(id.rawValue + GLFW_JOYSTICK_1) == true {
                return Gamepad(id: id)
            } else {
                return nil
            }
        }
    }
    
    public enum ID: Int32, Codable, Hashable, Equatable {
        case gamepad1, gamepad2, gamepad3, gamepad4, gamepad5, gamepad6, gamepad7, gamepad8, gamepad9, gamepad10, gamepad11, gamepad12, gamepad13, gamepad14, gamepad15, gamepad16
        public static let last = gamepad16
    }
    
    public static var connectedGamepads: [Gamepad] {
        return (0...15).compactMap { Gamepad[ID(rawValue: $0)!] }
    }
    
    public let id: ID
    
    public var name: String {
        return String(cString: glfwGetGamepadName(id.rawValue))
    }
    
    public struct Input {
        fileprivate var buttons: [ButtonState], axes: [Float]
        fileprivate init(state: GLFWgamepadstate) {
            let reflection = Mirror(reflecting: state.buttons)
            let buttons = (reflection.children.map(\.value) as! [UInt8]).map(\.int)
            self.buttons = buttons.map(ButtonState.init)
            
            let axisReflection = Mirror(reflecting: state.axes)
            self.axes = (axisReflection.children.map(\.value) as! [Float])
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
