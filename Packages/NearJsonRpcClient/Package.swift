// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NearJsonRpcClient",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "NearJsonRpcClient",
            targets: ["NearJsonRpcClient"]
        ),
    ],
    dependencies: [
        .package(path: "../NearJsonRpcTypes")
    ],
    targets: [
        .target(
            name: "NearJsonRpcClient",
            dependencies: ["NearJsonRpcTypes"],
            path: "Sources"
        ),
        .testTarget(
            name: "NearJsonRpcClientTests",
            dependencies: ["NearJsonRpcClient", "NearJsonRpcTypes"]
        ),
    ]
)

