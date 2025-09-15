// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ErrorHandlingExamples",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .executable(
            name: "ErrorHandlingExamples",
            targets: ["ErrorHandlingExamples"]
        )
    ],
    dependencies: [
        .package(path: "../../packages/NearJsonRpcClient"),
        .package(path: "../../packages/NearJsonRpcTypes")
    ],
    targets: [
        .executableTarget(
            name: "ErrorHandlingExamples",
            dependencies: [
                "NearJsonRpcClient",
                "NearJsonRpcTypes"
            ]
        )
    ]
)
