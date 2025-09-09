// swift-tools-version: 5.9
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
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "NearJsonRpcTypes",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime")
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
            ]
        ),
        .testTarget(
            name: "NearJsonRpcTypesTests",
            dependencies: ["NearJsonRpcTypes"]
        )
    ]
)
