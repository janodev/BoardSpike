// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "NativeLogin",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "NativeLogin", type: .static, targets: ["NativeLogin"])
    ],
    dependencies: [
        .package(path: "../../Remote/Teamwork/AuthorizationApi"),
        .package(path: "../Coordinator"),
        .package(path: "../../Storage/CredentialsStore"),
        .package(path: "../../Core/Log")
    ],
    targets: [
        .target(name: "NativeLogin", dependencies: ["AuthorizationApi", "Coordinator", "CredentialsStore", "Log"]),
        .testTarget(name: "NativeLoginTests", dependencies: ["NativeLogin"])
    ]
)
