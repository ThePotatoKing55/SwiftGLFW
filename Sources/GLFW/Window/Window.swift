import CGLFW3

public final class GLFWWindow: GLFWObject {
    internal(set) public var pointer: OpaquePointer?
    
    public static var hints = Hints()
    
    public var frameChangeHandler: ((DiscreteFrame) -> Void)?
    public var shouldCloseHandler: (() -> Bool)?
    public var refreshHandler: (() -> Void)?
    public var receiveFocusHandler: (() -> Void)?
    public var loseFocusHandler: (() -> Void)?
    public var minimizeHandler: (() -> Void)?
    public var maximizeHandler: (() -> Void)?
    public var restoreHandler: (() -> Void)?
    public var framebufferSizeChangeHandler: ((DiscreteSize) -> Void)?
    public var contentScaleChangeHandler: ((ContentScale) -> Void)?
    public var keyInputHandler: ((Keyboard.Key, Int, Keyboard.Key.State, Keyboard.Modifier) -> Void)?
    public var textInputHandler: ((String) -> Void)?
    
    public var cursorEnterHandler: (() -> Void)?
    public var cursorExitHandler: (() -> Void)?
    public var mouseButtonHandler: ((Mouse.Button, Mouse.Button.State, Keyboard.Modifier) -> Void)?
    public var scrollInputHandler: ((Point) -> Void)?
    
    public var dragAndDropHandler: (([String]) -> Void)?
    
    public enum WindowMode {
        case minimized, maximized, fullscreen(Monitor), windowed
    }
    
