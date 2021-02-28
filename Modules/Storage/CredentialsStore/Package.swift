// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "CredentialsStore",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "CredentialsStore", type: .static, targets: ["CredentialsStore"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0"),
        .package(path: "../../Core/Log")
    ],
    targets: [
        .target(name: "CredentialsStore", dependencies: ["Log", "Logging"]),
        .testTarget(name: "CredentialsStoreTests", dependencies: ["CredentialsStore"])
    ]
)
