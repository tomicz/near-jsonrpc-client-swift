# NearJsonRpcClient

A Swift client for NEAR Protocol's JSON-RPC API, built on top of the `NearJsonRpcTypes` package.

## Features

- **Auto-generated client methods** from NEAR's OpenAPI specification
- **Type-safe RPC calls** using generated types from `NearJsonRpcTypes`
- **Convenience methods** for common operations like `viewAccount`, `viewFunction`, `viewAccessKey`
- **Automatic case conversion** between camelCase (Swift) and snake_case (NEAR API)
- **Comprehensive error handling** with detailed error types
- **Retry logic** with exponential backoff
- **Async/await support** for modern Swift concurrency
- **Zero manual maintenance** - all methods are generated automatically

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(path: "packages/NearJsonRpcClient")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["NearJsonRpcClient"]
    )
]
```

## Quick Start

```swift
import NearJsonRpcClient

// Create a client
let client = NearRpcClient(endpoint: "https://rpc.mainnet.near.org")

// Get network status
let status = try await client.getStatus()
print("Network status: \(status)")

// View account information
let account = try await client.viewAccount(accountId: "example.near")
print("Account balance: \(account.amount)")

// Get latest block
let block = try await client.getLatestBlock()
print("Latest block height: \(block["header"]?["height"])")

// Call a view function
let result = try await client.viewFunction(
    accountId: "example.near",
    methodName: "get_balance"
)
print("Function result: \(result)")
```

## Usage Examples

### Basic RPC Calls

```swift
import NearJsonRpcClient

let client = NearRpcClient(endpoint: "https://rpc.testnet.near.org")

// Get network status (generated method)
let status = try await client.status()

// Get latest block (generated method)
let latestBlock = try await client.block(params: ["finality": "final"])

// Get block by ID (generated method)
let block = try await client.block(params: ["block_id": "12345"])

// Get gas price (generated method)
let gasPrice = try await client.gasPrice(params: [:])

// Get network information (generated method)
let networkInfo = try await client.networkInfo()

// Get validators (generated method)
let validators = try await client.validators(params: [:])

// All 31+ RPC methods are available as generated methods
let queryResult = try await client.query(params: ["request_type": "view_account", "account_id": "example.near"])
```

### Account Operations

```swift
// View account information
let account = try await client.viewAccount(
    accountId: "example.near",
    finality: "final"
)

// View access key
let accessKey = try await client.viewAccessKey(
    accountId: "example.near",
    publicKey: "ed25519:...",
    finality: "final"
)
```

### Contract Function Calls

```swift
// Call a view function
let result = try await client.viewFunction(
    accountId: "example.near",
    methodName: "get_balance",
    argsBase64: nil, // No arguments
    finality: "final"
)

// Call function with arguments (base64 encoded)
let args = "eyJhY2NvdW50X2lkIjogImV4YW1wbGUubmVhciJ9" // {"account_id": "example.near"}
let resultWithArgs = try await client.viewFunction(
    accountId: "example.near",
    methodName: "get_account_balance",
    argsBase64: args
)

// Parse function result as JSON
struct BalanceResponse: Codable {
    let balance: String
}

let balance: BalanceResponse = try client.parseCallResultToJson(result)
print("Balance: \(balance.balance)")

// Or use the convenience method
let balance2: BalanceResponse = try await client.viewFunctionAsJson(
    accountId: "example.near",
    methodName: "get_balance"
)
```

### Transaction Status

```swift
// Get transaction status
let txStatus = try await client.getTransactionStatus(
    transactionHash: "abc123...",
    senderAccountId: "example.near"
)
```

### Error Handling

```swift
do {
    let account = try await client.viewAccount(accountId: "nonexistent.near")
} catch let error as NearRpcClientError {
    print("RPC Error: \(error.message) (Code: \(error.code))")
} catch let error as NearRpcNetworkError {
    print("Network Error: \(error.message)")
} catch let error as NearRpcValidationError {
    print("Validation Error: \(error.message)")
} catch {
    print("Unknown error: \(error)")
}
```

### Client Configuration

```swift
// Create client with custom configuration
let config = ClientConfig(
    endpoint: "https://rpc.mainnet.near.org",
    headers: ["Authorization": "Bearer token"],
    timeout: 60.0,
    retries: 5
)
let client = NearRpcClient(config: config)

// Create client with modified configuration
let newClient = client.withConfig(
    endpoint: "https://rpc.testnet.near.org",
    timeout: 30.0
)
```

### Health Check

```swift
// Check if the RPC endpoint is healthy
let isHealthy = await client.isHealthy()
if isHealthy {
    print("RPC endpoint is healthy")
} else {
    print("RPC endpoint is not responding")
}
```

## API Reference

### NearRpcClient

The main client class for making RPC calls.

#### Initialization

```swift
// Simple initialization
let client = NearRpcClient(endpoint: "https://rpc.mainnet.near.org")

// With configuration
let client = NearRpcClient(config: ClientConfig(...))
```

#### Convenience Methods

- `viewAccount(accountId:finality:blockId:)` - Get account information
- `viewFunction(accountId:methodName:argsBase64:finality:blockId:)` - Call a view function
- `viewAccessKey(accountId:publicKey:finality:blockId:)` - Get access key information
- `getLatestBlock(finality:)` - Get latest block
- `getBlock(blockId:)` - Get block by ID
- `getStatus()` - Get network status
- `getTransactionStatus(transactionHash:senderAccountId:)` - Get transaction status
- `getGasPrice(blockId:)` - Get gas price
- `getNetworkInfo()` - Get network information
- `getValidators(blockId:)` - Get validators

#### Utility Methods

- `parseCallResultToJson<T>(_:)` - Parse call result to JSON
- `viewFunctionAsJson<T>(accountId:methodName:argsBase64:finality:blockId:)` - Call function and parse as JSON
- `isHealthy()` - Check if endpoint is healthy
- `getCurrentBlockHeight(finality:)` - Get current block height

### Error Types

- `NearRpcClientError` - RPC server errors
- `NearRpcNetworkError` - Network/connection errors
- `NearRpcValidationError` - Parameter validation errors

## Code Generation

The client methods are automatically generated from NEAR's OpenAPI specification using the Swift code generator. This ensures:

- **Always up-to-date** with the latest NEAR RPC API
- **Zero manual maintenance** - no need to manually add new methods
- **Type safety** - all methods use the correct parameter and response types
- **Consistent API** - all methods follow the same pattern

### Regenerating Methods

To regenerate the client methods with the latest OpenAPI specification:

```bash
cd Tools/CodeGenerator
swift run
```

This will:

1. Download the latest OpenAPI spec from NEAR's repository
2. Generate updated Swift types in `NearJsonRpcTypes`
3. Generate updated client methods in `NearJsonRpcClient`
4. Test compilation to ensure everything works

## Dependencies

- `NearJsonRpcTypes` - Generated Swift types for NEAR RPC API

## License

MIT License - see LICENSE file for details.