    public var windowMode: WindowMode {
        if let monitor = glfwGetWindowMonitor(pointer) {
            let opaque = OpaquePointer(glfwGetMonitorUserPointer(monitor))
            return .fullscreen(Monitor.fromOpaque(opaque))
        } else if attributes[Constant.iconified].bool {
            return .minimized
        } else if attributes[Constant.maximized].bool {
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
    
    public func restore() {
        glfwRestoreWindow(pointer)
    }
    
    public func makeFullscreen(monitor: Monitor, size: DiscreteSize, refreshRate: Int? = nil) {
        glfwSetWindowMonitor(pointer, monitor.pointer, .zero, .zero, size.width.int32, size.height.int32, refreshRate?.int32 ?? Constant.dontCare)
    }
    
    public func makeFullscreen(monitor: Monitor = .primary) {
        makeFullscreen(monitor: monitor, size: monitor.workArea.size)
    }
    
    public func exitFullscreen(withFrame newFrame: DiscreteFrame) {
        glfwSetWindowPos(pointer, newFrame.x.int32, newFrame.x.int32)
        glfwSetWindowSize(pointer, newFrame.width.int32, newFrame.height.int32)
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
        get { attributes[Constant.resizable].bool }
        set { attributes[Constant.resizable] = newValue.int32 }
    }
    
    public var opacity: Float {
        get { glfwGetWindowOpacity(pointer) }
        set { glfwSetWindowOpacity(pointer, newValue) }
    }
    
    public var isVisible: Bool {
        attributes[Constant.visible].bool
    }
    
    public var isDecorated: Bool {
        get { attributes[Constant.decorated].bool }
        set { attributes[Constant.decorated] = newValue.int32 }
    }
    
    public var isFloating: Bool {
        get { attributes[Constant.floating].bool }
        set { attributes[Constant.floating] = newValue.int32 }
    }
    
    public var minimizeOnLoseFocus: Bool {
        get { attributes[Constant.autoIconify].bool }
        set { attributes[Constant.autoIconify] = newValue.int32 }
    }
    
    public var focusWhenShown: Bool {
        get { attributes[Constant.focusOnShow].bool }
        set { attributes[Constant.focusOnShow] = newValue.int32 }
    }
    
    public var isInFocus: Bool {
        attributes[Constant.focused].bool
    }
    
    public func focus(force: Bool = false) {
        force ? glfwFocusWindow(pointer) : glfwRequestWindowAttention(pointer)
    }
    
    public var isUnderCursor: Bool {
        attributes[Constant.hovered].bool
    }
    
    public var transparentFramebuffer: Bool {
        attributes[Constant.transparentFramebuffer].bool
    }
    
    public func swapBuffers() {
        glfwSwapBuffers(pointer)
    }
    
    public var frame: DiscreteFrame {
        get {
            var xpos = Int32.zero, ypos = Int32.zero, width = Int32.zero, height = Int32.zero
            glfwGetWindowPos(pointer, &xpos, &ypos)
            glfwGetWindowSize(pointer, &width, &height)
            return DiscreteFrame(x: xpos.int, y: ypos.int, width: width.int, height: height.int)
        }
        set {
            if newValue.origin != frame.origin {
                glfwSetWindowPos(pointer, newValue.x.int32, newValue.y.int32)
            }
            if newValue.size != frame.size {
                glfwSetWindowSize(pointer, newValue.width.int32, newValue.height.int32)
            }
        }
    }
    
    public func setSizeLimits(minWidth: Int?, minHeight: Int?, maxWidth: Int?, maxHeight: Int?) {
        let minWidth = minWidth?.int32 ?? Constant.dontCare
        let minHeight = minHeight?.int32 ?? Constant.dontCare
        let maxWidth = maxWidth?.int32 ?? Constant.dontCare
        let maxHeight = maxHeight?.int32 ?? Constant.dontCare
        glfwSetWindowSizeLimits(pointer, minWidth, minHeight, maxWidth, maxHeight)
    }
    
    public func setSizeLimits(min: DiscreteSize?, max: DiscreteSize?) {
        setSizeLimits(minWidth: min?.width, minHeight: min?.height, maxWidth: max?.width, maxHeight: max?.height)
    }
    
    public func setAspectRatio(_ numerator: Int, _ denominator: Int) {
        glfwSetWindowAspectRatio(pointer, numerator.int32, denominator.int32)
    }
    
    public func lockAspectRatio() {
        setAspectRatio(frame.size.width, frame.size.height)
    }
    
    public func resetAspectRatio() {
        glfwSetWindowAspectRatio(pointer, Constant.dontCare, Constant.dontCare)
    }
    
    public var framebufferSize: DiscreteSize {
        var width = Int32.zero, height = Int32.zero
        glfwGetFramebufferSize(pointer, &width, &height)
        return DiscreteSize(width: width.int, height: height.int)
    }
    
    public var contentScale: ContentScale {
        var xscale = Float.zero, yscale = Float.zero
        glfwGetWindowContentScale(pointer, &xscale, &yscale)
        return ContentScale(x: Double(xscale), y: Double(yscale))
    }
    
    private func positionChanged(to pos: DiscretePoint) {
        var width = Int32.zero, height = Int32.zero
        glfwGetWindowSize(pointer, &width, &height)
        let size = DiscreteSize(width: width.int, height: height.int)
        let origin = DiscretePoint(x: pos.x.int, y: pos.y.int)
        frameChangeHandler?(DiscreteFrame(origin: origin, size: size))
    }
    
    private func sizeChanged(to size: DiscreteSize) {
        var xpos = Int32.zero, ypos = Int32.zero
        glfwGetWindowPos(pointer, &xpos, &ypos)
        let origin = DiscretePoint(x: xpos.int, y: ypos.int)
        let size = DiscreteSize(width: size.width.int, height: size.height.int)
        frameChangeHandler?(DiscreteFrame(origin: origin, size: size))
    }
    
    internal init(_ pointer: OpaquePointer!) {
        self.pointer = pointer
        glfwSetWindowUserPointer(pointer, Unmanaged.passUnretained(self).toOpaque())
        
        glfwSetWindowPosCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.positionChanged(to: DiscretePoint(x: $1.int, y: $2.int))
        }
        glfwSetWindowSizeCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.sizeChanged(to: DiscreteSize(width: $1.int, height: $2.int))
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
            window.framebufferSizeChangeHandler?(DiscreteSize(width: Int($1), height: Int($2)))
        }
        glfwSetWindowContentScaleCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.contentScaleChangeHandler?(ContentScale(x: Double($1), y: Double($2)))
        }
        glfwSetKeyCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.keyInputHandler?(Keyboard.Key($1), $2.int, Keyboard.Key.State(Int($3)), Keyboard.Modifier(rawValue: $4))
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
            window.mouseButtonHandler?(Mouse.Button(rawValue: $1) ?? .left, Mouse.Button.State(rawValue: $2) ?? .released, Keyboard.Modifier(rawValue: $3))
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
    }
    
    public convenience init(width: Int, height: Int, title: String = "Window", fullscreenMonitor monitor: Monitor? = nil, sharedContext context: GLFWContext? = nil) throws {
        let pointer = glfwCreateWindow(width.int32, height.int32, title, monitor?.pointer, context?.pointer)
        try GLFWSession.checkError()
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
}
