# SwiftGLFW

A Swift library that adds a more Swift-like interface to [GLFW](https://github.com/glfw/glfw). So far, it's only been tested on macOS, but it should compile and run on Windows and Linux with little difficulty.

This package is based on [CGLFW3](https://github.com/thepotatoking55/CGLFW3), which is just the pure C bindings.

## Setting Up


For now, SwiftGLFW relies on GLFW being installed through Homebrew. Just run

```bash
brew install glfw3
```

in the Terminal. Once GLFW is installed, adding SwiftGLFW to your project is pretty standard for a Swift Package.

```swift
import PackageDescription

let package = Package(
    name: "GLFWSample",
    products: [
        .executable(name: "GLFW Sample", targets: ["GLFWSample"])
    ],
    dependencies: [
        .package(url: "https://github.com/thepotatoking55/SwiftGLFW.git", .upToNextMajor(from: "v4.0.0"))
    ],
    targets: [
        .executableTarget(
            name: "GLFWSample",
            dependencies: [
                .product(name: "GLFW", package: "SwiftGLFW")
            ]
        )
    ]
)
```

## Usage
### Example Code

GLFW's [Hello Window example](https://www.glfw.org/documentation.html#example-code), except in a much more Swift-idiomatic way:

```swift
import GLFW
import OpenGL // Or whatever other library you use

func main() {
    do {
        try GLFWSession.initialize()
        
        /* macOS's OpenGL implementation requires some extra tweaking */
        Window.hints.openglVersion = .v4_1
        Window.hints.openglProfile = .core
        Window.hints.openglCompatibility = .forward
        
        /* Create a windowed mode window and its OpenGL context */
        let window = try Window(width: 640, height: 480, title: "Hello World")
        
        /* Make the window's context current */
        window.context.makeCurrent()
        
        /* Loop until the user closes the window */
        while !window.shouldClose {
            /* Render here */
            glClear(GL_COLOR_BUFFER_BIT)
            someRenderFunctionDefinedElsewhere()
            
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

Since they're fundamental to GLFW, `GLFWSession.initialize` and `Window.init` can both throw errors. However, if you're expecting potential errors in other places, you can also call

```swift
try GLFWSession.checkForError()
```

Or, you can assign an error handler to catch them as soon as they come up:

```swift
GLFWSession.errorHandler = { error in
    /* do something with it here */
}
```

### Wrapping things up

Like Swift, this package is built with readability and strong type-checking in mind. Rather than passing ints and opaque pointers around, variables are represented with enums and so on.
    
```swift
import GLFW

try! GLFWSession.initialize()

guard let window = try? Window(width: 640, height: 480, title: "Hello World") else {
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

Is equivalent to this:

```c++
#include <GLFW/glfw3.h>

GLFWwindow* window;

if !(glfwInit()) {
    return -1;
}

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
