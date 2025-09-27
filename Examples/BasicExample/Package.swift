// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "BasicExample",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .executable(
            name: "BasicExample",
            targets: ["BasicExample"]
        )
    ],
    dependencies: [
        .package(path: "../../packages/NearJsonRpcClient")
    ],
    targets: [
        .executableTarget(
            name: "BasicExample",
            dependencies: ["NearJsonRpcClient"]
        )
    ]
)
