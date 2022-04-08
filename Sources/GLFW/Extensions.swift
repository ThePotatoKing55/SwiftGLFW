import CGLFW3

extension GLFWContext.Hints.OpenGLVersion: CustomStringConvertible {
    public var description: String {
        return "\(major).\(minor)"
    }
}

public protocol WindowHintValue {
    func setter(hint: Int32)
}

public protocol WindowHintStringValue {
    func setter(hint: Int32)
}

public protocol Int32Convertible: WindowHintValue {
    init(_ int32: Int32)
    var int32: Int32 { get }
}

extension Int32Convertible {
    public func setter(hint: Int32) {
        glfwWindowHint(hint, self.int32)
    }
}

extension String: WindowHintStringValue {
    public func setter(hint: Int32) {
        glfwWindowHintString(hint, self)
    }
}

extension Optional: WindowHintValue where Wrapped: Int32Convertible {
    public func setter(hint: Int32) {
        glfwWindowHint(hint, self?.int32 ?? .dontCare)
    }
}

extension Optional: WindowHintStringValue where Wrapped == String {
    public func setter(hint: Int32) {
        glfwWindowHintString(hint, self)
    }
}

protocol OptionalProtocol: ExpressibleByNilLiteral { }
extension Optional: OptionalProtocol { }

extension Bool: Int32Convertible {
    public init(_ int32: Int32) {
        self = int32 == .true
    }
    public var int32: Int32 {
        self ? .true : .false
    }
}

extension BinaryInteger {
    var int: Int {
        Int(self)
    }
    
    public var int32: Int32 {
        Int32(self)
    }
}

extension Int: Int32Convertible { }

extension UInt32: Int32Convertible {
    var bool: Bool {
        self == Int32.true
    }
    var int: Int {
        Int(self)
    }
}

extension GLFWWindow.Hints.ClientAPI: Int32Convertible {
    public var int32: Int32 {
        rawValue.int32
    }
    
    public init(_ int32: Int32) {
        self = Self(rawValue: int32) ?? .openGL
    }
}

extension GLFWWindow.Hints.ContextCreationAPI: Int32Convertible {
    public var int32: Int32 {
        rawValue.int32
    }
    
    public init(_ int32: Int32) {
        self = Self(rawValue: int32) ?? .native
    }
}

extension GLFWWindow.Hints.OpenGLCompatibility: Int32Convertible {
    public var int32: Int32 {
        rawValue.int32
    }
    
    public init(_ int32: Int32) {
        self = Self(rawValue: int32) ?? .backward
    }
}

extension GLFWWindow.Hints.OpenGLProfile: Int32Convertible {
    public var int32: Int32 {
        rawValue.int32
    }
    
    public init(_ int32: Int32) {
        self = Self(rawValue: int32) ?? .any
    }
}

extension GLFWWindow.Hints.ReleaseBehavior: Int32Convertible {
    public var int32: Int32 {
        rawValue.int32
    }
    
    public init(_ int32: Int32) {
        self = Self(rawValue: int32) ?? .any
    }
}

extension GLFWWindow.Hints.Robustness: Int32Convertible {
    public var int32: Int32 {
        rawValue.int32
    }
    
    public init(_ int32: Int32) {
        self = Self(rawValue: int32) ?? .loseContext
    }
}
