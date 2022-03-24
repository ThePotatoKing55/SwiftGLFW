import CGLFW3

public struct Image: Hashable {
    public var pixels: [Color]
    public var width, height: Int
    
    var glfwImage: GLFWimage {
        pixels.withUnsafeBytes { bytes in
            let ptr = UnsafeMutablePointer(mutating: bytes.baseAddress!.assumingMemoryBound(to: UInt8.self))
            return GLFWimage(width: width.int32, height: height.int32, pixels: ptr)
        }
    }
}
