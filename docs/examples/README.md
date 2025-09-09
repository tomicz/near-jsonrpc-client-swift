# Examples

Practical examples of using the NEAR JSON-RPC Swift client.

## Running Examples

### Basic Usage

```bash
cd examples/basic-usage
swift run BasicUsage
```

Shows simple RPC operations on NEAR mainnet:

- Node status
- Latest block
- Gas price
- Network info

### Advanced Usage

```bash
cd examples/advanced-usage
swift run AdvancedUsage
```

Shows complex blockchain operations on NEAR testnet:

- Account queries
- Block by height
- Validators
- Transaction status
- Chunk information

## Example Code

### Basic Operations

```swift
import NearJsonRpcClient

let client = try NearJsonRpcClient(urlString: "https://rpc.mainnet.near.org")

// Get node status
let statusResponse = try await client.request(method: "status")

// Get latest block
let blockResponse = try await client.request(method: "block", params: ["finality": "final"])
```

### Account Operations

```swift
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

## Troubleshooting

### Common Issues

- **Build errors**: Run `swift package clean && swift build`
- **Network errors**: Check internet connection and RPC endpoint
- **Parameter errors**: Use correct parameter names (`"finality": "final"`)

### Debug Tips

- Add print statements for debugging
- Check JSON response format
- Validate parameter names and types
