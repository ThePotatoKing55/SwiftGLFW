public struct Size: Hashable, Codable, Sendable {
    public var width: Double
    public var height: Double
    
    public init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    public init(_ width: Double, _ height: Double) {
        self.init(width: width, height: height)
    }
    
    public init(width: Int, height: Int) {
        self.width = Double(width)
        self.height = Double(height)
    }
    
    public init(_ width: Int, _ height: Int) {
        self.init(width: Double(width), height: Double(height))
    }
}

extension Size {
    public static var zero: Self { Self(width: 0, height: 0) }
    public static var one: Self { Self(width: 1, height: 1) }
    
    public static func * (lhs: Self, rhs: Double) -> Self { lhs.scaled(by: rhs) }
    public static func / (lhs: Self, rhs: Double) -> Self { lhs.scaled(by: 1 / rhs) }
    
    public static func *= (lhs: inout Self, rhs: Double) { lhs.scale(by: rhs) }
    public static func /= (lhs: inout Self, rhs: Double) { lhs.scale(by: 1 / rhs) }
    
    public var area: Double { width * height }
    public var perimeter: Double { 2 * (width + height) }
    
    public mutating func scale(by factor: Double) {
        self.width *= factor
        self.height *= factor
    }
    
    public func scaled(by factor: Double) -> Self {
        return Self(width: width * factor, height: height * factor)
    }
    
    public mutating func scale(by factor: Int) {
        self.scale(by: Double(factor))
    }
    
    public func scaled(by factor: Int) -> Self {
        return self.scaled(by: Double(factor))
    }
}
