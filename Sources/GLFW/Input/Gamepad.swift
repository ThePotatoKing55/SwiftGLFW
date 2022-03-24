import CGLFW3

public struct Gamepad: Hashable, Codable, Equatable {
    public let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    init(jid: Int32) {
        self.id = (jid - .gamepad1).int
    }
    
    public init?(_ id: Int) {
        self.id = id
        guard status == .connected else {
            return nil
        }
    }
    
    public var status: Status {
        glfwJoystickIsGamepad(id.int32 + .gamepad1) == .true ? .connected : .disconnected
    }
    
    static var states = Array(repeating: GLFWgamepadstate(), count: 16)
    
    public func state(of button: Button) -> ButtonState {
        withUnsafePointer(to: Gamepad.states[id].buttons) { ptr in
            ptr.withMemoryRebound(to: UInt8.self, capacity: 15) { buttons in
                ButtonState(Int32(buttons[button.rawValue]))
            }
        }
    }
    
    public func state(of axis: Axis) -> Float {
        withUnsafePointer(to: Gamepad.states[id].axes) { ptr in
            ptr.withMemoryRebound(to: Float.self, capacity: 6) { axes in
                axes[axis.rawValue]
            }
        }
    }
    
    public var name: String? {
        glfwGetGamepadName(id.int32 + .gamepad1).map(String.init(cString:))
    }
    
    public enum Status {
        case connected, disconnected
    }
    
    static var callback: ((Gamepad, Status) -> Void)?
    public static func setCallback(_ callback: @escaping (Gamepad, Status) -> Void) {
        Gamepad.callback = callback
        glfwSetJoystickCallback { id, status in
            Gamepad.callback?(Gamepad(jid: id), status == .connected ? .connected : .disconnected)
        }
    }
    
    public enum Button: Int {
        case a, b, x, y
        case leftBumper, rightBumper
        case back, start, guide
        case leftThumb, rightThumb
        case dpadUp, dpadRight, dpadDown, dpadLeft
        
        public static let cross = a
        public static let circle = b
        public static let square = x
        public static let triangle = y
    }
    
    public enum Axis: Int {
        case leftX, leftY
        case rightX, rightY
        case leftTrigger, rightTrigger
    }
}

extension Gamepad {
    public static var allConnected: [Gamepad] {
        return (0..<16).compactMap(Gamepad.init(_:))
    }
}
