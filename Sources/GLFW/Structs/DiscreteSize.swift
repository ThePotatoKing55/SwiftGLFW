public struct DiscreteSize: Equatable, Hashable, Codable {
    public var width: Int
    public var height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    public init(_ width: Int, _ height: Int) {
        self.init(width: width, height: height)
    }
}

extension DiscreteSize {
    public static var zero: Self { Self(width: 0, height: 0) }
    
    public static func + (lhs: Self, rhs: Self) -> Self { Self(lhs.width + rhs.width, lhs.height + rhs.height) }
    public static func - (lhs: Self, rhs: Self) -> Self { Self(lhs.width - rhs.width, lhs.height - rhs.height) }
    public static func * (lhs: Self, rhs: Int) -> Self { Self(lhs.width * rhs, lhs.height * rhs) }
    public static func / (lhs: Self, rhs: Int) -> Self { Self(lhs.width / rhs, lhs.height / rhs) }
    
    public static func += (lhs: inout Self, rhs: Self) { lhs.width += rhs.width; lhs.height += rhs.height }
    public static func -= (lhs: inout Self, rhs: Self) { lhs.width -= rhs.width; lhs.height -= rhs.height }
    public static func *= (lhs: inout Self, rhs: Int) { lhs.width *= rhs; lhs.height *= rhs }
    public static func /= (lhs: inout Self, rhs: Int) { lhs.width /= rhs; lhs.height /= rhs }
    
    public var area: Int { width * height }
    public var perimeter: Int { 2 * (width + height) }
    
    public mutating func scale(by factor: Int) {
        self = scaled(by: factor)
    }
    
    public func scaled(by factor: Int) -> Self {
        return self * factor
    }
}
