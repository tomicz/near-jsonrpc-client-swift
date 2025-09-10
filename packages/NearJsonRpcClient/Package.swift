// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NearJsonRpcClient",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "NearJsonRpcClient",
            targets: ["NearJsonRpcClient"]
        )
    ],
    dependencies: [
        .package(path: "../NearJsonRpcTypes"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "NearJsonRpcClient",
            dependencies: [
                "NearJsonRpcTypes",
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime")
            ]
        ),
        .testTarget(
            name: "NearJsonRpcClientTests",
            dependencies: ["NearJsonRpcClient"]
        )
    ]
)

