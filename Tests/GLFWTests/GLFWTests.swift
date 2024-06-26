import XCTest
@testable import GLFW

class GLFWTests: XCTestCase {
    var window: GLFWWindow!
    
    @MainActor override class func setUp() {
        XCTAssertNoThrow(try GLFWSession.initialize())
    }
    
    @MainActor func testMonitorCocoaBindings() {
        XCTAssertEqual(CGMainDisplayID(), GLFWMonitor.primary.directDisplayID)
    }
    
    @MainActor func testWindowCreation() {
        GLFWWindow.hints.contextVersion = (4, 1)
        GLFWWindow.hints.openGLProfile = .core
        GLFWWindow.hints.openGLCompatibility = .forward
        
        window = try? GLFWWindow(width: 400, height: 300, title: "")
        XCTAssertNotNil(window)
        
        window.context.makeCurrent()
        XCTAssertNotNil(window.nsWindow)
        XCTAssertNotNil(window.context.nsOpenGLContext)
        
        print(window.context.version)
        
#if GLFW_METAL_LAYER_SUPPORT
        XCTAssertNotNil(window.metalLayer)
#endif
        
        Task {
            let size = 1024
            let image = Image(width: size, height: size) { x, y in
                Color(h: Double(y)/Double(size), s: 1, v: 1)
            }
            
            await MainActor.run {
                window.setIcon(image)
                print("set app icon")
            }
        }
        
        while !window.shouldClose {
            GLFWSession.pollEvents()
            window.swapBuffers()
        }
    }
    
    @MainActor override class func tearDown() {
        GLFWSession.terminate()
    }
}
