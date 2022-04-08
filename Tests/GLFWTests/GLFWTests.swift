import XCTest
@testable import GLFW

@MainActor
class GLFWTests: XCTestCase {
    var window: GLFWWindow!
    
    @MainActor override class func setUp() {
        XCTAssertNoThrow(try GLFWSession.initialize())
    }
    
    func testMonitorCocoaBindings() {
        XCTAssertEqual(CGMainDisplayID(), GLFWMonitor.primary.directDisplayID)
    }
    
    func testWindowCreation() {
        GLFWWindow.hints.openGLVersion = .v4_1
        GLFWWindow.hints.openGLProfile = .core
        GLFWWindow.hints.openGLCompatibility = .forward
        
        window = try? GLFWWindow(width: 400, height: 300)
        XCTAssertNotNil(window)
        
        window.context.makeCurrent()
        XCTAssertNotNil(window.nsWindow)
        XCTAssertNotNil(window.context.nsOpenGLContext)
        
        print(window.context.openGLVersion)
        
#if GLFW_METAL_LAYER_SUPPORT
        XCTAssertNotNil(window.metalLayer)
#endif
        
        Task {
            let size = 1024
            let image = await Image(width: size, height: size, initializer: { x, y in
                Color(h: Double(y)/Double(size), s: 1, v: 1)
            })
            
            await MainActor.run {
                window.setIcon(image)
                print("set app icon")
            }
        }
        
        while !window.shouldClose {
            GLFWSession.pollInputEvents()
            window.swapBuffers()
        }
    }
    
    @MainActor override class func tearDown() {
        GLFWSession.terminate()
    }
}
