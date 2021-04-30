import Foundation
import glfw3

public struct GLJoystick: Hashable, Codable, Equatable {
    public static subscript(id: ID) -> GLJoystick? {
        get {
            if glfwJoystickPresent(id.rawValue) == true {
                return GLJoystick(joystickID: id)
            } else {
                return nil
            }
        }
    }
    
    public enum ID: Int32, Codable, Hashable, Equatable, ExpressibleByIntegerLiteral {
        case joystick1, joystick2, joystick3, joystick4, joystick5, joystick6, joystick7, joystick8, joystick9, joystick10, joystick11, joystick12, joystick13, joystick14, joystick15, joystick16, unknown = -1
        public static let last = joystick16
        public init(integerLiteral value: Int32) {
            self = Self(rawValue: value) ?? .unknown
        }
    }
    
    public var joystickID: ID
    
    public var name: String {
        return String(cString: glfwGetJoystickName(joystickID.rawValue))
    }
    
    public var axes: [Float] {
        var count = Int32.zero
        let pointer = glfwGetJoystickAxes(joystickID.rawValue, &count)
        return Array(UnsafeBufferPointer(start: pointer, count: count.int))
    }
    
    public enum ButtonState: Int32 {
        case released, pressed, unknown = -1
        public init(_ rawValue: Int32) {
            self = Self(rawValue: rawValue) ?? .unknown
        }
    }
    
    public var buttonStates: [ButtonState] {
        var count = Int32.zero
        let pointer = glfwGetJoystickButtons(joystickID.rawValue, &count)
        return Array(UnsafeBufferPointer(start: pointer, count: count.int)).map(\.int32).map(ButtonState.init)
    }
    
    public var guid: String {
        return String(cString: glfwGetJoystickGUID(joystickID.rawValue))
    }
    
    public struct HatState: OptionSet {
        public let rawValue: UInt8
        public init(rawValue: UInt8) {
            self.rawValue = rawValue & 0b1111
        }
        
        public static let centered = Self([])
        public static let up = Self(rawValue: 1 << 0)
        public static let right = Self(rawValue: 1 << 1)
        public static let down = Self(rawValue: 1 << 2)
        public static let left = Self(rawValue: 1 << 3)
        public static let rightUp = Self([.right, .up])
        public static let rightDown = Self([.right, .down])
        public static let leftUp = Self([.left, .up])
        public static let leftDown = Self([.left, .down])
    }
    
    public var hatStates: [HatState] {
        var count = Int32.zero
        let pointer = glfwGetJoystickHats(joystickID.rawValue, &count)
        return Array(UnsafeBufferPointer(start: pointer, count: count.int)).map(HatState.init)
    }
}
