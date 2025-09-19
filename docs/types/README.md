# NearJsonRpcTypes

Swift types and schemas for the NEAR Protocol JSON-RPC API, auto-generated from the official NEAR OpenAPI specification with comprehensive type safety and validation.

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(path: "../packages/NearJsonRpcTypes")
]
```

## Features

- **Auto-generated Types**: All types are automatically generated from the official NEAR OpenAPI specification
- **Type Safety**: Ensure your NEAR applications are type-safe at compile time
- **Complete Coverage**: Includes all RPC methods, request types, and response types
- **Method Validation**: Built-in validation for all RPC methods
- **Sendable Support**: All types conform to `Sendable` for Swift concurrency
- **Comprehensive Types**: 400+ type definitions covering all NEAR Protocol operations

## Core Type Categories

### JSON-RPC Protocol Types

```swift
// Standard JSON-RPC 2.0 structures
public struct JsonRpcRequest: Codable, Sendable
public struct JsonRpcResponse<T: Codable & Sendable>: Codable, Sendable
public struct RpcError: Codable, Sendable
```

### NEAR Protocol Core Types

```swift
// Core NEAR Protocol type aliases
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
// Access key and permission types
public struct AccessKey: Codable, Sendable
public enum AccessKeyPermission: Codable, Sendable {
    case fullAccess
    case functionCall(FunctionCallPermission)
}

public struct FunctionCallPermission: Codable, Sendable {
    public let allowance: Balance?
    public let receiverId: AccountId
    public let methodNames: [String]
}

// Account view types
public struct AccessKeyView: Codable, Sendable
public enum AccessKeyPermissionView: Codable, Sendable {
    case fullAccess
    case functionCall(FunctionCallPermissionView)
}

public struct FunctionCallPermissionView: Codable, Sendable
public struct AccountView: Codable, Sendable {
    public let amount: Balance
    public let locked: Balance
    public let codeHash: CryptoHash
    public let storageUsage: UInt64
    public let storagePaidAt: UInt64
    public let blockHeight: BlockHeight
    public let blockHash: BlockHash
}
```

### Block Types

```swift
// Block identification
public enum BlockId: Codable, Sendable {
    case hash(BlockHash)
    case height(BlockHeight)
}

// Finality types
public enum Finality: String, Codable, Sendable {
    case optimistic = "optimistic"
    case nearFinal = "near_final"
    case final = "final"
}

// Block header with comprehensive metadata
public struct BlockHeader: Codable, Sendable {
    public let height: BlockHeight
    public let epochId: EpochId
    public let nextEpochId: EpochId
    public let hash: BlockHash
    public let prevHash: BlockHash
    public let prevStateRoot: CryptoHash
    public let chunkReceiptsRoot: CryptoHash
    public let chunkHeadersRoot: CryptoHash
    public let chunkTxRoot: CryptoHash
    public let outcomeRoot: CryptoHash
    public let chunksIncluded: UInt64
    public let challengesRoot: CryptoHash
    public let timestamp: UInt64
    public let timestampNanosec: String
    public let randomValue: CryptoHash
    public let validatorProposals: [ValidatorStakeView]
    public let chunkMask: [Bool]
    public let gasPrice: Balance
    public let blockOrdinal: UInt64?
    public let totalSupply: Balance
    public let challengesResult: [SlashedValidator]
    public let lastFinalBlock: BlockHash
    public let lastDsFinalBlock: BlockHash?
    public let nextBpHash: BlockHash
    public let blockMerkleRoot: CryptoHash
    public let epochSyncDataHash: CryptoHash?
    public let approvals: [Signature?]
    public let signature: Signature
    public let latestProtocolVersion: UInt32
}
```

### Validator Types

```swift
// Validator stake information
public struct ValidatorStakeView: Codable, Sendable {
    public let accountId: AccountId
    public let publicKey: PublicKey
    public let stake: Balance
    public let validatorStakeStructVersion: String
}

