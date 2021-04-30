import Foundation
import glfw3

extension GLWindow {
    public var keyboard: GLKeyboard {
        GLKeyboard(in: self)
    }
}

public final class GLKeyboard {
    private let window: GLWindow
    private var pointer: OpaquePointer? { window.pointer }
    public init(in window: GLWindow) {
        self.window = window
    }
    
    public var stickyKeys: Bool {
        get { glfwGetInputMode(pointer, Constant.stickyKeys).bool }
        set { glfwSetInputMode(pointer, Constant.stickyKeys, newValue.int32) }
    }
    
    public var sendLocksAsKeyMods: Bool {
        get { glfwGetInputMode(pointer, Constant.lockKeyMods).bool }
        set { glfwSetInputMode(pointer, Constant.lockKeyMods, newValue.int32) }
    }
    
    public enum Key: Int32 {
        public enum State: Int32 {
            case released, pressed, unknown = -1
            public init(_ rawValue: Int32) {
                self = Self(rawValue: rawValue) ?? .unknown
            }
        }
        
        case unknown = -1
        case space = 32
        case apostrophe = 39
        case comma = 44, minus, period, slash
        case num0 = 48, num1, num2, num3, num4, num5, num6, num7, num8, num9
        case semicolon = 59
        case equal = 61
        case a = 65, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
        case leftBracket = 91, backslash, rightBracket
        case graveAccent = 96
        
        case world1 = 161, world2
        
        case escape = 256, enter, tab, backspace, insert, delete, right, left, down, up, pageUp, pageDown, home, end, capsLock, scrollLock, numLock, printScreen, pause
        
        case f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, f17, f18, f19, f20, f21, f22, f23, f24, f25
        
        case numpad0, numpad1, numpad2, numpad3, numpad4, numpad5, numpad6, numpad7, numpad8, numpad9
        case numpadDecimal, numpadDivide, numpadMultiply, numpadSubtract, numpadAdd, numpadEnter, numpadEqual
        
        case leftShift, leftControl, leftAlt, leftSuper
        case rightShift, rightControl, rightAlt, rightSuper
        public static let (leftCommand, rightCommand) = (leftSuper, rightSuper)
        public static let (leftWin, rightWin) = (leftSuper, rightSuper)
        
        case menu = 348
        public static let last = menu
        
        public var scancode: Int {
            glfwGetKeyScancode(self.rawValue).int
        }
        
        public func state(in window: GLWindow) -> State {
            State(glfwGetKey(window.pointer, rawValue))
        }
        
        public var name: String? {
            glfwGetKeyName(rawValue, 0).flatMap { String(cString: $0) }
        }
        
        public init(_ rawValue: Int32) {
            self = Self(rawValue: rawValue) ?? .unknown
        }
    }
    
    public func state(for key: Key) -> Key.State {
        key.state(in: window)
    }
    
    public struct Modifier: OptionSet {
        public let rawValue: Int32
        public init(rawValue: Int32) {
            self.rawValue = rawValue & 0b111111
        }
        
        public static let shift = Modifier(rawValue: 1 << 0)
        public static let control = Modifier(rawValue: 1 << 1)
        public static let alt = Modifier(rawValue: 1 << 2)
        public static let `super` = Modifier(rawValue: 1 << 3)
        public static let command = Modifier.super
        public static let win = Modifier.super
        public static let capsLock = Modifier(rawValue: 1 << 4)
        public static let numLock = Modifier(rawValue: 1 << 5)
    }
}
