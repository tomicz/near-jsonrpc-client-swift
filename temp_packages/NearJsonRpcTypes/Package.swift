// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NearJsonRpcTypes",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "NearJsonRpcTypes",
            targets: ["NearJsonRpcTypes"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NearJsonRpcTypes",
            dependencies: [],
            path: ".",
            exclude: ["Tests"]
        ),
        .testTarget(
            name: "NearJsonRpcTypesTests",
            dependencies: ["NearJsonRpcTypes"]
        ),
    ]
)
