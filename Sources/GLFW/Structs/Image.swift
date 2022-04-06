import CGLFW3

public struct Image: Hashable, Sendable {
    public var pixels: [Color]
    public var width, height: Int
    
    public init(width: Int, height: Int, pixels: [Color] = []) {
        self.pixels = pixels
        self.width = width
        self.height = height
    }
    
    var glfwImage: GLFWimage {
        pixels.withUnsafeBytes { bytes in
            let ptr = UnsafeMutablePointer(mutating: bytes.baseAddress!.assumingMemoryBound(to: UInt8.self))
            return GLFWimage(width: width.int32, height: height.int32, pixels: ptr)
        }
    }
}
