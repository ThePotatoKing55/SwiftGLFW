// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftGLFW",
    products: [
        .library(name: "SwiftGLFW", targets: ["SwiftGLFW"])
    ],
    dependencies: [
        .package(name: "CGLFW3", path: "CGLFW3")
    ],
    targets: [
        .target(name: "SwiftGLFW", dependencies: [
            .product(name: "CGLFW3", package: "CGLFW3")
        ])
    ]
)
