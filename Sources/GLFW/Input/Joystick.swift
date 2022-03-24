/*import CGLFW3

public struct Joystick: Hashable, Codable, Equatable {
    public static subscript(id: ID) -> Joystick? {
        get {
            if glfwJoystickPresent(id.rawValue + GLFW_JOYSTICK_1) == true {
                return Joystick(id: id)
            } else {
                return nil
            }
        }
    }
    
    public enum ID: Int32, Codable, Hashable, Equatable {
        case joystick1, joystick2, joystick3, joystick4, joystick5, joystick6, joystick7, joystick8, joystick9, joystick10, joystick11, joystick12, joystick13, joystick14, joystick15, joystick16
        public static let last = joystick16
    }
    
    public static var connectedJoysticks: [Joystick] {
        return (0...15).compactMap { Joystick[ID(rawValue: $0)!] }
    }
    
    public let id: ID
    
    public var name: String {
        return String(cString: glfwGetJoystickName(id.rawValue))
    }
    
    public var axes: [Float] {
        var count = Int32.zero
        let pointer = glfwGetJoystickAxes(id.rawValue, &count)
        return Array(UnsafeBufferPointer(start: pointer, count: count.int))
    }
    
    public var buttons: [ButtonState] {
        var count = Int32.zero
        let pointer = glfwGetJoystickButtons(id.rawValue, &count)
        let buffer = UnsafeBufferPointer(start: pointer, count: count.int)
        return Array(buffer).map { ButtonState(Int32($0)) }
    }
    
    public var guid: String {
        return String(cString: glfwGetJoystickGUID(id.rawValue))
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
        let pointer = glfwGetJoystickHats(id.rawValue, &count)
        return Array(UnsafeBufferPointer(start: pointer, count: count.int)).map(HatState.init)
    }
}
*/
