import Foundation
import CGLFW3

public final class GLMonitor: GLObject {
    internal(set) public var pointer: OpaquePointer?
    
    public var connectionHandler: (() -> Void)?
    public var disconnectionHandler: (() -> Void)?
    
    init(_ pointer: OpaquePointer?) {
        self.pointer = pointer
        
        guard let pointer = pointer else { return }
        glfwSetMonitorUserPointer(pointer, Unmanaged.passUnretained(self).toOpaque())
        
        func monitorObject(_ pointer: OpaquePointer?) -> GLMonitor {
            Unmanaged.fromOpaque(glfwGetMonitorUserPointer(pointer)).takeUnretainedValue()
        }
        
        glfwSetMonitorCallback {
            //let monitor = monitorObject($0)
            let monitor = GLMonitor.fromOpaque($0)
            $1.bool ? monitor.connectionHandler?() : monitor.disconnectionHandler?()
        }
    }
    
    public static func fromOpaque(_ pointer: OpaquePointer!) -> GLMonitor {
        if let opaque = glfwGetMonitorUserPointer(pointer) {
            return Unmanaged.fromOpaque(opaque).takeUnretainedValue()
        } else {
            return GLMonitor(pointer)
        }
    }
    
    deinit {
        glfwSetMonitorCallback(nil)
        glfwSetMonitorUserPointer(pointer, nil)
    }
    
    public static var primary: GLMonitor {
        .fromOpaque(glfwGetPrimaryMonitor())
    }
    
    public static var current: [GLMonitor] {
        var count = Int32.zero
        let pointer = glfwGetMonitors(&count)
        let array = Array(UnsafeBufferPointer(start: pointer, count: count.int))
        return array.map(GLMonitor.fromOpaque(_:))
    }
    
    public var name: String {
        String(cString: glfwGetMonitorName(pointer))
    }
    
    public var virtualPosition: GLPoint<Int> {
        var x = Int32.zero, y = Int32.zero
        glfwGetMonitorPos(pointer, &x, &y)
        return GLPoint(x: x.int, y: y.int)
    }
    
    public typealias GLSizeMM = GLSize<Int>
    
    public var physicalSize: GLSizeMM {
        var width = Int32.zero, height = Int32.zero
        glfwGetMonitorPhysicalSize(pointer, &width, &height)
        return GLSizeMM(width: width.int, height: height.int)
    }
    
    public var contentScale: GLContentScale {
        var xscale = Float.zero, yscale = Float.zero
        glfwGetMonitorContentScale(pointer, &xscale, &yscale)
        return GLContentScale(xscale: xscale, yscale: yscale)
    }
    
    public var workArea: GLFrame<Int> {
        var x = Int32.zero, y = Int32.zero, width = Int32.zero, height = Int32.zero
        glfwGetMonitorWorkarea(pointer, &x, &y, &width, &height)
        return GLFrame(x: x.int, y: y.int, width: width.int, height: height.int)
    }
    
    public struct VideoMode: Equatable, Codable, Hashable {
        public var redBitDepth, greenBitDepth, blueBitDepth: Int
        public var size: GLSize<Int>
        public var refreshRate: Int
        internal init(_ vidMode: GLFWvidmode) {
            (redBitDepth, greenBitDepth, blueBitDepth) = (vidMode.redBits.int, vidMode.greenBits.int, vidMode.blueBits.int)
            size = [vidMode.width.int, vidMode.height.int]
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
        fileprivate var size: GLuint { GLuint(stops.count) }
        fileprivate var red: [GLushort] { stops.map(\.red).map(GLushort.init(_:)) }
        fileprivate var green: [GLushort] { stops.map(\.green).map(GLushort.init(_:)) }
        fileprivate var blue: [GLushort] { stops.map(\.blue).map(GLushort.init(_:)) }
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
            let red = UnsafeMutablePointer<GLushort>.allocate(capacity: newValue.stops.count)
            red.assign(from: newValue.red, count: newValue.stops.count)
            let green = UnsafeMutablePointer<GLushort>.allocate(capacity: newValue.stops.count)
            green.assign(from: newValue.green, count: newValue.stops.count)
            let blue = UnsafeMutablePointer<GLushort>.allocate(capacity: newValue.stops.count)
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


