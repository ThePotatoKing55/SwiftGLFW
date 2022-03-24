public struct Frame: Hashable, Codable {
    public var origin: Point
    public var size: Size
    
    public var x: Double {
        get { origin.x }
        set { origin.x = newValue }
    }
    
    public var y: Double {
        get { origin.y }
        set { origin.y = newValue }
    }
    
    public var width: Double {
        get { size.width }
        set { size.width = newValue }
    }
    
    public var height: Double {
        get { size.height }
        set { size.height = newValue }
    }
    
    public var min: Point {
        return Point(x: origin.x, y: origin.y)
    }
    public var max: Point {
        return Point(x: origin.x + size.width, y: origin.y + size.height)
    }
    
    public init(origin: Point = .zero, size: Size = .zero) {
        self.origin = origin
        self.size = size
    }
    
    public init(x: Double, y: Double, width: Double, height: Double) {
        self.init(origin: Point(x, y), size: Size(width, height))
    }
    
    public init(x: Int, y: Int, width: Int, height: Int) {
        self.init(origin: Point(x, y), size: Size(x, y))
    }
    
    public init(x: Double, y: Double, maxX: Double, maxY: Double) {
        self.init(origin: Point(x, y), size: Size(maxX - x, maxY - y))
    }
    
    public init(from origin: Point, to bound: Point) {
        self.init(x: origin.x, y: origin.y, maxX: bound.x, maxY: bound.y)
    }
}

extension Frame {
    public func contains(_ point: Point) -> Bool {
        return point.x >= x && point.x <= max.x && point.y >= y && point.y <= max.y
    }
    
    public func contains(_ frame: Frame) -> Bool {
        return contains(frame.origin) && contains(frame.max)
    }
    
    public func intersects(_ other: Frame) -> Bool {
        return x <= other.max.x && max.x >= other.x && y <= other.max.y && max.y >= other.y
    }
}
