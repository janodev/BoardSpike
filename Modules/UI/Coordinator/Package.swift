// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Coordinator",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Coordinator", type: .static, targets: ["Coordinator"])
    ],
    dependencies: [
        .package(path: "../../Core/Log"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0")
    ],
    targets: [
        .target(name: "Coordinator", dependencies: ["Log", "Logging"]),
        .testTarget(name: "CoordinatorTests", dependencies: ["Coordinator"])
    ]
)
