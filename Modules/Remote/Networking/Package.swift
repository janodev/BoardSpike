// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Networking", type: .static, targets: ["Networking"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0"),
        .package(path: "../../Core/Log")
    ],
    targets: [
        .target(name: "Networking", dependencies: ["Log", "Logging"]),
        .testTarget(name: "NetworkingTests", dependencies: ["Networking"])
    ]
)
