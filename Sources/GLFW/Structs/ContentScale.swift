@available(*, unavailable, renamed: "ContentScale")
public struct GLFWContentScale {}

public struct ContentScale: Equatable, Hashable, Codable {
    public var x: Double
    public var y: Double
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

extension ContentScale {
    public static var one: Self { Self(x: 1, y: 1) }
    
    public mutating func scale(by factor: Double) {
        self = scaled(by: factor)
    }
    
    public func scaled(by factor: Double) -> Self {
        return Self(x: x * factor, y: y * factor)
    }
}
