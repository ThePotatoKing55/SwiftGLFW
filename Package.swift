// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftGLFW",
    products: [
        .library(name: "GLFW", targets: ["GLFW"]),
        .library(name: "CGLFW", targets: ["CGLFW3"])
    ],
    targets: [
        .systemLibrary(
            name: "CGLFW3",
            pkgConfig: "glfw3",
            providers: [
                .brew(["glfw3"])
            ]
        ),
        .target(
            name: "GLFW", dependencies: ["CGLFW3"], cSettings: [
                .define("GLFW_EXPOSE_NATIVE_WIN32", .when(platforms: [.windows])),
                .define("GLFW_EXPOSE_NATIVE_COCOA", .when(platforms: [.macOS])),
                .define("GLFW_EXPOSE_NATIVE_NSGL", .when(platforms: [.macOS])),
                .define("GLFW_EXPOSE_NATIVE_WAYLAND", .when(platforms: [.linux]))
            ]
        ),
        .testTarget(name: "GLFWTests", dependencies: ["GLFW"])
    ]
)
