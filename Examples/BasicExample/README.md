# Basic Example

A simple example demonstrating how to use the NEAR Swift RPC client to query network status.

## What It Does

This example shows you how to:

- Create a NEAR RPC client
- Connect to NEAR mainnet
- Query network status
- Access typed response properties

## Running the Example

```bash
cd Examples/BasicExample
swift run
```

## Expected Output

```
Testing NearJsonRpcClient
Client created
=== NEAR Network Status ===
Chain ID: mainnet
Protocol Version: 62
Latest Protocol Version: 62
Node Version: 1.37.0
Node Public Key: ed25519:...
Uptime: 3600 seconds
Sync Status: Synced
Latest Block Height: 123456789
Latest Block Hash: abc123...
Latest Block Time: 2024-01-01T00:00:00.000Z
Number of Validators: 100
Genesis Hash: xyz789...
RPC Address: 0.0.0.0:3030
```

## Code Walkthrough

### 1. Import the Client

```swift
import NearJsonRpcClient
```

### 2. Create the Client

```swift
let client = NearRpcClient(endpoint: "https://rpc.mainnet.fastnear.com")
```

### 3. Call RPC Method

```swift
let status = try await client.status()
```

### 4. Access Typed Properties

```swift
print("Chain ID: \(status.chain_id)")
print("Latest Block Height: \(status.sync_info.latest_block_height)")
print("Number of Validators: \(status.validators.count)")
```

## Key Concepts

**Type Safety**

- The `status()` method returns `RpcStatusResponse`
- All properties are strongly typed (no casting needed)
- IDE autocomplete works perfectly

**Async/Await**

- All RPC calls use Swift's modern async/await
- Clean error handling with try/catch

**Generated Methods**

- `status()` is auto-generated from NEAR's OpenAPI spec
- 38+ methods available on the client

## Next Steps

Try modifying the example to:

- Query the latest block: `client.block(params: ["finality": "final"])`
- Get gas price: `client.gasPrice(params: [:])`
- Check network info: `client.networkInfo()`

## Learn More

- [NearJsonRpcClient](../../Packages/NearJsonRpcClient/) - Full client documentation
- [NearJsonRpcTypes](../../Packages/NearJsonRpcTypes/) - All available types
- [Code Generator](../../Tools/CodeGenerator/) - How code is generated
