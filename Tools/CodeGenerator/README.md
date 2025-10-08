# NEAR Protocol Swift Code Generator

Automated tool that generates type-safe Swift code from NEAR's OpenAPI specification.

## Getting Started

### Running the Generator

```bash
cd Tools/CodeGenerator
swift run
```

### What It Generates

The generator downloads the latest NEAR OpenAPI spec and creates:

- `Packages/NearJsonRpcTypes/Types.swift` - 249+ Swift types
- `Packages/NearJsonRpcTypes/Methods.swift` - RPC method enum
- `Packages/NearJsonRpcClient/Sources/GeneratedMethods.swift` - 38+ client methods
- `Packages/NearJsonRpcClient/Sources/ConvenienceMethods.swift` - Helper functions

### Verification

After generation, verify the output:

```bash
# Test types package compiles
cd ../../Packages/NearJsonRpcTypes
swift build

# Test client package compiles
cd ../NearJsonRpcClient
swift build

# Run example to test everything works
cd ../../Examples/BasicExample
swift run
```

## Examples

### Generated Type

```swift
// From OpenAPI schema
public struct RpcStatusResponse: Codable, Sendable {
    public let chain_id: String
    public let protocol_version: Int64
    public let version: NodeVersion
    public let sync_info: StatusSyncInfo
}
```

### Generated Client Method

```swift
// From OpenAPI path
public func status() async throws -> RpcStatusResponse {
    return try await makeRequest(method: .status)
}
```

### Generated Convenience Method

```swift
// Helper wrapper
public func getLatestBlock(finality: Finality = "final") async throws -> RpcBlockResponse {
    return try await block(params: ["finality": finality])
}
```

## Automation

The generator runs automatically daily via GitHub Actions. See [codegenerator.yml](../../.github/workflows/codegenerator.yml) for details.

## Learn More

- [NearJsonRpcTypes](../../Packages/NearJsonRpcTypes/)
- [NearJsonRpcClient](../../Packages/NearJsonRpcClient/)
- [NEAR OpenAPI Spec](https://github.com/near/nearcore/blob/master/chain/jsonrpc/openapi/openapi.json)
