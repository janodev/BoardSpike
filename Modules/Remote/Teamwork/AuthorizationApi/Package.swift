// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "AuthorizationApi",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "AuthorizationApi", type: .static, targets: ["AuthorizationApi"])
    ],
    dependencies: [
        .package(path: "../../../Core/Log"),
        .package(path: "../../Networking")
    ],
    targets: [
        .target(name: "AuthorizationApi", dependencies: ["Log", "Networking"]),
        .testTarget(name: "AuthorizationApiTests", dependencies: ["AuthorizationApi"])
    ]
)
