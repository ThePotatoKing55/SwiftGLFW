// swift-tools-version:5.5

import PackageDescription

let defines: [SwiftSetting] = [
    /* When this fork https://github.com/thisistherk/glfw is merged into main */
    .define("GLFW_METAL_LAYER_SUPPORT")
]

let package = Package(
    name: "SwiftGLFW",
    products: [
        .library(name: "GLFW", targets: ["GLFW"])
    ],
    dependencies: [
        .package(name: "CGLFW3", path: "Dependencies/CGLFW3")
    ],
    targets: [
        .target(
            name: "GLFW", dependencies: ["CGLFW3"],
            cSettings: [
                .define("GLFW_EXPOSE_NATIVE_WIN32", .when(platforms: [.windows])),
                .define("GLFW_EXPOSE_NATIVE_COCOA", .when(platforms: [.macOS])),
                .define("GLFW_EXPOSE_NATIVE_NSGL", .when(platforms: [.macOS])),
                //.define("GL_SILENCE_DEPRECATION", .when(platforms: [.macOS])),
                .define("GLFW_EXPOSE_NATIVE_WAYLAND", .when(platforms: [.linux]))
            ],
            swiftSettings: defines
        ),
        .testTarget(name: "GLFWTests", dependencies: ["GLFW"], swiftSettings: defines)
    ]
)
