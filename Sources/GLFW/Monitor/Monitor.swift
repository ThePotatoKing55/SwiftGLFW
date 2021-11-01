import CGLFW3

@available(*, unavailable, renamed: "Monitor")
public final class GLFWMonitor {}

public final class Monitor: GLFWObject {
    internal(set) public var pointer: OpaquePointer?
    
    public var connectionHandler: (() -> Void)?
    public var disconnectionHandler: (() -> Void)?
    
    init(_ pointer: OpaquePointer?) {
        self.pointer = pointer
        
        guard let pointer = pointer else { return }
        glfwSetMonitorUserPointer(pointer, Unmanaged.passUnretained(self).toOpaque())
        
        func monitorObject(_ pointer: OpaquePointer?) -> Monitor {
            Unmanaged.fromOpaque(glfwGetMonitorUserPointer(pointer)).takeUnretainedValue()
        }
        
        glfwSetMonitorCallback {
            let monitor = Monitor.fromOpaque($0)
            $1.bool ? monitor.connectionHandler?() : monitor.disconnectionHandler?()
        }
    }
    
    public static func fromOpaque(_ pointer: OpaquePointer!) -> Monitor {
        if let opaque = glfwGetMonitorUserPointer(pointer) {
            return Unmanaged.fromOpaque(opaque).takeUnretainedValue()
        } else {
            return Monitor(pointer)
        }
    }
    
    deinit {
        glfwSetMonitorCallback(nil)
        glfwSetMonitorUserPointer(pointer, nil)
    }
    
    public static var primary: Monitor {
        .fromOpaque(glfwGetPrimaryMonitor())
    }
    
    public static var current: [Monitor] {
        var count = Int32.zero
        let pointer = glfwGetMonitors(&count)
        let array = Array(UnsafeBufferPointer(start: pointer, count: count.int))
        return array.map(Monitor.fromOpaque(_:))
    }
    
    public var name: String {
        String(cString: glfwGetMonitorName(pointer))
    }
    
    public var virtualPosition: DiscretePoint {
        var x = Int32.zero, y = Int32.zero
        glfwGetMonitorPos(pointer, &x, &y)
        return DiscretePoint(x: x.int, y: y.int)
    }
    
    public typealias SizeInMillimeters = DiscreteSize
    
    public var physicalSize: SizeInMillimeters {
        var width = Int32.zero, height = Int32.zero
        glfwGetMonitorPhysicalSize(pointer, &width, &height)
        return SizeInMillimeters(width: width.int, height: height.int)
    }
    
    public var contentScale: ContentScale {
        var xscale = Float.zero, yscale = Float.zero
        glfwGetMonitorContentScale(pointer, &xscale, &yscale)
        return ContentScale(x: Double(xscale), y: Double(yscale))
    }
    
    public var workArea: DiscreteFrame {
        var x = Int32.zero, y = Int32.zero, width = Int32.zero, height = Int32.zero
        glfwGetMonitorWorkarea(pointer, &x, &y, &width, &height)
        return DiscreteFrame(x: x.int, y: y.int, width: width.int, height: height.int)
    }
    
    public struct VideoMode: Equatable, Codable, Hashable {
        public var redBitDepth, greenBitDepth, blueBitDepth: Int
        public var size: DiscreteSize
        public var refreshRate: Int
        internal init(_ vidMode: GLFWvidmode) {
            (redBitDepth, greenBitDepth, blueBitDepth) = (vidMode.redBits.int, vidMode.greenBits.int, vidMode.blueBits.int)
            size = DiscreteSize(vidMode.width.int, vidMode.height.int)
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
    
    public struct GammaStop: Equatable, Codable, Hashable {
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


