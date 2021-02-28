// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Log",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Log", targets: ["Log"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0")
    ],
    targets: [
        .target(name: "Log", dependencies: ["Logging"]),
        .testTarget(name: "LogTests", dependencies: ["Log"])
    ]
)
