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
    case networkError(Error)   // Network-related errors
}
```

### Typed Methods

The client also provides typed methods for common operations:

```swift
// Typed status method
public func status(_ client: NearJsonRpcClient) async throws -> JsonData

// Typed block method
public func block(_ client: NearJsonRpcClient, finality: String = "final") async throws -> JsonData

// Typed gas price method
public func gasPrice(_ client: NearJsonRpcClient, blockId: Any? = nil) async throws -> JsonData

// Typed health check
public func health(_ client: NearJsonRpcClient) async throws -> Bool

// Typed network info
public func networkInfo(_ client: NearJsonRpcClient) async throws -> [String: Any]

// Typed validators
public func validators(_ client: NearJsonRpcClient) async throws -> [String: Any]

// Typed account view
public func viewAccount(_ client: NearJsonRpcClient, accountId: String, finality: String = "final") async throws -> AccountView

// Typed view function
public func viewFunction(_ client: NearJsonRpcClient, contractId: String, methodName: String, args: String = "{}", finality: String = "final") async throws -> [String: Any]
```

## NearJsonRpcTypes

### Core Types

```swift
// JSON-RPC Protocol Types
public struct JsonRpcRequest: Codable, Sendable
public struct JsonRpcResponse<T: Codable & Sendable>: Codable, Sendable
public struct RpcError: Codable, Sendable

// NEAR Protocol Core Types
public typealias AccountId = String
public typealias PublicKey = String
public typealias Signature = String
public typealias BlockHash = String
public typealias TransactionHash = String
public typealias ChunkHash = String
public typealias CryptoHash = String
public typealias GasPrice = String
public typealias Balance = String
public typealias Gas = UInt64
public typealias BlockHeight = UInt64
public typealias EpochId = String
public typealias ShardId = UInt64
```

### Account Types

```swift
public struct AccessKey: Codable, Sendable
public enum AccessKeyPermission: Codable, Sendable
public struct FunctionCallPermission: Codable, Sendable
public struct AccessKeyView: Codable, Sendable
public enum AccessKeyPermissionView: Codable, Sendable
public struct FunctionCallPermissionView: Codable, Sendable
public struct AccountView: Codable, Sendable
```

### Block Types

```swift
public enum BlockId: Codable, Sendable {
    case hash(BlockHash)
    case height(BlockHeight)
}

public enum Finality: String, Codable, Sendable {
    case optimistic = "optimistic"
    case nearFinal = "near_final"
    case final = "final"
}

public struct BlockHeader: Codable, Sendable
```

### Validator Types

```swift
public struct ValidatorStakeView: Codable, Sendable
public struct SlashedValidator: Codable, Sendable
```

### Transaction Types

```swift
public struct Transaction: Codable, Sendable
public enum Action: Codable, Sendable {
    case createAccount
    case deployContract(DeployContractAction)
    case functionCall(FunctionCallAction)
    case transfer(TransferAction)
    case stake(StakeAction)
    case addKey(AddKeyAction)
    case deleteKey(DeleteKeyAction)
    case deleteAccount(DeleteAccountAction)
}

public struct DeployContractAction: Codable, Sendable
public struct FunctionCallAction: Codable, Sendable
public struct TransferAction: Codable, Sendable
public struct StakeAction: Codable, Sendable
public struct AddKeyAction: Codable, Sendable
public struct DeleteKeyAction: Codable, Sendable
public struct DeleteAccountAction: Codable, Sendable
```

### RPC Request/Response Types

```swift
public struct RpcQueryRequest: Codable, Sendable
public struct RpcQueryResponse: Codable, Sendable
```

### Utility Types

```swift
public struct AnyCodable: Codable
public struct JsonData: @unchecked Sendable
```

### Method Validation

```swift
public struct RpcMethodValidator {
    public static func isValid(_ method: String) -> Bool
    public static func path(for method: String) -> String?
    public static func method(for path: String) -> String?
    public static func allMethods() -> [String]
    public static func experimentalMethods() -> [String]
    public static func stableMethods() -> [String]
}
```

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

All prefixed with `EXPERIMENTAL_`:

- State changes: `EXPERIMENTAL_changes`, `EXPERIMENTAL_changes_in_block`
- Validation: `EXPERIMENTAL_validators_ordered`
- Protocol: `EXPERIMENTAL_protocol_config`, `EXPERIMENTAL_genesis_config`
- Light client: `EXPERIMENTAL_light_client_proof`, `EXPERIMENTAL_light_client_block_proof`
- Receipts: `EXPERIMENTAL_receipt`
- Transactions: `EXPERIMENTAL_tx_status`
- Storage: `EXPERIMENTAL_split_storage_info`
- Congestion: `EXPERIMENTAL_congestion_level`
- Maintenance: `EXPERIMENTAL_maintenance_windows`

## Error Codes

### HTTP Status Codes

- `200` - Success
- `400` - Bad Request
- `408` - Request Timeout
- `422` - Unprocessable Entity
- `500` - Internal Server Error

### JSON-RPC Error Codes

- `-32700` - Parse error
- `-32600` - Invalid Request
- `-32601` - Method not found
- `-32602` - Invalid params
- `-32603` - Internal error
- `-32000` - Server error

## Usage Examples

### Basic Usage

```swift
import NearJsonRpcClient
import NearJsonRpcTypes

let client = try NearJsonRpcClient(urlString: "https://rpc.mainnet.near.org")
let response = try await client.request(method: "status")
```

### Typed Usage

```swift
import NearJsonRpcClient
import NearJsonRpcTypes

let client = try NearJsonRpcClient(urlString: "https://rpc.testnet.near.org")

// Using typed methods
let statusData = try await status(client)
let blockData = try await block(client, finality: "final")
let accountView = try await viewAccount(client, accountId: "example.testnet")
```

### Error Handling

```swift
do {
    let response = try await client.request(method: "status")
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

// Call view function
let functionResponse = try await client.request(
    method: "query",
    params: [
        "request_type": "call_function",
        "finality": "final",
        "account_id": contractId,
        "method_name": methodName,
        "args_base64": argsBase64
    ]
)
```

### Validation

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
