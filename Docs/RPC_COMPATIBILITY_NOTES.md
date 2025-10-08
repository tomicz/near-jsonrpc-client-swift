# NEAR RPC Version Compatibility Notes

This document captures important observations about NEAR RPC version differences across providers and how they affect method availability.

## The Evolution from `EXPERIMENTAL_changes` to `changes`

### Timeline

- **Before June 2025**: Only `EXPERIMENTAL_changes` existed
- **June 19, 2025**: Commit [fdba1905](https://github.com/near/nearcore/commit/fdba19051ff3c177d69b7066d7d0be709d32a5b4) added stable `changes` endpoint
- **July 3, 2025**: Version 2.6.5 released (without `changes`)
- **Current**: Version 2.7.0-rc.x includes `changes` but only on testnet

### Current Status (as of July 2025)

#### Mainnet RPC Providers

All major mainnet providers run version 2.6.5 or older:

- `rpc.mainnet.near.org`: 2.6.5 ❌ No `changes` support
- `rpc.mainnet.fastnear.com`: 2.6.5 ❌ No `changes` support
- `near.lava.build`: 2.6.1 ❌ No `changes` support
- `1rpc.io/near`: 2.6.5 ❌ No `changes` support
- `near.blockpi.network`: 2.6.4 ❌ No `changes` support

#### Testnet RPC Providers

Some testnet providers run 2.7.0-rc.x:

- `rpc.testnet.near.org`: 2.7.0-rc.2 ✅ Has `changes` method
- `rpc.testnet.fastnear.com`: 2.7.0-rc.2 ✅ Has `changes` method
- `archival-rpc.testnet.fastnear.com`: ✅ Has `changes` method and historical data

### Understanding Block References

Both `changes` and `EXPERIMENTAL_changes` follow the same OpenAPI specification for block references. You can specify blocks using either:

1. **block_id** parameter:

   - Numeric block height: `186278611`
   - Block hash string: `"CpWTCVU5sF7gc6CyM2cKYGpvhUYXdWNMkghktXjz5Qe8"`

2. **finality** parameter:
   - For latest blocks: `"final"` or `"optimistic"`

Common mistake: Using `"block_id": "final"` will fail because "final" is neither a valid block height nor a block hash. Use the `finality` parameter instead.

### Swift Client Usage

The Swift client correctly follows the OpenAPI spec:

```swift
// Using block height
try await client.changes(params: [
    "block_id": 186278611,
    "changes_type": "account_changes",
    "account_ids": ["account.near"]
])

// Using block hash
try await client.changes(params: [
    "block_id": "CpWTCVU5sF7gc6CyM2cKYGpvhUYXdWNMkghktXjz5Qe8",
    "changes_type": "account_changes",
    "account_ids": ["account.near"]
])

// Using finality
try await client.changes(params: [
    "finality": "final",
    "changes_type": "account_changes",
    "account_ids": ["account.near"]
])
```

## Why Version Awareness Matters

This situation highlights important considerations when using NEAR RPC:

1. **Version Differences**: Different RPC providers run different versions of NEAR node software
2. **Method Availability**: Newer methods like `changes` are only available on newer versions (2.7.0+)
3. **Gradual Rollout**: Testnet typically gets new features before mainnet
4. **Provider Choice**: Consider which provider to use based on your version requirements

## Recommendations

### For Swift Developers

1. **Check RPC provider versions** - Use the `status()` method to check what version a provider is running
2. **Use `experimentalChanges` for mainnet compatibility** - Until mainnet providers upgrade to 2.7.0+
3. **Test against your target RPC provider** - Don't assume all providers are on the same version
4. **Implement version-aware fallbacks** - Try newer methods first, fall back to experimental versions

### For Library Maintainers

1. **Keep both method versions** - The generator correctly includes both from the spec
2. **Document version requirements** - Make it clear which methods need which NEAR node versions
3. **Test against multiple providers** - Ensure compatibility across different versions
4. **Track provider versions** - Monitor when major providers upgrade

## Example Fallback Pattern

```swift
func getChangesWithFallback(
    client: NearRpcClient,
    params: [String: Any]
) async throws -> RpcStateChangesInBlockResponse {
    do {
        // Try stable method (future-proof)
        return try await client.changes(params: params)
    } catch let error as NearRpcClientError where error.code == -32601 {
        // Method not found - fall back to experimental
        return try await client.experimentalChanges(params: params)
    }
}
```

## Method-Specific Compatibility Issues

### gas_price Parameter Format Change

The `gas_price` method underwent a parameter format change between versions:

#### Old Format (2.6.5 and earlier - current mainnet)

Mainnet expects array parameters:

```json
// Request
{
  "jsonrpc": "2.0",
  "id": "1",
  "method": "gas_price",
  "params": [157347609]  // Array format
}

// Response (successful)
{
  "jsonrpc": "2.0",
  "id": "1",
  "result": {
    "gas_price": "100000000"
  }
}

// Error when using object format on mainnet
{
  "error": {
    "code": -32700,
    "message": "Parse error",
    "data": "Failed parsing args: invalid type: map, expected a tuple of size 1"
  }
}
```

#### New Format (2.7.0+ - current testnet and OpenAPI spec)

The OpenAPI schema defines object parameters:

```json
// Schema definition
"RpcGasPriceRequest": {
  "properties": {
    "block_id": {
      "anyOf": [
        { "$ref": "#/components/schemas/BlockId" },
        { "enum": [null], "nullable": true }
      ]
    }
  },
  "type": "object"  // Object format, not array
}

// Request (as per OpenAPI spec and Swift client)
{
  "jsonrpc": "2.0",
  "id": "1",
  "method": "gas_price",
  "params": { "block_id": 157347609 }  // Object format
}
```

**Important Note**: The OpenAPI specification was only added to nearcore on May 26, 2025, which is after version 2.6.5 was released. This means:

- There was no OpenAPI spec to generate from for older versions
- Our Swift types are based on the newer format
- Calls may fail on mainnet for `gas_price` until mainnet upgrades to 2.7.0+

### Swift Client Impact

```swift
// This works on testnet (2.7.0+)
let gasPrice = try await client.gasPrice(params: ["block_id": 157347609])

// May fail on mainnet (2.6.5) with Parse error
// Workaround: Wait for mainnet to upgrade or use no parameters
let gasPrice = try await client.gasPrice(params: [:])
```

### experimentalProtocolConfig Field Mismatch Issues

The `experimentalProtocolConfig` method has version-dependent fields.

#### Field Availability by Network

**Testnet Response** (version 2.7.0-rc.2):

```json
{
  "result": {
    "runtime_config": {
      "wasm_config": {
        "global_contract_host_fns": true, // ✅ Present on testnet
        "saturating_float_to_int": true // ✅ Present on testnet
        // "reftype_bulk_memory": ???        // ❌ Missing on both networks!
      }
    }
  }
}
```

**Mainnet Response** (version 2.6.5):

```json
{
  "result": {
    "runtime_config": {
      "wasm_config": {
        // "global_contract_host_fns": ???   // ❌ Not present on mainnet
        // "saturating_float_to_int": ???    // ❌ Not present on mainnet
        // "reftype_bulk_memory": ???        // ❌ Missing on both networks!
        "alt_bn128": true, // ✅ Only on mainnet
        "math_extension": true // ✅ Only on mainnet
      }
    }
  }
}
```

#### Impact on Swift Client

The OpenAPI spec defines these as required fields, but actual responses vary:

- API calls succeed and return valid data
- Decoding may fail if strict type checking is used
- Some fields are version-specific

The OpenAPI spec appears to be out of sync with actual RPC implementations. The `reftype_bulk_memory` field is defined in the spec but not returned by any RPC node version.

## Other Observations

### RPC Provider Reliability

- FastNEAR endpoints tend to be more up-to-date and reliable
- Official near.org endpoints may have stricter rate limits
- Testnet often runs newer versions than mainnet

### Understanding Error Messages

- **"Method not found" (code: -32601)** - The RPC provider doesn't support this method (version too old)
- **"Parse error" (code: -32700)** - Parameters don't match the expected format
- **"UNKNOWN_BLOCK"** - The requested block doesn't exist on this RPC provider

### Checking Provider Version

```swift
let client = NearRpcClient(endpoint: "https://rpc.mainnet.near.org")
let status = try await client.status()
print("Provider version: \(status.version.version)")
print("Protocol version: \(status.protocol_version)")
```

### OpenAPI Spec and Production Reality

- The OpenAPI spec reflects the latest NEAR node capabilities
- Production RPC providers may run older versions
- Always check version compatibility for newer methods
- The Swift client is generated from the latest spec

## Testing Methodology

These observations were gathered through:

1. Direct curl requests to multiple RPC endpoints
2. Comparing responses between different providers
3. Testing both mainnet and testnet
4. Analyzing the OpenAPI spec history
5. Running the Swift client against real endpoints

## Best Practices

1. **Choose the right provider**: Select based on your version requirements
2. **Implement fallbacks**: Try newer methods, fall back to experimental
3. **Handle version errors**: Catch "Method not found" errors gracefully
4. **Test thoroughly**: Verify against your target network (mainnet/testnet)
5. **Monitor updates**: Track when providers upgrade to newer versions

Last updated: October 2025
