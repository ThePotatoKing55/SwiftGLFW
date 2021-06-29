@frozen
public struct GLFWSize<Scalar: SIMDScalar>: Equatable, Hashable, Codable {
    public var simd: SIMD2<Scalar>
    
    @inlinable
    public var width: Scalar {
        get { simd.x }
        set { simd.x = newValue }
    }
    
    @inlinable
    public var height: Scalar {
        get { simd.y }
        set { simd.y = newValue }
    }
    
    @inlinable
    public init(width: Scalar, height: Scalar) { self.init(.init(x: width, y: height)) }
    
    @inlinable
    public init(_ simd: SIMD2<Scalar>) { self.simd = simd }
}

extension GLFWSize: ExpressibleByArrayLiteral {
    public var arrayRepresentation: [Scalar] { [width, height] }
    
    @inlinable
    public init(arrayLiteral elements: Scalar...) {
        precondition(elements.count >= 2, "GLFWSize must be initialized with an array of at least 2.")
        self.init(width: elements[0], height: elements[1])
    }
}

extension GLFWSize where Scalar: FixedWidthInteger {
    public static var zero: Self { Self() }
    
    @inlinable
    public init() { self.init(width: .zero, height: .zero) }
}

extension GLFWSize where Scalar: FloatingPoint {
    
    public static var zero: Self { Self() }
    
    @inlinable
    public init() { self.init(width: .zero, height: .zero) }
}

extension GLFWSize where Scalar: Numeric {
    public var area: Scalar {
        width * height
    }
    
    public var perimeter: Scalar {
        2 * (width + height)
    }
    
    public mutating func scale(by rhs: Scalar) {
        self = scaled(by: rhs)
    }
    
    public func scaled(by rhs: Scalar) -> Self {
        Self(width: width * rhs, height: height * rhs)
    }
}
