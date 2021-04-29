import Foundation

public struct GLFrame<Scalar: SIMDScalar>: Equatable, Hashable, Codable {
    public var simd: SIMD4<Scalar>
    
    @inlinable
    public var x: Scalar {
        get { x1 } set { x1 = newValue }
    }
    
    @inlinable
    public var y: Scalar {
        get { y1 } set { y1 = newValue }
    }
    
    @inlinable
    public var x1: Scalar {
        get { simd.x }
        set { simd.x = newValue }
    }
    
    @inlinable
    public var y1: Scalar {
        get { simd.y }
        set { simd.y = newValue }
    }
    
    @inlinable
    public var x2: Scalar {
        get { simd.z }
        set { simd.z = newValue }
    }
    
    @inlinable
    public var y2: Scalar {
        get { simd.w }
        set { simd.w = newValue }
    }
    
    @inlinable
    public var origin: GLPoint<Scalar> {
        get { GLPoint(simd.lowHalf) }
        set { simd.lowHalf = newValue.simd }
    }
    
    @inlinable
    public init(x1: Scalar, y1: Scalar, x2: Scalar, y2: Scalar) {
        self.simd = SIMD4(x1, y1, x2, y2)
    }
    
    @inlinable
    public init(x: Scalar, y: Scalar) {
        self.init(x1: x, y1: y, x2: x, y2: y)
    }
    
    @inlinable
    public init(_ simd: SIMD4<Scalar> = .init()) { self.simd = simd }
}

extension GLFrame: ExpressibleByArrayLiteral {
    @inlinable
    public init(arrayLiteral elements: Scalar...) {
        self.simd = .init(elements)
    }
}

extension GLFrame where Scalar: Comparable {
    @inlinable
    public func contains(_ point: GLPoint<Scalar>) -> Bool {
        let lowMask = simd.lowHalf .<= point.simd
        let highMask = simd.highHalf .>= point.simd
        return (lowMask == [true, true]) && (highMask == [true, true])
    }
    
    @inlinable
    public func contains(_ frame: GLFrame) -> Bool {
        contains(GLPoint(frame.simd.lowHalf)) && contains(GLPoint(frame.simd.highHalf))
    }
    
    @inlinable
    public func intersects(_ other: GLFrame) -> Bool {
        self.x1 < other.x2 && self.x2 > other.x1 &&
            self.y1 < other.y2 && self.y2 > other.y1
    }
}

extension GLFrame where Scalar: AdditiveArithmetic {
    @inlinable
    public var arrayRepresentation: [Scalar] { [simd.x, simd.y, simd.x + simd.z, simd.y + simd.w] }
    
    @inlinable
    public var width: Scalar {
        get { x2 - x1 }
        set { x2 = x1 + newValue }
    }
    
    @inlinable
    public var height: Scalar {
        get { y2 - y1 }
        set { y2 = y1 + newValue }
    }
    
    @inlinable
    public var size: GLSize<Scalar> {
        get { GLSize(width: simd.z - simd.x, height: simd.w - simd.y) }
        set { simd.highHalf = [simd.x + newValue.width, simd.y + newValue.height] }
    }
    
    @inlinable
    public init(x: Scalar, y: Scalar, width: Scalar, height: Scalar) {
        simd = SIMD4(x, y, x + width, y + height)
    }
    
    @inlinable
    public init(width: Scalar, height: Scalar) {
        self.init(x: .zero, y: .zero, width: width, height: height)
    }
    
    @inlinable
    public init(origin: GLPoint<Scalar>, size: GLSize<Scalar>) {
        self.init(.init(lowHalf: origin.simd, highHalf: [origin.simd.x + size.simd.x, origin.simd.y + size.simd.y]))
    }
}

extension GLFrame where Scalar: FloatingPoint {
    @inlinable
    public var size: GLSize<Scalar> {
        get { GLSize(simd.highHalf - simd.lowHalf) }
        set { simd.highHalf = simd.lowHalf + newValue.simd }
    }
    
    @inlinable
    public init(origin: GLPoint<Scalar>, size: GLSize<Scalar>) {
        self.init(.init(lowHalf: origin.simd, highHalf: origin.simd + size.simd))
    }
}
