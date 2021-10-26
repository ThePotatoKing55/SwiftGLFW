@frozen
public struct GLFWPixel: Equatable, Hashable, Codable, ExpressibleByIntegerLiteral {
    public var rawBits: UInt32
    
    private static let channelBound = Double(UInt8.max)
    
    public var redBits: UInt8 {
        get { UInt8((rawBits & 0xFF000000) >> 24) }
        set { rawBits = (rawBits & 0x00FFFFFF) | (UInt32(newValue) << 24) }
    }
    
    public var red: Double {
        get { Double(redBits) / Self.channelBound }
        set { redBits = UInt8(newValue * Self.channelBound) }
    }
    
    public var greenBits: UInt8  {
        get { UInt8((rawBits & 0x00FF0000) >> 16) }
        set { rawBits = (rawBits & 0xFF00FFFF) | (UInt32(newValue) << 16) }
    }
    
    public var green: Double {
        get { Double(greenBits) / Self.channelBound }
        set { greenBits = UInt8(newValue * Self.channelBound) }
    }
    
    public var blueBits: UInt8  {
        get { UInt8((rawBits & 0x0000FF00) >> 8) }
        set { rawBits = (rawBits & 0xFFFF00FF) | (UInt32(newValue) << 8) }
    }
    
    public var blue: Double {
        get { Double(blueBits) / Self.channelBound }
        set { blueBits = UInt8(newValue * Self.channelBound) }
    }
    
    public var alphaBits: UInt8  {
        get { UInt8(rawBits & 0x000000FF) }
        set { rawBits = (rawBits & 0xFFFFFF00) | (UInt32(newValue)) }
    }
    
    public var alpha: Double {
        get { Double(alphaBits) / Self.channelBound }
        set { alphaBits = UInt8(newValue * Self.channelBound) }
    }
    
    public var bitArray: [UInt8] { [redBits, greenBits, blueBits, alphaBits] }
    
    public init(rawBits: UInt32) {
        self.rawBits = rawBits
    }
    
    public init(integerLiteral value: UInt32) {
        self.init(rawBits: value)
    }
    
    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.init(rawBits: 0)
        (self.red, self.green, self.blue, self.alpha) = (red, green, blue, alpha)
    }
    
    public init(redBits red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = .max) {
        self.init(red: Double(red) / Self.channelBound,
                  green: Double(green) / Self.channelBound,
                  blue: Double(blue) / Self.channelBound,
                  alpha: Double(alpha) / Self.channelBound
        )
    }
}

extension GLFWPixel {
    public func withRed(_ r: Double) -> Self { Self(red: r, green: green, blue: blue, alpha: alpha) }
    public func withGreen(_ g: Double) -> Self { Self(red: red, green: g, blue: blue, alpha: alpha) }
    public func withBlue(_ b: Double) -> Self { Self(red: red, green: green, blue: b, alpha: alpha) }
    public func withAlpha(_ a: Double) -> Self { Self(red: red, green: green, blue: blue, alpha: a) }
    
    public var withPremultipliedAlpha: Self {
        return Self(red: red * alpha, green: green * alpha, blue: blue * alpha, alpha: alpha)
    }
    
    public func mixed(with other: Self) -> Self {
        let red = self.red * self.alpha * (1 - other.alpha) + other.red * other.alpha
        let green = self.green * self.alpha * (1 - other.alpha) + other.green * other.alpha
        let blue = self.blue * self.alpha * (1 - other.alpha) + other.blue * other.alpha
        let alpha = self.alpha * (1 - other.alpha) + other.alpha
        return Self(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public mutating func mix(with other: Self) {
        self = mixed(with: other)
    }
    
    public static let white = GLFWPixel(0xFFFFFFFF)
    public static let black = GLFWPixel(0x000000FF)
    public static let clear = GLFWPixel(0x00000000)
    public static let red = GLFWPixel(0xFF0000FF)
    public static let orange = GLFWPixel(0xFF8000FF)
    public static let yellow = GLFWPixel(0xFFFF00FF)
    public static let green = GLFWPixel(0x00FF00FF)
    public static let teal = GLFWPixel(0x00FF80FF)
    public static let blue = GLFWPixel(0x0000FFFF)
    public static let magenta = GLFWPixel(0xFF00FFFF)
    public static let cyan = GLFWPixel(0x00FFFFFF)
    public static let normal = GLFWPixel(0x8080FFFF)
}
