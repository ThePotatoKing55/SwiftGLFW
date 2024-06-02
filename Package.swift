// swift-tools-version:5.10

import PackageDescription
import CompilerPluginSupport

let defines: [SwiftSetting] = [
    /* Uncomment when https://github.com/glfw/glfw/pull/1778 is merged into master */
    //.define("GLFW_METAL_LAYER_SUPPORT", .when(platforms: [.macOS]))
]

let package = Package(
    name: "SwiftGLFW",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "SwiftGLFW", targets: ["GLFW"])
    ],
    dependencies: [
        .package(url: "https://github.com/thepotatoking55/CGLFW3.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "GLFW", dependencies: ["CGLFW3"],
            cSettings: [
                .define("_GLFW_COCOA", .when(platforms: [.macOS])),
                .define("GLFW_EXPOSE_NATIVE_COCOA", .when(platforms: [.macOS])),
                .define("GLFW_EXPOSE_NATIVE_NSGL", .when(platforms: [.macOS])),
                .define("_GLFW_WIN32", .when(platforms: [.windows])),
                .define("GLFW_EXPOSE_NATIVE_WIN32", .when(platforms: [.windows])),
                .define("GLFW_EXPOSE_NATIVE_WGL", .when(platforms: [.windows])),
                .define("_GLFW_X11", .when(platforms: [.linux])),
                .define("GLFW_EXPOSE_NATIVE_X11", .when(platforms: [.linux])),
                .define("_DEFAULT_SOURCE", .when(platforms: [.linux])),
            ],
            swiftSettings: defines
        ),
        .testTarget(name: "GLFWTests", dependencies: ["GLFW"])
    ]
)
