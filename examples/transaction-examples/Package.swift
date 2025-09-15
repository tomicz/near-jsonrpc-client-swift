// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TransactionExamples",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .executable(
            name: "TransactionExamples",
            targets: ["TransactionExamples"]
        )
    ],
    dependencies: [
        .package(path: "../../packages/NearJsonRpcClient"),
        .package(path: "../../packages/NearJsonRpcTypes")
    ],
    targets: [
        .executableTarget(
            name: "TransactionExamples",
            dependencies: [
                "NearJsonRpcClient",
                "NearJsonRpcTypes"
            ]
        )
    ]
)
