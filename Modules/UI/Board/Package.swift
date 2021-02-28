// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Board",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Board", type: .static, targets: ["Board"])
    ],
    dependencies: [
        .package(path: "../../Core/Log"),
        .package(path: "../../Remote/Networking"),
        .package(path: "../../Remote/Teamwork/AuthorizationApi"),
        .package(path: "../../Remote/Teamwork/TeamworkApi"),
        .package(path: "../../Storage/CredentialsStore"),
        .package(path: "../../Storage/TeamworkStore"),
        .package(path: "../Coordinator"),
        .package(path: "../NativeLogin"),
        .package(path: "../WebLogin")
    ],
    targets: [
        .target(name: "Board", dependencies: [
            "AuthorizationApi",
            "Coordinator",
            "CredentialsStore",
            "Log",
            "NativeLogin",
            "Networking",
            "TeamworkApi",
            "TeamworkStore",
            "WebLogin"
        ]),
        .testTarget(name: "BoardTests", dependencies: ["Board"])
    ]
)
