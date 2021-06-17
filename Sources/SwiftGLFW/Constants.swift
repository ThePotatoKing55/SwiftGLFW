import Foundation
import CGLFW3

enum Constant {
    static let `true`: Int32 = GLFW_TRUE
    static let `false`: Int32 = GLFW_FALSE
    
    static let focused: Int32 = GLFW_FOCUSED
    static let iconified: Int32 = GLFW_ICONIFIED
    static let resizable: Int32 = GLFW_RESIZABLE
    static let visible: Int32 = GLFW_VISIBLE
    static let decorated: Int32 = GLFW_DECORATED
    static let autoIconify: Int32 = GLFW_AUTO_ICONIFY
    static let floating: Int32 = GLFW_FLOATING
    static let maximized: Int32 = GLFW_MAXIMIZED
    static let centerCursor: Int32 = GLFW_CENTER_CURSOR
    static let transparentFramebuffer: Int32 = GLFW_TRANSPARENT_FRAMEBUFFER
    static let hovered: Int32 = GLFW_HOVERED
    static let focusOnShow: Int32 = GLFW_FOCUS_ON_SHOW
    
    static let redBits: Int32 = GLFW_RED_BITS
    static let greenBits: Int32 = GLFW_GREEN_BITS
    static let blueBits: Int32 = GLFW_BLUE_BITS
    static let alphaBits: Int32 = GLFW_ALPHA_BITS
    static let depthBits: Int32 = GLFW_DEPTH_BITS
    static let stencilBits: Int32 = GLFW_STENCIL_BITS
    
    static let auxillaryBuffer: Int32 = GLFW_AUX_BUFFERS
    static let stereoRendering: Int32 = GLFW_STEREO
    static let msaaSamples: Int32 = GLFW_SAMPLES
    static let srgbCapable: Int32 = GLFW_SRGB_CAPABLE
    static let monitorRefreshRate: Int32 = GLFW_REFRESH_RATE
    static let doubleBuffer: Int32 = GLFW_DOUBLEBUFFER
    
    static let clientAPI: Int32 = GLFW_CLIENT_API
    static let contextVersionMajor: Int32 = GLFW_CONTEXT_VERSION_MAJOR
    static let contextVersionMinor: Int32 = GLFW_CONTEXT_VERSION_MINOR
    static let contextRevision: Int32 = GLFW_CONTEXT_REVISION
    
    static let contextRobustness: Int32 = GLFW_CONTEXT_ROBUSTNESS
    static let openglForwardCompatibility: Int32 = GLFW_OPENGL_FORWARD_COMPAT
    static let openglDebugContext: Int32 = GLFW_OPENGL_DEBUG_CONTEXT
    static let openglProfile: Int32 = GLFW_OPENGL_PROFILE
    static let contextReleaseBehavior: Int32 = GLFW_CONTEXT_RELEASE_BEHAVIOR
    static let contextSuppressErrors: Int32 = GLFW_CONTEXT_NO_ERROR
    static let contextCreationAPI: Int32 = GLFW_CONTEXT_CREATION_API
    static let scaleToMonitor: Int32 = GLFW_SCALE_TO_MONITOR
    
    static let cocoaRetinaFramebuffer: Int32 = GLFW_COCOA_RETINA_FRAMEBUFFER
    static let cocoaFrameName: Int32 = GLFW_COCOA_FRAME_NAME
    static let cocoaGraphicsSwitching: Int32 = GLFW_COCOA_GRAPHICS_SWITCHING
    
    static let x11ClassName: Int32 = GLFW_X11_CLASS_NAME
    static let x11InstanceName: Int32 = GLFW_X11_INSTANCE_NAME
    
    static let noAPI: Int32 = GLFW_NO_API
    static let openglAPI: Int32 = GLFW_OPENGL_API
    static let embeddedAPI: Int32 = GLFW_OPENGL_ES_API
    
    static let noRobustness: Int32 = GLFW_NO_ROBUSTNESS
    static let noResetNotification: Int32 = GLFW_NO_RESET_NOTIFICATION
    static let loseContextOnReset: Int32 = GLFW_LOSE_CONTEXT_ON_RESET
    
    static let openglAnyProfile: Int32 = GLFW_OPENGL_ANY_PROFILE
    static let openglCoreProfile: Int32 = GLFW_OPENGL_CORE_PROFILE
    static let openglCompatProfile: Int32 = GLFW_OPENGL_COMPAT_PROFILE
    
    static let cursor: Int32 = GLFW_CURSOR
    static let stickyKeys: Int32 = GLFW_STICKY_KEYS
    static let stickyMouseButtons: Int32 = GLFW_STICKY_MOUSE_BUTTONS
    static let lockKeyMods: Int32 = GLFW_LOCK_KEY_MODS
    static let rawMouseMotion: Int32 = GLFW_RAW_MOUSE_MOTION
    
    static let cursorNormal: Int32 = GLFW_CURSOR_NORMAL
    static let cursorHidden: Int32 = GLFW_CURSOR_HIDDEN
    static let cursorDisabled: Int32 = GLFW_CURSOR_DISABLED
    
    static let anyReleaseBehavior: Int32 = GLFW_ANY_RELEASE_BEHAVIOR
    static let releaseBehaviorFlush: Int32 = GLFW_RELEASE_BEHAVIOR_FLUSH
    static let releaseBehaviorNone: Int32 = GLFW_RELEASE_BEHAVIOR_NONE
    
    static let nativeContextAPI: Int32 = GLFW_NATIVE_CONTEXT_API
    static let eglContextAPI: Int32 = GLFW_EGL_CONTEXT_API
    static let osMesaContextAPI: Int32 = GLFW_OSMESA_CONTEXT_API
    
    static let arrowCursor: Int32 = GLFW_ARROW_CURSOR
    static let iBeamCursor: Int32 = GLFW_IBEAM_CURSOR
    static let crosshairCursor: Int32 = GLFW_CROSSHAIR_CURSOR
    static let handCursor: Int32 = GLFW_HAND_CURSOR
    static let horizontalResizeCursor: Int32 = GLFW_HRESIZE_CURSOR
    static let verticalResizeCursor: Int32 = GLFW_VRESIZE_CURSOR
    
    static let connected: Int32 = GLFW_CONNECTED
    static let disconnected: Int32 = GLFW_DISCONNECTED
    
    static let joystickHatButtons: Int32 = GLFW_JOYSTICK_HAT_BUTTONS
    
    static let cocoaChDirResources: Int32 = GLFW_COCOA_CHDIR_RESOURCES
    static let cocoaMenuBar: Int32 = GLFW_COCOA_MENUBAR
    
    static let dontCare: Int32 = GLFW_DONT_CARE
}
