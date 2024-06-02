import CGLFW3

@MainActor
public final class GLFWWindow: GLFWObject {
    public let pointer: OpaquePointer?
    
    public static var hints = Hints()
    
    public var positionChangeHandler: ((GLFWWindow, Int, Int) -> Void)?
    public var sizeChangeHandler: ((GLFWWindow, Int, Int) -> Void)?
    
    public var shouldCloseHandler: ((GLFWWindow) -> Void)?
    public var refreshHandler: ((GLFWWindow) -> Void)?
    public var receiveFocusHandler: ((GLFWWindow) -> Void)?
    public var loseFocusHandler: ((GLFWWindow) -> Void)?
    public var minimizeHandler: ((GLFWWindow) -> Void)?
    public var maximizeHandler: ((GLFWWindow) -> Void)?
    public var restoreHandler: ((GLFWWindow) -> Void)?
    public var framebufferSizeChangeHandler: ((GLFWWindow, Int, Int) -> Void)?
    public var contentScaleChangeHandler: ((GLFWWindow, Double, Double) -> Void)?
    public var keyInputHandler: ((GLFWWindow, Keyboard.Key, Int, ButtonState, Keyboard.Modifier) -> Void)?
    public var textInputHandler: ((GLFWWindow, String) -> Void)?
    
    public var cursorEnterHandler: ((GLFWWindow) -> Void)?
    public var cursorExitHandler: ((GLFWWindow) -> Void)?
    public var mouseButtonHandler: ((GLFWWindow, Mouse.Button, ButtonState, Keyboard.Modifier) -> Void)?
    public var scrollInputHandler: ((GLFWWindow, Double, Double) -> Void)?
    
    public var dragAndDropHandler: ((GLFWWindow, [String]) -> Void)?
    
    @WindowAttribute(.iconified)
    public private(set) var minimized: Bool
    
    @WindowAttribute(.maximized)
    public private(set) var maximized: Bool
    
