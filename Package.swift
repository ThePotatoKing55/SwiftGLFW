// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftGLFW",
    products: [
        .library(name: "SwiftGLFW", targets: ["SwiftGLFW"])
    ],
    dependencies: [
        .package(url: "https://github.com/thepotatoking55/CGLFW3.git", .upToNextMajor(from: "3.3.4"))
    ],
    targets: [
        .target(name: "SwiftGLFW", dependencies: ["CGLFW3"])
    ]
)
