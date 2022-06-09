import CGLFW3

public struct GLFWError: Error, Sendable {
    public let kind: ErrorKind
    public let description: String?
    
    public enum ErrorKind: Int32, Error, Equatable, Sendable {
        case none = 0
        case notInitialized = 0x00010001
        case noCurrentContext = 0x00010002
        case invalidEnum = 0x00010003
        case invalidValue = 0x00010004
        case outOfMemory = 0x00010005
        case apiUnavailable = 0x00010006
        case openGLVersionUnavailable = 0x00010007
        case platformSpecificError = 0x00010008
        case formatUnavailable = 0x00010009
        case noWindowContext = 0x0001000A
        case unknown
        
        public var description: String {
            switch self {
            case .none: return "No error has occurred."
            case .notInitialized: return "GLFW has not been initialized."
            case .noCurrentContext: return "No context is current for this thread."
            case .invalidEnum: return "One of the arguments to the function was an invalid enum value."
            case .invalidValue: return "One of the arguments to the function was an invalid value."
            case .outOfMemory: return "A memory allocation failed."
            case .apiUnavailable: return "GLFW could not find support for the requested API on the system."
            case .openGLVersionUnavailable: return "The requested OpenGL or OpenGL ES version is not available."
            case .platformSpecificError: return "A platform-specific error occurred that does not match any of the more specific categories."
            case .formatUnavailable: return "The requested format is not supported or available."
            case .noWindowContext: return "The specified window does not have an OpenGL or OpenGL ES context."
            case .unknown: return "An unknown error occurred."
            }
        }
    }
    
    init(kind: ErrorKind, description: String? = nil) {
        self.kind = kind
        self.description = description
    }
    
    init(kind: Int32, description: UnsafePointer<CChar>?) {
        self.init(kind: ErrorKind(rawValue: kind) ?? .unknown, description: description.flatMap(String.init(cString:)))
    }
}
