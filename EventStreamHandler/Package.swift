// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EventStreamHandler",
    platforms: [.macOS("10.13")],
    products: [
        .executable(name: "handleEventStream", targets: ["EventStreamHandler"])
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "EventStreamHandler",
            dependencies: []),
        .testTarget(
            name: "EventStreamHandlerTests",
            dependencies: ["EventStreamHandler"]),
    ]
)
