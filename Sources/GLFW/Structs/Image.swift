import CGLFW3

public struct Image: Hashable, Sendable {
    public var pixels: [Color]
    public var width, height: Int
    
    public init(width: Int, height: Int, pixels: [Color] = []) {
        self.pixels = pixels
        self.width = width
        self.height = height
    }
    
    public init(width: Int, height: Int, initializer: @Sendable @escaping (Int, Int) -> Color) async {
        self.width = width
        self.height = height
        self.pixels = await withTaskGroup(of: (index: Int, row: [Color]).self, returning: [Color].self) { group in
            var rows = [[Color]](repeating: [], count: height)
            for y in 0 ..< height {
                group.addTask {
                    return (y, (0 ..< width).reduce(into: []) { row, x in
                        row.append(initializer(x, y))
                    })
                }
            }
            for await result in group {
                rows.insert(result.row, at: result.index)
            }
            
            return rows.flatMap { $0 }
        }
    }
    
    var glfwImage: GLFWimage {
        pixels.withUnsafeBytes { bytes in
            let ptr = UnsafeMutablePointer(mutating: bytes.baseAddress!.assumingMemoryBound(to: UInt8.self))
            return GLFWimage(width: width.int32, height: height.int32, pixels: ptr)
        }
    }
}
