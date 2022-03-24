import XCTest
@testable import GLFW

class GLFWTests: XCTestCase {
    var window: GLFWWindow!
    
    override class func setUp() {
        XCTAssertNoThrow(try GLFWSession.initialize())
    }
    
    func testMonitorCocoaBindings() {
        XCTAssertEqual(CGMainDisplayID(), GLFWMonitor.primary.directDisplayID)
    }
    
    func testWindowCreation() {
        GLFWWindow.hints.openglVersion = .v4_1
        GLFWWindow.hints.openglProfile = .core
        GLFWWindow.hints.openglCompatibility = .forward
        
        window = try? GLFWWindow(width: 400, height: 300)
        XCTAssertNotNil(window)
        
        window.context.makeCurrent()
        XCTAssertNotNil(window.nsWindow)
        XCTAssertNotNil(window.context.nsOpenGLContext)
        
        #if GLFW_METAL_LAYER_SUPPORT
        XCTAssertNotNil(window.metalLayer)
        #else
        print("GLFW_METAL_LAYER_SUPPORT not defined; skipping metal layer test")
        #endif
        
        while !window.shouldClose {
            GLFWSession.pollInputEvents()
            window.swapBuffers()
        }
    }
    
    override class func tearDown() {
        GLFWSession.terminate()
    }
}
