// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TypedUsage",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .executable(
            name: "TypedUsage",
            targets: ["TypedUsage"]
        )
    ],
    dependencies: [
        .package(path: "../../packages/NearJsonRpcClient"),
        .package(path: "../../packages/NearJsonRpcTypes")
    ],
    targets: [
        .executableTarget(
            name: "TypedUsage",
            dependencies: [
                "NearJsonRpcClient",
                "NearJsonRpcTypes"
            ]
        )
    ]
)
