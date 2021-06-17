# SwiftGLFW

A Swift library that adds a more Swifty interface to [GLFW](https://github.com/glfw/glfw). So far, I've only tested it on macOS, but it should compile and run on Windows and Linux.

If you just want the pure C library, I also made [CGLFW3](https://github.com/thepotatoking55/CGLFW3), which wraps GLFW as a Swift package.

## Installation

Installing is pretty standard for the Swift Package Manager. Add this to your dependencies:

```swift
.package(url: "https://github.com/thepotatoking55/SwiftGLFW.git", .upToNextMajor(from: "3.3.4"))
```
    
## How to Use

### Basic Setup

Setup is pretty painless, requiring just a few lines of code:

```swift
import GLFW

...

func main() {
    GLSession.initialize()
    
    GLWindow.hints.add(.openGLVersion(.v4_6))
    GLWindow.hints.add(.openGLProfile(.core))
    GLWindow.hints.add(.openGLCompatibility(.forward))
    
    let window = GLWindow.create(size: GLSize(width: 860, height: 480), title: "SwiftGLFW")
    window.context.makeCurrent()
    
    window.keyInputHandler = { key, scancode, state, modifiers in
        if key == .escape && state == .pressed {
            window.close()
        }
    }
    
    while !window.shouldClose {
        GLSession.pollInputEvents()
        someRenderFunctionDeclaredEarlier()
        window.swapBuffers()
    }
    
    GLSession.terminate()
}
```

### Error Handling

While there are no direct errors thrown, you may come across some weirdness (namely, windows coming up `nil`) when something goes wrong. To check on the latest error from GLFW, call this:

```swift
let error = GLSession.getError()
```

Or, you can assign an error handler to catch them as soon as they come up:

```swift
GLSession.errorHandler = { error in
    /* do something with it here */
}
```
    
### Attributes

Attributes are no longer accessed or modified through functions like `glfwGetWindowAttrib()`/`glfwSetWindowAttrib()`. Instead, the library handles all of the C functions and constants to create Swifty objects. For example:
    
```swift
let window = GLWindow.create(...)
window.resizable = true
window.maxmize()

window.mouse.useRawMotionInput = true
window.mouse.cursorMode = .disabled
window.scrollInputHandler = { offset in ... }

let monitor = GLMonitor.primary
monitor.setGamma(2.2)
```

### Gamepad Support

GLFW supports gamepads, so this does too!

```swift
let movementSpeed = GLGamepad[0]?.input.thumbstick.left.y ?? 0.0
```
