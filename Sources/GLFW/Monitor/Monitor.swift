import CGLFW3

@MainActor
public final class GLFWMonitor: GLFWObject {
    public let pointer: OpaquePointer?
    
    public var connectionHandler: (() -> Void)?
    public var disconnectionHandler: (() -> Void)?
    
    init(_ pointer: OpaquePointer?) {
        self.pointer = pointer
        
        guard let pointer = pointer else { return }
        glfwSetMonitorUserPointer(pointer, Unmanaged.passUnretained(self).toOpaque())
        
        func monitorObject(_ pointer: OpaquePointer?) -> GLFWMonitor {
            Unmanaged.fromOpaque(glfwGetMonitorUserPointer(pointer)).takeUnretainedValue()
        }
        
        glfwSetMonitorCallback {
            let monitor = GLFWMonitor.fromOpaque($0)
            Bool($1) ? monitor.connectionHandler?() : monitor.disconnectionHandler?()
        }
    }
    
    public static func fromOpaque(_ pointer: OpaquePointer!) -> GLFWMonitor {
        if let opaque = glfwGetMonitorUserPointer(pointer) {
            return Unmanaged.fromOpaque(opaque).takeUnretainedValue()
        } else {
            return GLFWMonitor(pointer)
        }
    }
    
    deinit {
        glfwSetMonitorCallback(nil)
        glfwSetMonitorUserPointer(pointer, nil)
    }
    
    public static var primary: GLFWMonitor {
        .fromOpaque(glfwGetPrimaryMonitor())
    }
    
    public static var current: [GLFWMonitor] {
        var count = Int32.zero
        let pointer = glfwGetMonitors(&count)
        let array = Array(UnsafeBufferPointer(start: pointer, count: count.int))
        return array.map { GLFWMonitor.fromOpaque($0) }
    }
    
    public var name: String {
        String(cString: glfwGetMonitorName(pointer))
    }
    
    public var virtualPosition: Point {
        var x = Int32.zero, y = Int32.zero
        glfwGetMonitorPos(pointer, &x, &y)
        return Point(x: Double(x), y: Double(y))
    }
    
    public typealias SizeInMillimeters = Size
    
    public var physicalSize: SizeInMillimeters {
        var width = Int32.zero, height = Int32.zero
        glfwGetMonitorPhysicalSize(pointer, &width, &height)
        return SizeInMillimeters(width: Double(width), height: Double(height))
    }
    
    public var contentScale: ContentScale {
        var xscale = Float.zero, yscale = Float.zero
        glfwGetMonitorContentScale(pointer, &xscale, &yscale)
        return ContentScale(x: Double(xscale), y: Double(yscale))
    }
    
    public var workArea: Frame {
        var x = Int32.zero, y = Int32.zero, width = Int32.zero, height = Int32.zero
        glfwGetMonitorWorkarea(pointer, &x, &y, &width, &height)
        return Frame(x: Double(x), y: Double(y), width: Double(width), height: Double(height))
    }
    
    public struct VideoMode: Codable, Hashable, Sendable {
        public var redBitDepth, greenBitDepth, blueBitDepth: Int
        public var size: Size
        public var refreshRate: Int
        internal init(_ vidMode: GLFWvidmode) {
            (redBitDepth, greenBitDepth, blueBitDepth) = (vidMode.redBits.int, vidMode.greenBits.int, vidMode.blueBits.int)
            size = Size(Double(vidMode.width), Double(vidMode.height))
            refreshRate = vidMode.refreshRate.int
        }
    }
    
    public var currentVideoMode: VideoMode {
        return VideoMode(glfwGetVideoMode(pointer).pointee)
    }
    
    public var videoModes: [VideoMode] {
        var count = Int32.zero
        let modes = glfwGetVideoModes(pointer, &count)
        let videoModes: [GLFWvidmode] = Array(UnsafeBufferPointer(start: modes, count: count.int))
        return videoModes.map(VideoMode.init)
    }
    
    public struct GammaStop: Codable, Hashable, Sendable {
        public var red, green, blue: Int
    }
    
    public struct GammaRamp {
        fileprivate var size: CUnsignedInt { CUnsignedInt(stops.count) }
        fileprivate var red: [CUnsignedShort] { stops.map(\.red).map(CUnsignedShort.init(_:)) }
        fileprivate var green: [CUnsignedShort] { stops.map(\.green).map(CUnsignedShort.init(_:)) }
        fileprivate var blue: [CUnsignedShort] { stops.map(\.blue).map(CUnsignedShort.init(_:)) }
        public var stops: [GammaStop]
    }
    
    public var gammaRamp: GammaRamp {
        get {
            let ramp = glfwGetGammaRamp(pointer).pointee
            let size = ramp.size
            let red = Array(UnsafeBufferPointer(start: ramp.red, count: size.int)).map(Int.init(_:))
            let green = Array(UnsafeBufferPointer(start: ramp.green, count: size.int)).map(Int.init(_:))
            let blue = Array(UnsafeBufferPointer(start: ramp.blue, count: size.int)).map(Int.init(_:))
            return GammaRamp(stops: (0..<size).reduce(into: [], { result, i in
                let index = i.int
                result.append(GammaStop(red: red[index], green: green[index], blue: blue[index]))
            }))
        }
        set {
            let red = UnsafeMutablePointer<CUnsignedShort>.allocate(capacity: newValue.stops.count)
            red.assign(from: newValue.red, count: newValue.stops.count)
            let green = UnsafeMutablePointer<CUnsignedShort>.allocate(capacity: newValue.stops.count)
            green.assign(from: newValue.green, count: newValue.stops.count)
            let blue = UnsafeMutablePointer<CUnsignedShort>.allocate(capacity: newValue.stops.count)
            blue.assign(from: newValue.blue, count: newValue.stops.count)
            var ramp = GLFWgammaramp(red: red, green: green, blue: blue, size: newValue.size)
            glfwSetGammaRamp(pointer, &ramp)
            red.deallocate()
            green.deallocate()
            blue.deallocate()
        }
    }
    
    public func setGamma(power: Float) {
        glfwSetGamma(pointer, power)
    }
}


