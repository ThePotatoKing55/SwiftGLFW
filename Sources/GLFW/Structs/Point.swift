public struct Point: Equatable, Hashable, Codable {
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

extension Point {
    public static var zero: Self { Self(x: 0, y: 0) }
    
    public static func + (lhs: Self, rhs: Self) -> Self { Self(lhs.x + rhs.x, lhs.y + rhs.y) }
    public static func - (lhs: Self, rhs: Self) -> Self { Self(lhs.x - rhs.x, lhs.y - rhs.y) }
    public static func * (lhs: Self, rhs: Double) -> Self { Self(lhs.x * rhs, lhs.y * rhs) }
    public static func / (lhs: Self, rhs: Double) -> Self { Self(lhs.x / rhs, lhs.y / rhs) }
    
    public static func += (lhs: inout Self, rhs: Self) { lhs.x += rhs.x; lhs.y += rhs.y }
    public static func -= (lhs: inout Self, rhs: Self) { lhs.x -= rhs.x; lhs.y -= rhs.y }
    public static func *= (lhs: inout Self, rhs: Double) { lhs.x *= rhs; lhs.y *= rhs }
    public static func /= (lhs: inout Self, rhs: Double) { lhs.x /= rhs; lhs.y /= rhs }
    
    public func distance(to other: Self) -> Double {
        let distance = self - other
        return (distance.x * distance.x + distance.y * distance.y).squareRoot()
    }
}