    public var fullscreenMonitor: GLFWMonitor? {
        guard let monitor = glfwGetWindowMonitor(pointer) else { return nil }
        let opaque = OpaquePointer(glfwGetMonitorUserPointer(monitor))
        return GLFWMonitor.fromOpaque(opaque)
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
    
    public func show() {
        glfwShowWindow(pointer)
    }
    
    public func restore() {
        glfwRestoreWindow(pointer)
    }
    
    public func makeFullscreen(monitor: GLFWMonitor, size: Size, refreshRate: Int? = nil) {
        glfwSetWindowMonitor(pointer, monitor.pointer, .zero, .zero, Int32(size.width), Int32(size.height), refreshRate?.int32 ?? .dontCare)
    }
    
    public func makeFullscreen(monitor: GLFWMonitor) {
        makeFullscreen(monitor: monitor, size: monitor.workArea.size)
    }
    
    public func makeFullscreen() {
        makeFullscreen(monitor: .primary)
    }
    
    public func exitFullscreen(withFrame newFrame: Frame) {
        glfwSetWindowPos(pointer, Int32(newFrame.x), Int32(newFrame.y))
        glfwSetWindowSize(pointer, Int32(newFrame.width), Int32(newFrame.height))
    }
    
    nonisolated public var shouldClose: Bool {
        get { Bool(glfwWindowShouldClose(pointer)) }
        set { glfwSetWindowShouldClose(pointer, newValue.int32) }
    }
    
    nonisolated public func close() {
        shouldClose = true
    }
    
    public var title: String? {
        get { glfwGetWindowTitle(pointer).map(String.init(cString:)) }
        set { glfwSetWindowTitle(pointer, newValue) }
    }
    
    @WindowAttribute(.resizable)
    public var canBeResized: Bool
    
    public var opacity: Float {
        get { glfwGetWindowOpacity(pointer) }
        set { glfwSetWindowOpacity(pointer, newValue) }
    }
    
    @WindowAttribute(.visible)
    public private(set) var visible: Bool
    
    @WindowAttribute(.decorated)
    public var isDecorated: Bool
    
    @WindowAttribute(.floating)
    public var isFloating: Bool
    
    @WindowAttribute(.autoIconify)
    public var autoMinimizeInFullscreen: Bool
    
    @WindowAttribute(.focusOnShow)
    public var focusOnShow: Bool
    
    @WindowAttribute(.focused)
    public private(set) var isFocused: Bool
    
    public func focus(force: Bool = false) {
        force ? glfwFocusWindow(pointer) : glfwRequestWindowAttention(pointer)
    }
    
    @WindowAttribute(.hovered)
    public private(set) var isUnderCursor: Bool
    
    @WindowAttribute(.transparentFramebuffer)
    public private(set) var framebufferIsTransparent: Bool
    
    nonisolated public func swapBuffers() {
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
    
    public var margins: Margins {
        var left = Int32.zero, right = Int32.zero, top = Int32.zero, bottom = Int32.zero
        glfwGetWindowFrameSize(pointer, &left, &top, &right, &bottom)
        return Margins(left: Int(left), right: Int(right), top: Int(top), bottom: Int(bottom))
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
    
    init(_ pointer: OpaquePointer!) {
        self.pointer = pointer
        glfwSetWindowUserPointer(pointer, Unmanaged.passUnretained(self).toOpaque())
        
        glfwSetWindowPosCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.positionChangeHandler?(window, $1.int, $2.int)
        }
        glfwSetWindowSizeCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.sizeChangeHandler?(window, $1.int, $2.int)
        }
        glfwSetWindowCloseCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.shouldCloseHandler?(window)
        }
        glfwSetWindowRefreshCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.refreshHandler?(window)
        }
        glfwSetWindowFocusCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            Bool($1) ? window.receiveFocusHandler?(window) : window.loseFocusHandler?(window)
        }
        glfwSetWindowIconifyCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            Bool($1) ? window.minimizeHandler?(window) : window.restoreHandler?(window)
        }
        glfwSetWindowMaximizeCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            Bool($1) ? window.maximizeHandler?(window) : window.restoreHandler?(window)
        }
        glfwSetFramebufferSizeCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.framebufferSizeChangeHandler?(window, $1.int, $2.int)
        }
        glfwSetWindowContentScaleCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.contentScaleChangeHandler?(window, Double($1), Double($2))
        }
        glfwSetKeyCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.keyInputHandler?(window, Keyboard.Key($1), $2.int, ButtonState($3), Keyboard.Modifier(rawValue: $4))
        }
        glfwSetCharCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            guard let scalar = UnicodeScalar($1) else { return }
            window.textInputHandler?(window, String(scalar))
        }
        glfwSetCursorEnterCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            Bool($1) ? window.cursorEnterHandler?(window) : window.cursorExitHandler?(window)
        }
        glfwSetMouseButtonCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.mouseButtonHandler?(window, Mouse.Button(rawValue: $1) ?? .left, ButtonState($2), Keyboard.Modifier(rawValue: $3))
        }
        glfwSetScrollCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.scrollInputHandler?(window, $1, $2)
        }
        glfwSetDropCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            let cStringArray = Array(UnsafeBufferPointer(start: $2, count: $1.int))
            let array = cStringArray.compactMap({$0}).map(String.init(cString:))
            window.dragAndDropHandler?(window, array)
        }
    }
    
    deinit {
        glfwSetWindowUserPointer(pointer, nil)
        glfwDestroyWindow(pointer)
        glfwDestroyCursor(cursorPtr)
    }
    
    public convenience init(width: Int, height: Int, title: String, monitor: GLFWMonitor? = nil, sharedContext context: GLFWContext? = nil) throws {
        let pointer = glfwCreateWindow(width.int32, height.int32, title, monitor?.pointer, context?.pointer)
        try GLFWSession.checkForError()
        self.init(pointer)
    }
    
    static func fromOpaque(_ pointer: OpaquePointer!) -> GLFWWindow {
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
    var cursor: Mouse.Cursor = .default {
        didSet {
            cursorPtr = cursor.create()
        }
    }
}
