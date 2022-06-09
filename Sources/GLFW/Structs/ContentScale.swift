public struct ContentScale: Hashable, Codable, Sendable {
    public var x: Double
    public var y: Double
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    public init(_ x: Double, _ y: Double) {
        self.init(x: x, y: y)
    }
}

extension ContentScale {
    public static var zero: Self { Self(0, 0) }
    public static var one: Self { Self(1, 1) }
    
    public static func * (lhs: Self, rhs: Double) -> Self { lhs.scaled(by: rhs) }
    public static func / (lhs: Self, rhs: Double) -> Self { lhs.scaled(by: 1 / rhs) }
    
    public static func *= (lhs: inout Self, rhs: Double) { lhs.scale(by: rhs) }
    public static func /= (lhs: inout Self, rhs: Double) { lhs.scale(by: 1 / rhs) }
    
    public mutating func scale(by factor: Double) {
        self.x *= factor
        self.y *= factor
    }
    
    public func scaled(by factor: Double) -> Self {
        return Self(x * factor, y * factor)
    }
    
    public mutating func scale(by factor: Int) {
        self.scale(by: Double(factor))
    }
    
    public func scaled(by factor: Int) -> Self {
        return self.scaled(by: Double(factor))
    }
}

extension Point {
    public mutating func scale(by scale: ContentScale) {
        self.x *= scale.x
        self.y *= scale.y
    }
    
    public func scaled(by scale: ContentScale) -> Self {
        Self(x * scale.x, y * scale.y)
    }
}

extension Size {
    public mutating func scale(by scale: ContentScale) {
        self.width *= scale.x
        self.height *= scale.y
    }
    
    public func scaled(by scale: ContentScale) -> Self {
        Self(width * scale.x, height * scale.y)
    }
}

extension Frame {
    public mutating func scale(by scale: ContentScale) {
        self.origin.scale(by: scale)
        self.size.scale(by: scale)
    }
    
    public func scaled(by scale: ContentScale) -> Self {
        Self(origin: origin.scaled(by: scale), size: size.scaled(by: scale))
    }
}
