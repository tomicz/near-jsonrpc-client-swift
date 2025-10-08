# NearJsonRpcTypes

Pure Swift types for NEAR Protocol's JSON-RPC API, automatically generated from the official OpenAPI specification.

## Getting Started

### Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/tomicz/near-jsonrpc-client-swift.git", from: "1.0.0")
]
```

Then add to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: ["NearJsonRpcTypes"]
)
```

### Basic Usage

```swift
import NearJsonRpcTypes

// Use generated types
let status = RpcStatusResponse(
    chain_id: "mainnet",
    protocol_version: 62,
    latest_protocol_version: 62,
    version: nodeVersion,
    sync_info: syncInfo,
    validators: []
)

// Encode to JSON
let encoder = JSONEncoder()
let data = try encoder.encode(status)

// Decode from JSON
let decoder = JSONDecoder()
let decoded = try decoder.decode(RpcStatusResponse.self, from: data)
```

## What's Included

### Types.swift (249+ types)

**Core Types:**

- `RpcStatusResponse`, `RpcBlockResponse`, `RpcChunkResponse`
- `RpcTransactionResponse`, `RpcGasPriceResponse`
- `RpcValidatorResponse`, `RpcNetworkInfoResponse`

**Blockchain Types:**

- `BlockHeaderView`, `ChunkHeaderView`, `TransactionView`
- `ExecutionOutcomeView`, `ReceiptView`

**Account Types:**

- `AccountView`, `AccessKeyView`, `AccessKeyPermissionView`
- `FunctionCallPermissionView`

**Primitive Types:**

- `AccountId`, `CryptoHash`, `PublicKey`, `Signature`
- `Balance`, `Gas`, `BlockHeight`

**And 200+ more...**

### Methods.swift

```swift
// RPC method enumeration
public enum RpcMethod: String, CaseIterable {
    case status = "status"
    case block = "block"
    case chunk = "chunk"
    case query = "query"
    case tx = "tx"
    // ... 38+ methods
}

// Path to method mapping
public let PATH_TO_METHOD_MAP: [String: String]
```

## Examples

### Using Status Response

```swift
import NearJsonRpcTypes

let status = RpcStatusResponse(
    chain_id: "mainnet",
    protocol_version: 62,
    latest_protocol_version: 62,
    version: NodeVersion(version: "1.37.0", build: ""),
    sync_info: StatusSyncInfo(
        latest_block_hash: "abc123...",
        latest_block_height: 123456789,
        latest_block_time: "2024-01-01T00:00:00.000Z",
        syncing: false
    ),
    validators: [],
    node_public_key: "ed25519:...",
    genesis_hash: "xyz789...",
    uptime_sec: 3600
)

print("Chain: \(status.chain_id)")
print("Latest block: \(status.sync_info.latest_block_height)")
```

### Using Block Response

```swift
import NearJsonRpcTypes

// All types are Codable
let jsonData = """
{
  "author": "example.near",
  "header": { ... },
  "chunks": [ ... ]
}
""".data(using: .utf8)!

let block = try JSONDecoder().decode(RpcBlockResponse.self, from: jsonData)
print("Block author: \(block.author)")
```

### Using RPC Methods

```swift
import NearJsonRpcTypes

// Type-safe method access
let method = RpcMethod.status
print("Calling: \(method.rawValue)")

// Get all available methods
let allMethods = RpcMethod.allMethods
print("Available: \(allMethods.count) methods")

// Path mapping
if let methodName = PATH_TO_METHOD_MAP["/block"] {
    print("Path /block maps to: \(methodName)")
}
```

## Features

- ✅ **Zero dependencies** - Pure Swift types only
- ✅ **Fully typed** - No `Any` types, strict type safety
- ✅ **Codable** - Seamless JSON encoding/decoding
- ✅ **Sendable** - Swift 6 concurrency support
- ✅ **Auto-generated** - Always up-to-date with NEAR's API
- ✅ **249+ types** - Complete API coverage
- ✅ **Cross-platform** - macOS, iOS, tvOS, watchOS

## Type Conventions

All types follow Swift naming conventions:

- **Structs** for data structures: `RpcStatusResponse`, `BlockHeaderView`
- **Enums** for variants: `RpcMethod`, `TxExecutionStatus`
- **TypeAliases** for primitives: `AccountId = String`, `Balance = String`
- **snake_case** for property names (matching NEAR API): `chain_id`, `latest_block_height`

## Documentation

- [Code Generator](../../Tools/CodeGenerator/) - How types are generated
- [Client Package](../NearJsonRpcClient/) - Full RPC client using these types
- [Examples](../../Examples/) - Usage examples

## License

MIT License - see [LICENSE](../../LICENSE) file for details.
