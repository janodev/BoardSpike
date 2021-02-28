// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "TeamworkApi",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "TeamworkApi", type: .static, targets: ["TeamworkApi"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0"),
        .package(path: "../../../Core/Log"),
        .package(path: "../../Networking")
    ],
    targets: [
        .target(name: "TeamworkApi", dependencies: ["Log", "Logging", "Networking"]),
        .testTarget(name: "TeamworkApiTests", dependencies: ["TeamworkApi"])
    ]
)
