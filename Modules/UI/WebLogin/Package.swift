// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "WebLogin",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "WebLogin", type: .static, targets: ["WebLogin"])
    ],
    dependencies: [
        .package(path: "../../Remote/Teamwork/AuthorizationApi"),
        .package(path: "../Coordinator"),
        .package(path: "../../Storage/CredentialsStore"),
        .package(path: "../../Core/Log")
    ],
    targets: [
        .target(name: "WebLogin", dependencies: ["AuthorizationApi", "Coordinator", "CredentialsStore", "Log"]),
        .testTarget(name: "WebLoginTests", dependencies: ["WebLogin"])
    ]
)
