// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftGLFW",
    products: [
        .library(name: "SwiftGLFW", targets: ["SwiftGLFW"])
    ],
    dependencies: [
        .package(name: "CGLFW3", path: "Libraries/CGLFW3")
    ],
    targets: [
        .target(name: "SwiftGLFW", dependencies: [
            .product(name: "CGLFW3", package: "CGLFW3")
        ])
    ]
)