// Slashed validator information
public struct SlashedValidator: Codable, Sendable {
    public let accountId: AccountId
    public let isDoubleSign: Bool
}
```

### Transaction Types

```swift
// Transaction structure
public struct Transaction: Codable, Sendable {
    public let signerId: AccountId
    public let publicKey: PublicKey
    public let nonce: UInt64
    public let receiverId: AccountId
    public let actions: [Action]
    public let signature: Signature
    public let hash: TransactionHash
}

// Transaction actions
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

// Action types
public struct DeployContractAction: Codable, Sendable {
    public let code: String // Base64 encoded WASM
}

public struct FunctionCallAction: Codable, Sendable {
    public let methodName: String
    public let args: String // Base64 encoded JSON
    public let gas: Gas
    public let deposit: Balance
}

public struct TransferAction: Codable, Sendable {
    public let deposit: Balance
}

public struct StakeAction: Codable, Sendable {
    public let stake: Balance
    public let publicKey: PublicKey
}

public struct AddKeyAction: Codable, Sendable {
    public let publicKey: PublicKey
    public let accessKey: AccessKey
}

public struct DeleteKeyAction: Codable, Sendable {
    public let publicKey: PublicKey
}

public struct DeleteAccountAction: Codable, Sendable {
    public let beneficiaryId: AccountId
}
```

### RPC Request/Response Types

```swift
// RPC query request
public struct RpcQueryRequest: Codable, Sendable {
    public let requestType: String
    public let blockId: BlockId?
    public let finality: Finality?
    public let accountId: AccountId?
    public let prefixBase64: String?
    public let keyBase64: String?
    public let path: String?
    public let data: String?
    public let methodName: String?
    public let args: String?
}

// RPC query response
public struct RpcQueryResponse: Codable, Sendable {
    public let blockHash: BlockHash
    public let blockHeight: BlockHeight
    public let proof: [String]?
    public let value: String?
    public let logs: [String]?
    public let error: String?
}
```

### Utility Types

```swift
// AnyCodable - allows encoding/decoding of any JSON value
public struct AnyCodable: Codable {
    public let value: Any

    public init(_ value: Any)
    public init(from decoder: Decoder) throws
    public func encode(to encoder: Encoder) throws

    // Extension for type conversion
    public func decode<T: Codable>(_ type: T.Type) throws -> T
}

// Sendable wrapper for JSON data
public struct JsonData: @unchecked Sendable {
    public let value: [String: Any]

    public init(_ value: [String: Any])
}
```

## Method Validation

### RPC Method Validation

```swift
public struct RpcMethodValidator {
    // Check if a method is valid
    public static func isValid(_ method: String) -> Bool

    // Get the path for a given method
    public static func path(for method: String) -> String?

    // Get the method for a given path
    public static func method(for path: String) -> String?

    // Get all available methods
    public static func allMethods() -> [String]

    // Get all experimental methods
    public static func experimentalMethods() -> [String]

    // Get all stable methods
    public static func stableMethods() -> [String]
}
```

### Method Mapping

```swift
// Maps OpenAPI paths to actual JSON-RPC method names
public let pathToMethodMap: [String: String]

// Reverse mapping for convenience
public let methodToPathMap: [String: String]

// Available RPC methods
public let rpcMethods: [String]

// RPC method type
public typealias RpcMethod = String
```

### Common RPC Methods

```swift
public enum CommonRpcMethods {
    // Core methods
    public static let block = "block"
    public static let status = "status"
    public static let query = "query"
    public static let validators = "validators"
    public static let networkInfo = "network_info"
    public static let gasPrice = "gas_price"
    public static let health = "health"
    public static let genesisConfig = "genesis_config"
    public static let clientConfig = "client_config"

    // Transaction methods
    public static let broadcastTxAsync = "broadcast_tx_async"
    public static let broadcastTxCommit = "broadcast_tx_commit"
    public static let sendTx = "send_tx"
    public static let tx = "tx"

