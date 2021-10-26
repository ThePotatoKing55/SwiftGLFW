import CGLFW3

public struct GLFWImage: Equatable, Hashable, Codable {
    public var pixels: [GLFWPixel] = []
    public var size: DiscreteSize = .zero
    
    internal var glfwImage: GLFWimage {
        var pixels = pixels
        return pixels.withUnsafeMutableBytes { buffer in
            let baseAddress = buffer.bindMemory(to: UInt8.self).baseAddress
            return GLFWimage(width: Int32(size.width), height: Int32(size.height), pixels: baseAddress)
        }
    }
}
