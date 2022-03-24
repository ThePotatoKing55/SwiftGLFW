import CGLFW3

extension Int32 {
    static let `true` = GLFW_TRUE
    static let `false` = GLFW_FALSE
    
    static let focused = GLFW_FOCUSED
    static let iconified = GLFW_ICONIFIED
    static let resizable = GLFW_RESIZABLE
    static let visible = GLFW_VISIBLE
    static let decorated = GLFW_DECORATED
    static let autoIconify = GLFW_AUTO_ICONIFY
    static let floating = GLFW_FLOATING
    static let maximized = GLFW_MAXIMIZED
    static let centerCursor = GLFW_CENTER_CURSOR
    static let transparentFramebuffer = GLFW_TRANSPARENT_FRAMEBUFFER
    static let hovered = GLFW_HOVERED
    static let focusOnShow = GLFW_FOCUS_ON_SHOW
    
    static let redBits = GLFW_RED_BITS
    static let greenBits = GLFW_GREEN_BITS
    static let blueBits = GLFW_BLUE_BITS
    static let alphaBits = GLFW_ALPHA_BITS
    static let depthBits = GLFW_DEPTH_BITS
    static let stencilBits = GLFW_STENCIL_BITS
    
    static let auxillaryBuffer = GLFW_AUX_BUFFERS
    static let stereoRendering = GLFW_STEREO
    static let msaaSamples = GLFW_SAMPLES
    static let srgbCapable = GLFW_SRGB_CAPABLE
    static let monitorRefreshRate = GLFW_REFRESH_RATE
    static let doubleBuffer = GLFW_DOUBLEBUFFER
    
    static let clientAPI = GLFW_CLIENT_API
    static let contextVersionMajor = GLFW_CONTEXT_VERSION_MAJOR
    static let contextVersionMinor = GLFW_CONTEXT_VERSION_MINOR
    static let contextRevision = GLFW_CONTEXT_REVISION
    
    static let contextRobustness = GLFW_CONTEXT_ROBUSTNESS
    static let openglForwardCompatibility = GLFW_OPENGL_FORWARD_COMPAT
    static let openglDebugContext = GLFW_OPENGL_DEBUG_CONTEXT
    static let openglProfile = GLFW_OPENGL_PROFILE
    static let contextReleaseBehavior = GLFW_CONTEXT_RELEASE_BEHAVIOR
    static let contextSuppressErrors = GLFW_CONTEXT_NO_ERROR
    static let contextCreationAPI = GLFW_CONTEXT_CREATION_API
    static let scaleToMonitor = GLFW_SCALE_TO_MONITOR
    
    static let cocoaRetinaFramebuffer = GLFW_COCOA_RETINA_FRAMEBUFFER
    static let cocoaFrameName = GLFW_COCOA_FRAME_NAME
    static let cocoaGraphicsSwitching = GLFW_COCOA_GRAPHICS_SWITCHING
    
    static let x11ClassName = GLFW_X11_CLASS_NAME
    static let x11InstanceName = GLFW_X11_INSTANCE_NAME
    
    static let noAPI = GLFW_NO_API
    static let openglAPI = GLFW_OPENGL_API
    static let embeddedAPI = GLFW_OPENGL_ES_API
    
    static let noRobustness = GLFW_NO_ROBUSTNESS
    static let noResetNotification = GLFW_NO_RESET_NOTIFICATION
    static let loseContextOnReset = GLFW_LOSE_CONTEXT_ON_RESET
    
    static let openglAnyProfile = GLFW_OPENGL_ANY_PROFILE
    static let openglCoreProfile = GLFW_OPENGL_CORE_PROFILE
    static let openglCompatProfile = GLFW_OPENGL_COMPAT_PROFILE
    
    static let cursor = GLFW_CURSOR
    static let stickyKeys = GLFW_STICKY_KEYS
    static let stickyMouseButtons = GLFW_STICKY_MOUSE_BUTTONS
    static let lockKeyMods = GLFW_LOCK_KEY_MODS
    static let rawMouseMotion = GLFW_RAW_MOUSE_MOTION
    
    static let cursorNormal = GLFW_CURSOR_NORMAL
    static let cursorHidden = GLFW_CURSOR_HIDDEN
    static let cursorDisabled = GLFW_CURSOR_DISABLED
    
    static let anyReleaseBehavior = GLFW_ANY_RELEASE_BEHAVIOR
    static let releaseBehaviorFlush = GLFW_RELEASE_BEHAVIOR_FLUSH
    static let releaseBehaviorNone = GLFW_RELEASE_BEHAVIOR_NONE
    
    static let nativeContextAPI = GLFW_NATIVE_CONTEXT_API
    static let eglContextAPI = GLFW_EGL_CONTEXT_API
    static let osMesaContextAPI = GLFW_OSMESA_CONTEXT_API
    
    static let arrowCursor = GLFW_ARROW_CURSOR
    static let iBeamCursor = GLFW_IBEAM_CURSOR
    static let crosshairCursor = GLFW_CROSSHAIR_CURSOR
    static let handCursor = GLFW_HAND_CURSOR
    static let horizontalResizeCursor = GLFW_RESIZE_EW_CURSOR
    static let verticalResizeCursor = GLFW_RESIZE_NS_CURSOR
    static let resizeNWSECursor = GLFW_RESIZE_NWSE_CURSOR
    static let resizeNESWCursor = GLFW_RESIZE_NESW_CURSOR
    static let resizeAllCursor = GLFW_RESIZE_ALL_CURSOR
    static let notAllowedCursor = GLFW_NOT_ALLOWED_CURSOR
    
    static let connected = GLFW_CONNECTED
    static let disconnected = GLFW_DISCONNECTED
    
    static let gamepad1 = GLFW_JOYSTICK_1
    static let gamepad2 = GLFW_JOYSTICK_2
    static let gamepad3 = GLFW_JOYSTICK_3
    static let gamepad4 = GLFW_JOYSTICK_4
    static let gamepad5 = GLFW_JOYSTICK_5
    static let gamepad6 = GLFW_JOYSTICK_6
    static let gamepad7 = GLFW_JOYSTICK_7
    static let gamepad8 = GLFW_JOYSTICK_8
    static let gamepad9 = GLFW_JOYSTICK_9
    static let gamepad10 = GLFW_JOYSTICK_10
    static let gamepad11 = GLFW_JOYSTICK_11
    static let gamepad12 = GLFW_JOYSTICK_12
    static let gamepad13 = GLFW_JOYSTICK_13
    static let gamepad14 = GLFW_JOYSTICK_14
    static let gamepad15 = GLFW_JOYSTICK_15
    static let gamepad16 = GLFW_JOYSTICK_16
    
    static let joystickHatButtons = GLFW_JOYSTICK_HAT_BUTTONS
    
    static let cocoaChDirResources = GLFW_COCOA_CHDIR_RESOURCES
    static let cocoaMenuBar = GLFW_COCOA_MENUBAR
    
    static let dontCare = GLFW_DONT_CARE
}
