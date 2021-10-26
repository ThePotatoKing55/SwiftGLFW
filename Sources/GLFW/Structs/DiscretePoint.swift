public struct DiscretePoint: Equatable, Hashable, Codable {
    public var x: Int
    public var y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public init(_ x: Int, _ y: Int) {
        self.init(x: x, y: y)
    }
}

extension DiscretePoint {
    public static var zero: Self { Self(x: 0, y: 0) }
    
    public static func + (lhs: Self, rhs: Self) -> Self { Self(lhs.x + rhs.x, lhs.y + rhs.y) }
    public static func - (lhs: Self, rhs: Self) -> Self { Self(lhs.x - rhs.x, lhs.y - rhs.y) }
    public static func * (lhs: Self, rhs: Int) -> Self { Self(lhs.x * rhs, lhs.y * rhs) }
    public static func / (lhs: Self, rhs: Int) -> Self { Self(lhs.x / rhs, lhs.y / rhs) }
    
    public static func += (lhs: inout Self, rhs: Self) { lhs.x += rhs.x; lhs.y += rhs.y }
    public static func -= (lhs: inout Self, rhs: Self) { lhs.x -= rhs.x; lhs.y -= rhs.y }
    public static func *= (lhs: inout Self, rhs: Int) { lhs.x *= rhs; lhs.y *= rhs }
    public static func /= (lhs: inout Self, rhs: Int) { lhs.x /= rhs; lhs.y /= rhs }
}
