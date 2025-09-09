# API Reference

Complete API reference for the NEAR JSON-RPC Swift client.

## NearJsonRpcClient

### Initialization

```swift
// Initialize with URL string
public convenience init(urlString: String) throws

// Initialize with URL object
public init(baseURL: URL)
```

### Methods

```swift
// Make a JSON-RPC request
public func request(method: String, params: [String: Any] = [:]) async throws -> Data
```

### Properties

```swift
// Get current base URL
public var url: URL
```

### Error Types

```swift
public enum NearRpcError: Error {
    case httpError(Int)        // HTTP status code errors
    case invalidResponse       // Invalid JSON response
}
```

## NearJsonRpcTypes

### Core Types

```swift
public struct Block: Codable
public struct BlockHeader: Codable
public struct Account: Codable
public struct Transaction: Codable
public struct StatusResponse: Codable
```

### Request/Response Types

```swift
public struct BlockRequest: Codable {
    public let blockId: BlockId
}

public struct BlockResponse: Codable {
    public let header: BlockHeader
    public let chunks: [ChunkHeader]
}
```

### Enums

```swift
public enum BlockId: Codable {
    case final
    case blockHash(String)
    case blockHeight(Int)
}

public enum Finality: String, Codable {
    case optimistic = "optimistic"
    case nearFinal = "near_final"
    case final = "final"
}
```

## Supported RPC Methods

### Block Operations

- `block` - Get block information
- `block_changes` - Get block changes
- `chunk` - Get chunk information

### Account Operations

- `query` - Query account/contract
- `view_account` - View account information
- `view_access_key` - View access key

### Transaction Operations

- `tx` - Get transaction status
- `tx_status` - Get transaction status
- `send_tx` - Send transaction

### Network Operations

- `status` - Get node status
- `network_info` - Get network information
- `validators` - Get validators
- `gas_price` - Get gas price

### Contract Operations

- `call_function` - Call contract function
- `view_code` - View contract code

## Error Codes

### HTTP Status Codes

- `200` - Success
- `400` - Bad Request
- `422` - Unprocessable Entity
- `500` - Internal Server Error

### JSON-RPC Error Codes

- `-32700` - Parse error
- `-32600` - Invalid Request
- `-32601` - Method not found
- `-32602` - Invalid params
- `-32603` - Internal error

## Usage Examples

### Basic Usage

```swift
import NearJsonRpcClient
import NearJsonRpcTypes

let client = try NearJsonRpcClient(urlString: "https://rpc.mainnet.near.org")
let response = try await client.request(method: "status")
```

### Error Handling

```swift
do {
    let response = try await client.request(method: "status")
} catch NearRpcError.httpError(let statusCode) {
    print("HTTP error: \(statusCode)")
} catch {
    print("Unexpected error: \(error)")
}
```
