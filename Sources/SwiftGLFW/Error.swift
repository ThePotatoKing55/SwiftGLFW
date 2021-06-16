import Foundation
import GLFW

@frozen
public enum GLFWError: Int32, LocalizedError, Equatable {
    case noError = 0
    case notInitialized = 0x00010001
    case noCurrentContext = 0x00010002
    case invalidEnum = 0x00010003
    case invalidValue = 0x00010004
    case outOfMemory = 0x00010005
    case apiUnavailable = 0x00010006
    case versionUnavailable = 0x00010007
    case platformError = 0x00010008
    case formatUnavailable = 0x00010009
    case noWindowContext = 0x0001000A
    case unknown
    
    public var localizedDescription: String {
        errorDescription
    }
    
    public var errorDescription: String {
        switch self {
        case .noError: return "GLFW_NO_ERROR: No error has occurred."
        case .notInitialized: return "GLFW_NOT_INITIALIZED: GLFW has not been initialized."
        case .noCurrentContext: return "GLFW_NO_CURRENT_CONTEXT: No context is current for this thread."
        case .invalidEnum: return "GLFW_INVALID_ENUM: One of the arguments to the function was an invalid enum value."
        case .invalidValue: return "GLFW_INVALID_VALUE: One of the arguments to the function was an invalid value."
        case .outOfMemory: return "GLFW_OUT_OF_MEMORY: A memory allocation failed."
        case .apiUnavailable: return "GLFW_API_UNAVAILABLE: GLFW could not find support for the requested API on the system."
        case .versionUnavailable: return "GLFW_VERSION_UNAVAILABLE: The requested OpenGL or OpenGL ES version is not available."
        case .platformError: return "GLFW_PLATFORM_ERROR: A platform-specific error occurred that does not match any of the more specific categories."
        case .formatUnavailable: return "GLFW_FORMAT_UNAVAILABLE: The requested format is not supported or available."
        case .noWindowContext: return "GLFW_NO_WINDOW_CONTEXT: The specified window does not have an OpenGL or OpenGL ES context."
        case .unknown: return "An unknown error occurred."
        }
    }
}
