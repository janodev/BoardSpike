// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "TeamworkStore",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "TeamworkStore", type: .static, targets: ["TeamworkStore"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0"),
        .package(path: "../../Core/Log")
    ],
    targets: [
        .target(name: "TeamworkStore", dependencies: ["Log", "Logging"]),
        .testTarget(name: "TeamworkStoreTests", dependencies: ["TeamworkStore"])
    ]
)
