// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftGLFW",
    products: [
        .library(name: "SwiftGLFW", targets: ["SwiftGLFW"])
    ],
    dependencies: [
        .package(url: "https://github.com/thepotatoking55/CGLFW3", .branch("main"))
    ],
    targets: [
        .target(name: "GLFW",
                exclude: ["README.md", "LICENSE.md",
                          "src/glx_context.c",
                          "src/glx_context.h",
                          "src/linux_joystick.c",
                          "src/linux_joystick.h",
                          "src/null_init.c",
                          "src/null_joystick.c",
                          "src/null_joystick.h",
                          "src/null_monitor.c",
                          "src/null_platform.h",
                          "src/null_window.c",
                          "src/osmesa_context.c",
                          "src/osmesa_context.h",
                          "src/posix_thread.c",
                          "src/posix_thread.h",
                          "src/posix_time.c",
                          "src/posix_time.h",
                          "src/wgl_context.c",
                          "src/wgl_context.h",
                          "src/win32_init.c",
                          "src/win32_joystick.c",
                          "src/win32_joystick.h",
                          "src/win32_monitor.c",
                          "src/win32_platform.h",
                          "src/win32_thread.c",
                          "src/win32_time.c",
                          "src/win32_window.c",
                          "src/wl_init.c",
                          "src/wl_monitor.c",
                          "src/wl_platform.h",
                          "src/wl_window.c",
                          "src/x11_init.c",
                          "src/x11_monitor.c",
                          "src/x11_platform.h",
                          "src/x11_window.c",
                          "src/xkb_unicode.c",
                          "src/xkb_unicode.h"
                         ],
                cSettings: [
                    .define("_GLFW_COCOA", .when(platforms: [.macOS])),
                    .define("_GLFW_WIN32", .when(platforms: [.windows])),
                    .define("_GLFW_BUILD_DLL", .when(platforms: [.windows])),
                    .define("_GLFW_X11", .when(platforms: [.linux])),
                    .unsafeFlags([
                        "-fno-objc-arc"
                    ])
                ]),
        .target(name: "SwiftGLFW", dependencies: ["GLFW"])
    ]
)
