# NearJsonRpcClient

A comprehensive Swift client for NEAR Protocol's JSON-RPC API, built on top of auto-generated types with full type safety and production-ready features.

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(path: "../packages/NearJsonRpcClient"),
    .package(path: "../packages/NearJsonRpcTypes")
]
```

## Features

- **Type Safety**: Built on auto-generated Swift types from NEAR's OpenAPI specification
- **Async/Await**: Modern Swift concurrency support
- **Error Handling**: Comprehensive error management with custom error types
- **Cross-platform**: macOS 10.15+, iOS 13+, watchOS 6+, tvOS 13+
- **Production Ready**: Real-world examples and comprehensive error handling
- **Method Validation**: Built-in validation for all RPC methods
- **Typed Methods**: High-level typed methods for common operations

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

### Typed Methods

```swift
// Using typed methods for better type safety
let statusData = try await status(client)
let blockData = try await block(client, finality: "final")
let gasPriceData = try await gasPrice(client, blockId: nil)
let isHealthy = try await health(client)
let networkInfo = try await networkInfo(client)
let validators = try await validators(client)
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

// View account with typed method
let accountView = try await viewAccount(client, accountId: "example.near", finality: "final")
```

### Transaction Operations

```swift
// Broadcast transaction (async)
let txResponse = try await client.request(
    method: "broadcast_tx_async",
    params: ["signed_transaction": transactionBase64]
)

// Broadcast transaction with commit
let commitResponse = try await client.request(
    method: "broadcast_tx_commit",
    params: ["signed_transaction": transactionBase64]
)

// Get transaction status
let statusResponse = try await client.request(
    method: "tx",
    params: [
        "tx_hash": transactionHash,
        "sender_account_id": senderAccountId
    ]
)
```

### Contract Operations

```swift
// View contract code
let codeResponse = try await client.request(
    method: "query",
    params: [
        "request_type": "view_code",
        "finality": "final",
        "account_id": contractId
    ]
)

// Call view function with typed method
let functionResult = try await viewFunction(
    client,
    contractId: "guest-book.testnet",
    methodName: "get_messages",
    args: "{\"limit\": 10}",
    finality: "final"
)
```

### Error Handling

```swift
do {
    let response = try await client.request(method: "status")
    // Process response
} catch NearRpcError.httpError(let statusCode) {
    print("HTTP error: \(statusCode)")
} catch NearRpcError.invalidResponse {
    print("Invalid response format")
} catch NearRpcError.networkError(let error) {
    print("Network error: \(error)")
} catch {
    print("Unexpected error: \(error)")
}
```

### Method Validation

```swift
// Validate RPC method
let isValid = RpcMethodValidator.isValid("status") // true

// Get all available methods
let allMethods = RpcMethodValidator.allMethods()

// Get experimental methods
let experimentalMethods = RpcMethodValidator.experimentalMethods()

// Get stable methods
let stableMethods = RpcMethodValidator.stableMethods()
```

## Supported Networks

- **Mainnet**: `https://rpc.mainnet.near.org`
- **Testnet**: `https://rpc.testnet.near.org`
- **Alternative Testnet**: `https://rpc.testnet.fastnear.com`
- **Custom**: Any NEAR-compatible JSON-RPC endpoint

## Supported RPC Methods

### Core Methods (8)

- `block` - Get block information
- `chunk` - Get chunk information
- `gas_price` - Get current gas price
- `status` - Get node status
- `health` - Health check
- `network_info` - Network information
- `validators` - Current validators
- `client_config` - Client configuration

### Transaction Methods (4)

- `broadcast_tx_async` - Broadcast transaction asynchronously
- `broadcast_tx_commit` - Broadcast transaction and wait for commit
- `send_tx` - Send transaction
- `tx` - Get transaction status

### Query Methods (2)

- `query` - Query account/contract state
- `light_client_proof` - Light client execution proof

### Experimental Methods (25)

All prefixed with `EXPERIMENTAL_` for advanced features.

## Examples

The client includes comprehensive examples in the `examples/` directory:

- **basic-usage**: Enhanced basic operations with 7 comprehensive examples
- **advanced-usage**: Real-world scenarios and complex operations
- **transaction-examples**: Complete transaction lifecycle management
- **contract-examples**: Smart contract interaction patterns
- **error-handling-examples**: Production-ready error handling
- **validation-examples**: Input/output validation strategies
- **typed-usage**: Advanced typed operations
- **types-usage**: Type-safe operations with generated types

## Best Practices

### Retry Patterns

```swift
func retryRequest<T>(
    maxRetries: Int = 3,
    delay: TimeInterval = 1.0,
    operation: @escaping () async throws -> T
) async throws -> T {
    var lastError: Error?

    for attempt in 1...maxRetries {
        do {
            return try await operation()
        } catch {
            lastError = error
            if attempt < maxRetries {
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
    }

    throw lastError ?? NSError(domain: "RetryError", code: -1, userInfo: [NSLocalizedDescriptionKey: "All retry attempts failed"])
}
```

### Graceful Degradation

```swift
let endpoints = [
    "https://rpc.testnet.near.org",
    "https://rpc.testnet.fastnear.com",
    "https://testnet-rpc.near.org"
]

for endpoint in endpoints {
    do {
        let client = try NearJsonRpcClient(urlString: endpoint)
        let response = try await client.request(method: "status")
        // Success - use this endpoint
        break
    } catch {
        // Try next endpoint
        continue
    }
}
```

## License

This package is distributed under the MIT license.
