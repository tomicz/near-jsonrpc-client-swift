# NearJsonRpcClient

A Swift client for NEAR Protocol's JSON-RPC API, built on top of auto-generated types.

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(path: "../packages/NearJsonRpcClient"),
    .package(path: "../packages/NearJsonRpcTypes")
]
```

## Usage

### Basic Usage

```swift
import NearJsonRpcClient
import NearJsonRpcTypes

// Initialize client
let client = try NearJsonRpcClient(urlString: "https://rpc.mainnet.near.org")

// Make requests
let response = try await client.request(method: "status")
let blockResponse = try await client.request(method: "block", params: ["finality": "final"])
```

### Common Operations

```swift
// Get node status
let statusResponse = try await client.request(method: "status")

// Get latest block
let blockResponse = try await client.request(method: "block", params: ["finality": "final"])

// Query account
let accountResponse = try await client.request(
    method: "query",
    params: [
        "request_type": "view_account",
        "finality": "final",
        "account_id": "example.near"
    ]
)
```

### Error Handling

```swift
do {
    let response = try await client.request(method: "status")
    // Process response
} catch NearRpcError.httpError(let statusCode) {
    print("HTTP error: \(statusCode)")
} catch {
    print("Unexpected error: \(error)")
}
```

## Supported Networks

- **Mainnet**: `https://rpc.mainnet.near.org`
- **Testnet**: `https://rpc.testnet.near.org`
- **Custom**: Any NEAR-compatible JSON-RPC endpoint

## Features

- **Type Safety**: Built on auto-generated Swift types
- **Async/Await**: Modern Swift concurrency support
- **Error Handling**: Comprehensive error management
- **Cross-platform**: macOS, iOS, Linux support

## License

This package is distributed under the MIT license.
