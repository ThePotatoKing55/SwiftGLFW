#if os(macOS) && canImport(Cocoa)
import Cocoa
import CGLFW3

extension GLFWSession {
    @InitHint(.cocoaChDirResources, default: false)
    public static var relativeToAppResources: Bool
    
    @InitHint(.cocoaMenuBar, default: true)
    public static var generateMenuBar: Bool
}

extension GLFWMonitor {
    nonisolated public var directDisplayID: CGDirectDisplayID {
        return glfwGetCocoaMonitor(pointer)
    }
}

extension GLFWWindow {
    nonisolated public var nsWindow: NSWindow? {
        return glfwGetCocoaWindow(pointer) as? NSWindow
    }
}

extension Image {
    public func makeCGImage() -> CGImage? {
        let bytes = 4 * width * height
        let buffer = UnsafeMutableRawPointer.allocate(byteCount: bytes, alignment: 0)
        pixels.withUnsafeBytes { pixels in
            buffer.copyMemory(from: pixels.baseAddress!, byteCount: pixels.count)
        }
        
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        if let context = CGContext(data: buffer, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 4 * width, space: colorSpace, bitmapInfo: bitmapInfo, releaseCallback: { _, data in data?.deallocate() }, releaseInfo: nil) {
            return context.makeImage()
        } else {
            buffer.deallocate()
            return nil
        }
    }
    
    public func makeNSImage() -> NSImage? {
        makeCGImage().map { NSImage(cgImage: $0, size: NSSize(width: width, height: height)) }
    }
}

extension GLFWWindow {
    public func setIcon(_ image: Image) {
        if let image = image.makeNSImage() {
            NSApp.applicationIconImage = image
        }
    }
    
    public func resetIcon() {
        NSApp.applicationIconImage = nil
    }
    
    public func setDockPreview(_ image: Image) {
        if let window = nsWindow, let preview = image.makeNSImage() {
            if let contentView = window.dockTile.contentView as? NSImageView {
                contentView.image = preview
            } else {
                let imageView = NSImageView(image: preview)
                window.dockTile.contentView = imageView
            }
            window.dockTile.display()
        }
    }
    
    public func resetDockPreview() {
        nsWindow?.dockTile.contentView = nil
        nsWindow?.dockTile.display()
    }
}

extension GLFWContext {
    @available(macOS, deprecated: 10.14, message: "Please use Metal or MetalKit.")
    nonisolated public var nsOpenGLContext: NSOpenGLContext? {
        return glfwGetNSGLContext(pointer) as? NSOpenGLContext
    }
}

#if GLFW_METAL_LAYER_SUPPORT
@available(macOS 10.11, *)
extension GLFWWindow {
    public var metalLayer: CAMetalLayer? {
        return glfwGetMetalLayer(pointer) as? CAMetalLayer
    }
}
#endif
#endif
