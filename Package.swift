// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftGLFW",
    products: [
        .library(name: "GLFW", type: .dynamic, targets: ["GLFW"])
    ],
    dependencies: [
        .package(url: "https://github.com/thepotatoking55/CGLFW3.git", .branch("main"))
    ],
    targets: [
        .target(name: "GLFW", dependencies: ["CGLFW3"])
    ]
)
