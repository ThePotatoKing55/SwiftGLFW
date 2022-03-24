import CGLFW3

public final class GLFWWindow: GLFWObject {
    internal(set) public var pointer: OpaquePointer?
    
    public static var hints = Hints()
    
    public var positionChangeHandler: ((Point) -> Void)?
    public var sizeChangeHandler: ((Size) -> Void)?
    
    @available(*, unavailable, message: "Replaced with positionChangeHandler and sizeChangeHandler")
    public var frameChangeHandler: ((Frame) -> Void)?
    
    public var shouldCloseHandler: (() -> Bool)?
    public var refreshHandler: (() -> Void)?
    public var receiveFocusHandler: (() -> Void)?
    public var loseFocusHandler: (() -> Void)?
    public var minimizeHandler: (() -> Void)?
    public var maximizeHandler: (() -> Void)?
    public var restoreHandler: (() -> Void)?
    public var framebufferSizeChangeHandler: ((Size) -> Void)?
    public var contentScaleChangeHandler: ((ContentScale) -> Void)?
    public var keyInputHandler: ((Keyboard.Key, Int, ButtonState, Keyboard.Modifier) -> Void)?
    public var textInputHandler: ((String) -> Void)?
    
    public var cursorEnterHandler: (() -> Void)?
    public var cursorExitHandler: (() -> Void)?
    public var mouseButtonHandler: ((Mouse.Button, ButtonState, Keyboard.Modifier) -> Void)?
    public var scrollInputHandler: ((Point) -> Void)?
    
    public var dragAndDropHandler: (([String]) -> Void)?
    
    public enum WindowMode {
        case minimized, maximized, fullscreen(GLFWMonitor), windowed
    }
    
    public var windowMode: WindowMode {
        if let monitor = glfwGetWindowMonitor(pointer) {
            let opaque = OpaquePointer(glfwGetMonitorUserPointer(monitor))
            return .fullscreen(GLFWMonitor.fromOpaque(opaque))
        } else if attributes[.iconified].bool {
            return .minimized
        } else if attributes[.maximized].bool {
            return .maximized
        } else {
            return .windowed
        }
    }
    
    public func minimize() {
        glfwIconifyWindow(pointer)
    }
    
    public func maximize() {
        glfwMaximizeWindow(pointer)
    }
    
    public func hide() {
        glfwHideWindow(pointer)
    }
    
    public func restore() {
        glfwRestoreWindow(pointer)
    }
    
    public func makeFullscreen(monitor: GLFWMonitor, size: Size, refreshRate: Int? = nil) {
        glfwSetWindowMonitor(pointer, monitor.pointer, .zero, .zero, Int32(size.width), Int32(size.height), refreshRate?.int32 ?? .dontCare)
    }
    
    public func makeFullscreen(monitor: GLFWMonitor = .primary) {
        makeFullscreen(monitor: monitor, size: monitor.workArea.size)
    }
    
    public func exitFullscreen(withFrame newFrame: Frame) {
        glfwSetWindowPos(pointer, Int32(newFrame.x), Int32(newFrame.y))
        glfwSetWindowSize(pointer, Int32(newFrame.width), Int32(newFrame.height))
    }
    
    public var shouldClose: Bool {
        glfwWindowShouldClose(pointer).bool
    }
    
    public func close() {
        setShouldClose(to: true)
    }
    
    private func setShouldClose(to shouldClose: Bool) {
        glfwSetWindowShouldClose(pointer, shouldClose.int32)
    }
    
    internal struct AttributeManager {
        var pointer: OpaquePointer!
        init(_ pointer: OpaquePointer!) { self.pointer = pointer }
        subscript(attribute: Int32) -> Int32 {
            get { glfwGetWindowAttrib(pointer, attribute) }
            set { glfwSetWindowAttrib(pointer, attribute, newValue) }
        }
    }
    
    private lazy var attributes: AttributeManager = AttributeManager(pointer)
    
