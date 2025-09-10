// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "NearJsonRpcTypes",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "NearJsonRpcTypes",
            targets: ["NearJsonRpcTypes"]
        )
    ],
    dependencies: [
        // No external dependencies needed for types-only package
    ],
    targets: [
        .target(
            name: "NearJsonRpcTypes",
            dependencies: [
                // No dependencies needed for types-only package
            ]
        ),
        .testTarget(
            name: "NearJsonRpcTypesTests",
            dependencies: ["NearJsonRpcTypes"]
        )
    ]
)
