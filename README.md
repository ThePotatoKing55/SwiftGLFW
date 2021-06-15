# SwiftGLFW

A Swift library that makes GLFW a bit more manageable. It's a bit of a deviation from the original C library, as not only does it clear away non-Swifty things like pointers and properly wrap callback closures, but it also has a much more object-oriented architecture.

## Installation

Installing is pretty standard for the Swift Package Manager. Add this to your dependencies:

```swift
.package(url: "https://github.com/thepotatoking55/SwiftGLFW.git", .upToNextMajor(from: "3.3.4"))
```
    
## How to Use

### Basic Setup

Setup is pretty painless, requiring just a few lines of code:

```swift
import SwiftGLFW
import CGLFW3 // Not strictly necessary, but nicely imports OpenGL

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
    
    glClearColor(0.2, 0.3, 0.3, 1.0) // OpenGL function imported through glfw3
    
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