    public var title: String = "Window" {
        didSet {
            glfwSetWindowTitle(pointer, title)
        }
    }
    
    public var canBeResized: Bool {
        get { attributes[.resizable].bool }
        set { attributes[.resizable] = newValue.int32 }
    }
    
    public var opacity: Float {
        get { glfwGetWindowOpacity(pointer) }
        set { glfwSetWindowOpacity(pointer, newValue) }
    }
    
    public var isVisible: Bool {
        attributes[.visible].bool
    }
    
    public var isDecorated: Bool {
        get { attributes[.decorated].bool }
        set { attributes[.decorated] = newValue.int32 }
    }
    
    public var isFloating: Bool {
        get { attributes[.floating].bool }
        set { attributes[.floating] = newValue.int32 }
    }
    
    public var minimizeOnLoseFocus: Bool {
        get { attributes[.autoIconify].bool }
        set { attributes[.autoIconify] = newValue.int32 }
    }
    
    public var focusWhenShown: Bool {
        get { attributes[.focusOnShow].bool }
        set { attributes[.focusOnShow] = newValue.int32 }
    }
    
    public var isInFocus: Bool {
        attributes[.focused].bool
    }
    
    public func focus(force: Bool = false) {
        force ? glfwFocusWindow(pointer) : glfwRequestWindowAttention(pointer)
    }
    
    public var isUnderCursor: Bool {
        attributes[.hovered].bool
    }
    
    public var transparentFramebuffer: Bool {
        attributes[.transparentFramebuffer].bool
    }
    
    public func swapBuffers() {
        glfwSwapBuffers(pointer)
    }
    
    public var position: Point {
        get {
            var xpos = Int32.zero, ypos = Int32.zero
            glfwGetWindowPos(pointer, &xpos, &ypos)
            return Point(xpos.int, ypos.int)
        }
        set {
            glfwSetWindowPos(pointer, Int32(newValue.x), Int32(newValue.y))
        }
    }
    
    public var size: Size {
        get {
            var width = Int32.zero, height = Int32.zero
            glfwGetWindowSize(pointer, &width, &height)
            return Size(width.int, height.int)
        }
        set {
            glfwSetWindowSize(pointer, Int32(newValue.width), Int32(newValue.height))
        }
    }
    
    public func setSizeLimits(minWidth: Int?, minHeight: Int?, maxWidth: Int?, maxHeight: Int?) {
        let minWidth = minWidth?.int32 ?? .dontCare
        let minHeight = minHeight?.int32 ?? .dontCare
        let maxWidth = maxWidth?.int32 ?? .dontCare
        let maxHeight = maxHeight?.int32 ?? .dontCare
        glfwSetWindowSizeLimits(pointer, minWidth, minHeight, maxWidth, maxHeight)
    }
    
    public func setSizeLimits(minWidth: Double?, minHeight: Double?, maxWidth: Double?, maxHeight: Double?) {
        setSizeLimits(minWidth: minWidth.map(Int.init), minHeight: minHeight.map(Int.init), maxWidth: maxWidth.map(Int.init), maxHeight: maxHeight.map(Int.init))
    }
    
    public func setSizeLimits(min: Size?, max: Size?) {
        setSizeLimits(minWidth: min?.width, minHeight: min?.height, maxWidth: max?.width, maxHeight: max?.height)
    }
    
    public func setAspectRatio(_ numerator: Int, _ denominator: Int) {
        glfwSetWindowAspectRatio(pointer, numerator.int32, denominator.int32)
    }
    
    public func setAspectRatio(_ numerator: Double, _ denominator: Double) {
        setAspectRatio(Int(numerator), Int(denominator))
    }
    
    public func lockAspectRatio() {
        setAspectRatio(size.width, size.height)
    }
    
    public func resetAspectRatio() {
        glfwSetWindowAspectRatio(pointer, .dontCare, .dontCare)
    }
    
