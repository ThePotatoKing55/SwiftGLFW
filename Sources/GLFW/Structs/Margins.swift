public struct Margins: Hashable, Codable, Sendable {
    public var left, right: Int
    public var top, bottom: Int
    
    public init(left: Int, right: Int, top: Int, bottom: Int) {
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
    
    public init() {
        self.init(left: 0, right: 0, top: 0, bottom: 0)
    }
    
    public static var zero: Self {
        .init()
    }
}
