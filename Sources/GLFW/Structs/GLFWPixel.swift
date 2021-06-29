@frozen
public struct GLFWPixel: Equatable, Hashable, Codable, ExpressibleByIntegerLiteral {
    public var rawBits: UInt32
    
    public var redBits: UInt8 {
        get { UInt8((rawBits & 0xFF000000) >> 24) }
        set { rawBits = (rawBits & 0x00FFFFFF) | (UInt32(newValue) << 24) }
    }
    
    public var red: Float {
        get { Float(redBits) / Float(UInt8.max) }
        set { redBits = UInt8(newValue * 255) }
    }
    
    public var greenBits: UInt8  {
        get { UInt8((rawBits & 0x00FF0000) >> 16) }
        set { rawBits = (rawBits & 0xFF00FFFF) | (UInt32(newValue) << 16) }
    }
    
    public var green: Float {
        get { Float(greenBits) / Float(UInt8.max) }
        set { greenBits = UInt8(newValue * 255) }
    }
    
    public var blueBits: UInt8  {
        get { UInt8((rawBits & 0x0000FF00) >> 8) }
        set { rawBits = (rawBits & 0xFFFF00FF) | (UInt32(newValue) << 8) }
    }
    
    public var blue: Float {
        get { Float(blueBits) / Float(UInt8.max) }
        set { blueBits = UInt8(newValue * 255) }
    }
    
    public var alphaBits: UInt8  {
        get { UInt8(rawBits & 0x000000FF) }
        set { rawBits = (rawBits & 0xFFFFFF00) | (UInt32(newValue)) }
    }
    
    public var alpha: Float {
        get { Float(alphaBits) / Float(UInt8.max) }
        set { alphaBits = UInt8(newValue * 255) }
    }
    
    public var bitArray: [UInt8] { [redBits, greenBits, blueBits, alphaBits] }
    
    public init<T: BinaryInteger>(rawBits: T) {
        self.rawBits = UInt32(rawBits)
    }
    
    public init(integerLiteral value: Int) {
        self.init(rawBits: value)
    }
    
    public init(red: Float, green: Float, blue: Float, alpha: Float = 1.0) {
        self.init()
        (self.red, self.green, self.blue, self.alpha) = (red, green, blue, alpha)
    }
    
    public init<T: BinaryInteger>(red: T, green: T, blue: T, alpha: T = 255) {
        self.init(red: Float(red)/255, green: Float(green)/255, blue: Float(blue)/255, alpha: Float(alpha)/255)
    }
    
    public init() {
        self.init(rawBits: 0)
    }
}

public extension GLFWPixel {
    func settingRed(_ red: Float) -> GLFWPixel { GLFWPixel(red: red, green: green, blue: blue) }
    func settingRed<T: BinaryInteger>(_ redBits: T) -> GLFWPixel { GLFWPixel(red: UInt8(redBits), green: UInt8(greenBits), blue: UInt8(blueBits)) }
    func settingGreen(_ green: Float) -> GLFWPixel { GLFWPixel(red: red, green: green, blue: blue) }
    func settingGreen<T: BinaryInteger>(_ greenBits: T) -> GLFWPixel { GLFWPixel(red: UInt8(redBits), green: UInt8(greenBits), blue: UInt8(blueBits)) }
    func settingBlue(_ blue: Float) -> GLFWPixel { GLFWPixel(red: red, green: green, blue: blue) }
    func settingBlue<T: BinaryInteger>(_ blueBits: T) -> GLFWPixel { GLFWPixel(red: UInt8(redBits), green: UInt8(greenBits), blue: UInt8(blueBits)) }
    func settingAlpha(_ alpha: Float) -> GLFWPixel { GLFWPixel(red: red, green: green, blue: blue) }
    func settingAlpha<T: BinaryInteger>(_ alphaBits: T) -> GLFWPixel { GLFWPixel(red: UInt8(redBits), green: UInt8(greenBits), blue: UInt8(blueBits)) }
    
    mutating func setRed(_ red: Float) { self = settingRed(red) }
    mutating func setRed<T: BinaryInteger>(_ redBits: T) { self = settingRed(redBits) }
    mutating func setGreen(_ green: Float) { self = self.settingGreen(green) }
    mutating func setGreen<T: BinaryInteger>(_ greenBits: T) { self = settingGreen(greenBits) }
    mutating func setBlue(_ blue: Float) { self = settingBlue(blue) }
    mutating func setBlue<T: BinaryInteger>(_ blueBits: T) { self = settingBlue(blueBits) }
    mutating func setAlpha(_ alpha: Float) { self = settingAlpha(alpha) }
    mutating func setAlpha<T: BinaryInteger>(_ alphaBits: T) { self = settingAlpha(alphaBits) }
    
    var withPremultipliedAlpha: GLFWPixel { GLFWPixel(red: red * alpha, green: green * alpha, blue: blue * alpha, alpha: alpha) }
    
    func mixed(with other: GLFWPixel) -> GLFWPixel {
        let red = self.red * self.alpha * (1 - other.alpha) + other.red * other.alpha
        let green = self.green * self.alpha * (1 - other.alpha) + other.green * other.alpha
        let blue = self.blue * self.alpha * (1 - other.alpha) + other.blue * other.alpha
        let alpha = self.alpha * (1 - other.alpha) + other.alpha
        return GLFWPixel(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    mutating func mix(with other: GLFWPixel) {
        self = mixed(with: other)
    }
    
    static let white = GLFWPixel(0xFFFFFFFF)
    static let black = GLFWPixel(0x000000FF)
    static let clear = GLFWPixel(0x00000000)
    static let red = GLFWPixel(0xFF0000FF)
    static let orange = GLFWPixel(0xFF8000FF)
    static let yellow = GLFWPixel(0xFFFF00FF)
    static let green = GLFWPixel(0x00FF00FF)
    static let teal = GLFWPixel(0x00FF80FF)
    static let blue = GLFWPixel(0x0000FFFF)
    static let magenta = GLFWPixel(0xFF00FFFF)
    static let cyan = GLFWPixel(0x00FFFFFF)
    static let normal = GLFWPixel(0x8080FFFF)
}