    public var framebufferSize: Size {
        var width = Int32.zero, height = Int32.zero
        glfwGetFramebufferSize(pointer, &width, &height)
        return Size(width.int, height.int)
    }
    
    public var contentScale: ContentScale {
        var xscale = Float.zero, yscale = Float.zero
        glfwGetWindowContentScale(pointer, &xscale, &yscale)
        return ContentScale(x: Double(xscale), y: Double(yscale))
    }
    
    internal init(_ pointer: OpaquePointer!) {
        self.pointer = pointer
        glfwSetWindowUserPointer(pointer, Unmanaged.passUnretained(self).toOpaque())
        
        glfwSetWindowPosCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.positionChangeHandler?(Point($1.int, $2.int))
        }
        glfwSetWindowSizeCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.sizeChangeHandler?(Size($1.int, $2.int))
        }
        glfwSetWindowCloseCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            if window.shouldCloseHandler?() == false { window.setShouldClose(to: false) }
        }
        glfwSetWindowRefreshCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.refreshHandler?()
        }
        glfwSetWindowFocusCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            $1 != false ? window.receiveFocusHandler?() : window.loseFocusHandler?()
        }
        glfwSetWindowIconifyCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            $1 != false ? window.minimizeHandler?() : window.restoreHandler?()
        }
        glfwSetWindowMaximizeCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            $1 != false ? window.maximizeHandler?() : window.restoreHandler?()
        }
        glfwSetFramebufferSizeCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.framebufferSizeChangeHandler?(Size(width: Int($1), height: Int($2)))
        }
        glfwSetWindowContentScaleCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.contentScaleChangeHandler?(ContentScale(x: Double($1), y: Double($2)))
        }
        glfwSetKeyCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.keyInputHandler?(Keyboard.Key($1), $2.int, ButtonState($3), Keyboard.Modifier(rawValue: $4))
        }
        glfwSetCharCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            guard let scalar = UnicodeScalar($1) else { return }
            window.textInputHandler?(String(scalar))
        }
        glfwSetCursorEnterCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            $1.bool ? window.cursorEnterHandler?() : window.cursorExitHandler?()
        }
        glfwSetMouseButtonCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.mouseButtonHandler?(Mouse.Button(rawValue: $1) ?? .left, ButtonState($2), Keyboard.Modifier(rawValue: $3))
        }
        glfwSetScrollCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.scrollInputHandler?(Point(x: $1, y: $2))
        }
        glfwSetDropCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            let cStringArray = Array(UnsafeBufferPointer(start: $2, count: $1.int))
            let array = cStringArray.compactMap({$0}).map(String.init(cString:))
            window.dragAndDropHandler?(array)
        }
    }
    
    deinit {
        glfwSetWindowUserPointer(pointer, nil)
        glfwDestroyWindow(pointer)
        glfwDestroyCursor(cursorPtr)
    }
    
    public convenience init(width: Int, height: Int, title: String = "Window", monitor: GLFWMonitor? = nil, sharedContext context: GLFWContext? = nil) throws {
        let pointer = glfwCreateWindow(width.int32, height.int32, title, monitor?.pointer, context?.pointer)
        try GLFWSession.checkForError()
        self.init(pointer)
        self.title = title
    }
    
    internal static func fromOpaque(_ pointer: OpaquePointer!) -> GLFWWindow {
        precondition(pointer != nil, "Attempted to create window from nil pointer")
        if let opaque = glfwGetWindowUserPointer(pointer) {
            return Unmanaged.fromOpaque(opaque).takeUnretainedValue()
        } else {
            return GLFWWindow(pointer)
        }
    }
    
    private var cursorPtr: OpaquePointer? {
        didSet {
            glfwSetCursor(pointer, cursorPtr)
            glfwDestroyCursor(oldValue)
        }
    }
    internal var cursor: Mouse.Cursor = .default {
        didSet {
            cursorPtr = cursor.create()
        }
    }
}
