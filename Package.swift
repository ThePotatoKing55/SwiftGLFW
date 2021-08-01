// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftGLFW",
    products: [
        .library(name: "GLFW", targets: ["GLFW"])
    ],
    targets: [
        .systemLibrary(name: "CGLFW3", pkgConfig: "glfw3", providers: [.brew(["glfw3"])]),
        .target(name: "GLFW", dependencies: ["CGLFW3"])
    ]
)