    // Experimental methods
    public static let EXPERIMENTALChanges = "EXPERIMENTAL_changes"
    public static let EXPERIMENTALChangesInBlock = "EXPERIMENTAL_changes_in_block"
    public static let EXPERIMENTALCongestionLevel = "EXPERIMENTAL_congestion_level"
    public static let EXPERIMENTALGenesisConfig = "EXPERIMENTAL_genesis_config"
    public static let EXPERIMENTALLightClientBlockProof = "EXPERIMENTAL_light_client_block_proof"
    public static let EXPERIMENTALLightClientProof = "EXPERIMENTAL_light_client_proof"
    public static let EXPERIMENTALMaintenanceWindows = "EXPERIMENTAL_maintenance_windows"
    public static let EXPERIMENTALProtocolConfig = "EXPERIMENTAL_protocol_config"
    public static let EXPERIMENTALReceipt = "EXPERIMENTAL_receipt"
    public static let EXPERIMENTALSplitStorageInfo = "EXPERIMENTAL_split_storage_info"
    public static let EXPERIMENTALTxStatus = "EXPERIMENTAL_tx_status"
    public static let EXPERIMENTALValidatorsOrdered = "EXPERIMENTAL_validators_ordered"
}
```

## Usage Examples

### Basic Type Imports

```swift
import NearJsonRpcTypes

// Use the generated types
let blockRequest = BlockRequest(blockId: .final)
let accountInfo = AccountView(
    amount: "1000000000000000000000000",
    locked: "0",
    codeHash: "11111111111111111111111111111111",
    storageUsage: 0,
    storagePaidAt: 0,
    blockHeight: 12345,
    blockHash: "22222222222222222222222222222222"
)
```

### Type Safety Benefits

```swift
// Compile-time safety
let request = BlockRequest(blockId: .final) // Type-safe enum

// Auto-completion
let blockHeight = block.header.height // IntelliSense support

// Validation
let account = try AccountView(from: jsonData) // Automatic validation
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

### Type Conversion

```swift
// AnyCodable usage
let anyValue = AnyCodable(["key": "value"])
let stringValue = anyValue.value as? String

// Type conversion
let convertedValue = try anyValue.decode([String: String].self)
```

### Error Handling

```swift
// RPC error handling
let rpcError = RpcError(
    code: -32601,
    message: "Method not found",
    data: AnyCodable(["method": "invalid_method"])
)

// Error conversion
let nearError = NearRpcError.fromRpcError(rpcError)
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

All prefixed with `EXPERIMENTAL_` for advanced features.

## Type Safety Features

### Compile-time Validation

```swift
// These will cause compile-time errors
let invalidBlockId = BlockId.invalid // ❌ Compile error
let invalidFinality = Finality.invalid // ❌ Compile error

// These are type-safe
let blockId = BlockId.height(12345) // ✅ Type-safe
let finality = Finality.final // ✅ Type-safe
```

### Auto-completion Support

```swift
// Full IntelliSense support
let account = AccountView(
    amount: "", // Auto-completion shows all required fields
    locked: "",
    codeHash: "",
    storageUsage: 0,
    storagePaidAt: 0,
    blockHeight: 0,
    blockHash: ""
)
```

### Refactoring Safety

```swift
// Renaming types automatically updates all references
// Adding new fields requires updates at compile time
// Removing fields causes compile-time errors
```

## Best Practices

### Type Usage

```swift
// Use specific types instead of Any
let accountId: AccountId = "example.near" // ✅ Type-safe
let accountId: String = "example.near" // ❌ Less type-safe

// Use enums for known values
let finality: Finality = .final // ✅ Type-safe
let finality: String = "final" // ❌ Less type-safe
```

### Error Handling

```swift
// Use typed error handling
do {
    let response = try JSONDecoder().decode(JsonRpcResponse<AccountView>.self, from: data)
    // Handle success
} catch {
    // Handle error
}
```

### Validation

```swift
// Always validate methods before use
if RpcMethodValidator.isValid(method) {
    // Use the method
} else {
    // Handle invalid method
}
```

## API Documentation

For detailed documentation on NEAR RPC methods and their parameters, see the [NEAR RPC API documentation](https://docs.near.org/api/rpc/introduction).

## License

This package is distributed under the MIT license.
