import Foundation

@frozen
public struct GLPoint<Scalar: SIMDScalar>: Equatable, Hashable, Codable {
    public var simd: SIMD2<Scalar>
    public var x: Scalar { get { simd.x } set { simd.x = newValue } }
    public var y: Scalar { get { simd.y } set { simd.y = newValue } }
    
    @inlinable
    public init(x: Scalar, y: Scalar) { simd = .init(x, y) }
    
    @inlinable
    public init(_ simd: SIMD2<Scalar> = .init()) { self.simd = simd }
}

extension GLPoint: ExpressibleByArrayLiteral {
    public var arrayRepresentation: [Scalar] { [x, y] }
    
    @inlinable
    public init(arrayLiteral elements: Scalar...) {
        self.simd = .init(elements)
    }
}

extension GLPoint where Scalar: FixedWidthInteger {
    public static var zero: GLPoint<Scalar> { Self(.zero) }
    
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self { Self(lhs.simd &+ rhs.simd) }
    
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self { Self(lhs.simd &- rhs.simd) }
    
    @inlinable
    public static func * (lhs: Self, rhs: Scalar) -> Self { Self(lhs.simd &* rhs) }
}

extension GLPoint where Scalar: FloatingPoint {
    public static var zero: GLPoint<Scalar> { Self(.zero) }
    
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self { Self(lhs.simd + rhs.simd) }
    
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self { Self(lhs.simd - rhs.simd) }
    
    @inlinable
    public static func * (lhs: Self, rhs: Scalar) -> Self { Self(lhs.simd * rhs) }
    
    @inlinable
    public static func / (lhs: Self, rhs: Scalar) -> Self { Self(lhs.simd / rhs) }
    
    @inlinable
    public func distance(to other: GLPoint) -> Scalar {
        var distance = simd - other.simd
        distance *= distance
        return distance.sum().squareRoot()
    }
}
