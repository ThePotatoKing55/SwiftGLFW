public struct DiscreteFrame: Equatable, Hashable, Codable {
    public var origin: DiscretePoint
    public var size: DiscreteSize
    
    public var x: Int {
        get { origin.x }
        set { origin.x = newValue }
    }
    
    public var y: Int {
        get { origin.y }
        set { origin.y = newValue }
    }
    
    public var width: Int {
        get { size.width }
        set { size.width = newValue }
    }
    
    public var height: Int {
        get { size.height }
        set { size.height = newValue }
    }
    
    public var max: DiscretePoint {
        return DiscretePoint(x: origin.x + size.width, y: origin.y + size.height)
    }
    
    public init(origin: DiscretePoint, size: DiscreteSize) {
        self.origin = origin
        self.size = size
    }
    
    public init(x: Int, y: Int, width: Int, height: Int) {
        self.init(origin: DiscretePoint(x, y), size: DiscreteSize(width, height))
    }
    
    public init(x: Int, y: Int, maxX: Int, maxY: Int) {
        self.init(origin: DiscretePoint(x, y), size: DiscreteSize(maxX - x, maxY - y))
    }
    
    public init(from origin: DiscretePoint, to bound: DiscretePoint) {
        self.init(x: origin.x, y: origin.y, maxX: bound.x, maxY: bound.y)
    }
}

extension DiscreteFrame {
    public func contains(_ point: DiscretePoint) -> Bool {
        return point.x >= x && point.x <= max.x && point.y >= y && point.y <= max.y
    }
    
    public func contains(_ frame: DiscreteFrame) -> Bool {
        return contains(frame.origin) && contains(frame.max)
    }
    
    public func intersects(_ other: DiscreteFrame) -> Bool {
        return x <= other.max.x && max.x >= other.x && y <= other.max.y && max.y >= other.y
    }
}
