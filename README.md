# SwiftGLFW

A Swift library that adds a more Swifty interface to [GLFW](https://github.com/glfw/glfw). So far, I've only tested it on macOS, but it should compile and run on Windows and Linux.

If you just want the pure C library and bindings, I also made [CGLFW3](https://github.com/thepotatoking55/CGLFW3), which wraps GLFW as a Swift package.

## Installation

Installing is pretty standard with Swift Package Manager:

```swift
import PackageDescription

let package = Package(
    name: "GLFWSample",
    products: [ .library(name: "TestLibrary", targets: ["TestTarget"]) ],
    dependencies: [
        .package(url: "https://github.com/thepotatoking55/SwiftGLFW.git", .upToNextMajor(from: "3.3.4"))
    ],
    targets: [
        .target(
            name: "TestTarget",
            dependencies: [
                .product(name: "GLFW", package: "SwiftGLFW")
            ]
        )
    ]
)
```

## Usage
### Example Code

Here's a Swiftified version of the [example code in GLFW's C documentation](https://www.glfw.org/documentation.html#example-code) (with some error-handling additions).

```swift
import GLFW
import OpenGL // Or whatever other library you use

func main() {
    do {
        try GLFWSession.initialize()
        
        /* Create a windowed mode window and its OpenGL context */
        let window = try GLFWWindow(width: 640, height: 480, title: "Hello World")
        
        /* Make the window's context current */
        window.context.makeCurrent()
        
        /* Loop until the user closes the window */
        while !window.shouldClose {
            /* Render here */
            glClear(GL_COLOR_BUFFER_BIT)
            
            /* Swap front and back buffers */
            window.swapBuffers()
            
            /* Poll for and process events */
            GLFWSession.pollInputEvents()
        }
    } catch let error as GLFWError {
        print(error.description ?? "Unknown error")
        print(error.underlyingError.description)
    } catch {
        print(error)
    }
}
```

### Error Handling

The only throwing functions you'll come across are `GLFWSession.intialize()` and `GLFWWindow.init(...)`. However, if you want to be extra careful, there's also  

```swift
try GLFWSession.checkError()
```

Or, you can assign an error handler to catch them as soon as they come up:

```swift
GLFWSession.errorHandler = { error in
    /* do something with it here */
}
```

### Attributes

Every GLFW object is wrapped by a Swift one, which should make the interface a lot nicer to use and read. For example, this:
    
```swift
import GLFW

try! GLFWSession.initialize()

guard let window = try? GLFWWindow(width: 640, height: 480, title: "Hello World") else {
    GLFWSession.terminate()
    return
}

window.resizable = false
window.maximize()

window.mouse.useRawMotionInput = true
window.mouse.cursorMode = .disabled
window.scrollInputHandler = { offset in
    ...
}

let monitor = GLFWMonitor.primary
monitor.setGamma(1.0)
```

is equivalent to this:

```c++
#include <GLFW/glfw3.h>

GLFWwindow* window;

if !(glfwInit())
    return -1;

window = glfwCreateWindow(640, 480, "Hello World", NULL, NULL);
if !(window) {
    glfwTerminate();
    return -1;
}

glfwSetWindowAttrib(window, GLFW_RESIZABLE, GLFW_FALSE);
glfwMaximizeWindow(window);

if (glfwRawMouseMotionSupported())
    glfwSetInputMode(window, GLFW_RAW_MOUSE_MOTION, GLFW_TRUE);
    
glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);
void scroll_callback(GLFWwindow* window, double xoffset, double yoffset) {
    ...
}

glfwSetScrollCallback(window, scroll_callback);

GLFWmonitor* monitor = glfwGetPrimaryMonitor();
glfwSetGamma(monitor, 1.0);
```
