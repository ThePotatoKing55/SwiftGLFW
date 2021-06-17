import CGLFW3

@frozen
public struct GLImage: Equatable, Hashable, Codable {
    public var pixels: [Int: GLPixel] = [:]
    public var size: GLSize<Int> = []
    public var pixelArray: [UInt8] {
        var array = [UInt8](repeating: .zero, count: size.width * size.height * 4)
        pixels.forEach { index, pixel in
            if array.indices.contains(index * 4 + 3) {
                array.replaceSubrange((index * 4)...(index * 4 + 3), with: pixel.bitArray)
            }
        }
        return array
    }
    
    internal var glfwImage: GLFWimage {
        var pixels = pixelArray
        var image = GLFWimage()
        pixels.withUnsafeMutableBufferPointer { pointer in
            image = GLFWimage(width: size.width.int32, height: size.height.int32, pixels: pointer.baseAddress)
        }
        return image
    }
}
