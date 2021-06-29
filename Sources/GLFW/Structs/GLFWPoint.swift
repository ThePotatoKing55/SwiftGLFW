@frozen
public struct GLFWPoint<Scalar: SIMDScalar>: Equatable, Hashable, Codable {
    public var simd: SIMD2<Scalar>
    public var x: Scalar { get { simd.x } set { simd.x = newValue } }
    public var y: Scalar { get { simd.y } set { simd.y = newValue } }
    
    @inlinable
    public init(x: Scalar, y: Scalar) { simd = .init(x, y) }
    
    @inlinable
    public init(_ simd: SIMD2<Scalar> = .init()) { self.simd = simd }
}

extension GLFWPoint: ExpressibleByArrayLiteral {
    public var arrayRepresentation: [Scalar] { [x, y] }
    
    @inlinable
    public init(arrayLiteral elements: Scalar...) {
        self.simd = .init(elements)
    }
}

extension GLFWPoint where Scalar: FixedWidthInteger {
    public static var zero: GLFWPoint<Scalar> { Self(.zero) }
    
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self { Self(lhs.simd &+ rhs.simd) }
    
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self { Self(lhs.simd &- rhs.simd) }
    
    @inlinable
    public static func * (lhs: Self, rhs: Scalar) -> Self { Self(lhs.simd &* rhs) }
}

extension GLFWPoint where Scalar: FloatingPoint {
    public static var zero: GLFWPoint<Scalar> { Self(.zero) }
    
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self { Self(lhs.simd + rhs.simd) }
    
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self { Self(lhs.simd - rhs.simd) }
    
    @inlinable
    public static func * (lhs: Self, rhs: Scalar) -> Self { Self(lhs.simd * rhs) }
    
    @inlinable
    public static func / (lhs: Self, rhs: Scalar) -> Self { Self(lhs.simd / rhs) }
    
    @inlinable
    public func distance(to other: GLFWPoint) -> Scalar {
        var distance = simd - other.simd
        distance *= distance
        return distance.sum().squareRoot()
    }
}
