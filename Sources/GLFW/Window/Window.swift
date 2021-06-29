import CGLFW3

public final class GLFWWindow: GLFWObject {
    internal(set) public var pointer: OpaquePointer?
    
    /*public static var hints: GLFWWindowHints = .default {
        didSet {
            if hints == .default {
                glfwDefaultWindowHints()
            } else {
                hints.forEach(GLFWWindowHints.setHint)
            }
        }
    }*/
    
    public static var hints = Hints()
    
    public var frameChangeHandler: ((GLFrame<Int>) -> Void)?
    public var shouldCloseHandler: (() -> Bool)?
    public var refreshHandler: (() -> Void)?
    public var receiveFocusHandler: (() -> Void)?
    public var loseFocusHandler: (() -> Void)?
    public var minimizeHandler: (() -> Void)?
    public var maximizeHandler: (() -> Void)?
    public var restoreHandler: (() -> Void)?
    public var framebufferSizeChangeHandler: ((GLSize<Int>) -> Void)?
    public var contentScaleChangeHandler: ((GLContentScale) -> Void)?
    public var keyInputHandler: ((GLKeyboard.Key, Int, GLKeyboard.Key.State, GLKeyboard.Modifier) -> Void)?
    public var textInputHandler: ((String) -> Void)?
    
    public var cursorEnterHandler: (() -> Void)?
    public var cursorExitHandler: (() -> Void)?
    public var mouseButtonHandler: ((GLMouse.Button, GLMouse.Button.State, GLKeyboard.Modifier) -> Void)?
    public var scrollInputHandler: ((GLPoint<Double>) -> Void)?
    
    public var dragAndDropHandler: (([String]) -> Void)?
    
    public enum WindowMode {
        case minimized, maximized, fullscreen(GLFWMonitor), windowed
    }
    
    public var windowMode: WindowMode {
        if let monitor = glfwGetWindowMonitor(pointer) {
            let opaque = OpaquePointer(glfwGetMonitorUserPointer(monitor))
            return .fullscreen(GLFWMonitor.fromOpaque(opaque))
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
    
    public func makeFullscreen(monitor: GLFWMonitor, size: GLSize<Int>, refreshRate: Int? = nil) {
        glfwSetWindowMonitor(pointer, monitor.pointer, .zero, .zero, size.width.int32, size.height.int32, refreshRate?.int32 ?? Constant.dontCare)
    }
    
    public func makeFullscreen(monitor: GLFWMonitor = .primary) {
        makeFullscreen(monitor: monitor, size: monitor.workArea.size)
    }
    
    public func exitFullscreen(withFrame newFrame: GLFrame<Int>) {
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
    
    internal class AttributeManager {
        var pointer: OpaquePointer!
        init(_ pointer: OpaquePointer!) { self.pointer = pointer }
        subscript(attribute: Int32) -> Int32 {
            get { glfwGetWindowAttrib(pointer, attribute) }
            set { glfwSetWindowAttrib(pointer, attribute, newValue) }
        }
    }
    
    private var attributes: AttributeManager { AttributeManager(pointer) }
    
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
        force ? glfwRequestWindowAttention(pointer) : glfwFocusWindow(pointer)
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
    
    public var frame: GLFrame<Int> {
        get {
            var xpos = Int32.zero, ypos = Int32.zero, width = Int32.zero, height = Int32.zero
            glfwGetWindowPos(pointer, &xpos, &ypos)
            glfwGetWindowSize(pointer, &width, &height)
            return GLFrame(x: xpos.int, y: ypos.int, width: width.int, height: height.int)
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
    
    public func setSizeLimits(min: GLSize<Int>?, max: GLSize<Int>?) {
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
    
    public var framebufferSize: GLSize<Int> {
        var width = Int32.zero, height = Int32.zero
        glfwGetFramebufferSize(pointer, &width, &height)
        return GLSize(width: width.int, height: height.int)
    }
    
    public var contentScale: GLContentScale {
        var xscale = Float.zero, yscale = Float.zero
        glfwGetWindowContentScale(pointer, &xscale, &yscale)
        return GLContentScale(xscale: xscale, yscale: yscale)
    }
    
    private func positionChanged(to pos: GLPoint<Int32>) {
        var width = Int32.zero, height = Int32.zero
        glfwGetWindowSize(pointer, &width, &height)
        let size = GLSize(width: width.int, height: height.int)
        let origin = GLPoint(x: pos.x.int, y: pos.y.int)
        frameChangeHandler?(GLFrame(origin: origin, size: size))
    }
    
    private func sizeChanged(to size: GLSize<Int32>) {
        var xpos = Int32.zero, ypos = Int32.zero
        glfwGetWindowPos(pointer, &xpos, &ypos)
        let origin = GLPoint(x: xpos.int, y: ypos.int)
        let size = GLSize(width: size.width.int, height: size.height.int)
        frameChangeHandler?(GLFrame(origin: origin, size: size))
    }
    
    internal init(_ pointer: OpaquePointer!) {
        self.pointer = pointer
        glfwSetWindowUserPointer(pointer, Unmanaged.passUnretained(self).toOpaque())
        
        glfwSetWindowPosCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            //window.positionChangeHandler?(GLPoint(x: Int($1), y: Int($2)))
            window.positionChanged(to: GLPoint(x: $1, y: $2))
        }
        glfwSetWindowSizeCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            //window.sizeChangeHandler?(GLSize(width: Int($1), height: Int($2)))
            window.sizeChanged(to: GLSize(width: $1, height: $2))
        }
        glfwSetWindowCloseCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            //window.willCloseHandler?()
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
            window.framebufferSizeChangeHandler?(GLSize(width: Int($1), height: Int($2)))
        }
        glfwSetWindowContentScaleCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.contentScaleChangeHandler?(GLContentScale(xscale: $1, yscale: $2))
        }
        glfwSetKeyCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.keyInputHandler?(GLKeyboard.Key($1), $2.int, GLKeyboard.Key.State($3), GLKeyboard.Modifier(rawValue: $4))
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
            window.mouseButtonHandler?(GLMouse.Button(rawValue: $1) ?? .left, GLMouse.Button.State(rawValue: $2) ?? .released, GLKeyboard.Modifier(rawValue: $3))
        }
        glfwSetScrollCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            window.scrollInputHandler?(GLPoint(x: $1, y: $2))
        }
        glfwSetDropCallback(pointer) {
            let window = GLFWWindow.fromOpaque($0)
            let cStringArray = Array(UnsafeBufferPointer(start: $2, count: $1.int))
            let array = cStringArray.compactMap({$0}).map(String.init(cString:))
            window.dragAndDropHandler?(array)
        }
    }
    
    deinit {
        destroy()
    }
    
    public convenience init?(width: Int, height: Int, title: String = "Window", monitor: GLFWMonitor? = nil, context: GLContext? = nil) {
        guard let pointer = glfwCreateWindow(width.int32, height.int32, title, monitor?.pointer, context?.pointer) else { return nil }
        self.init(pointer)
        self.title = title
    }
    
    public convenience init(width: Int, height: Int, title: String = "Window", fullscreenOn monitor: GLFWMonitor? = nil, sharedContext context: GLContext? = nil) throws {
        let pointer = glfwCreateWindow(width.int32, height.int32, title, monitor?.pointer, context?.pointer)
        try GLSession.checkError()
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
    
    public func destroy() {        
        glfwSetWindowUserPointer(pointer, nil)
        glfwDestroyWindow(pointer)
    }
}
