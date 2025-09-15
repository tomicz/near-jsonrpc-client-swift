# Examples

Comprehensive practical examples of using the NEAR JSON-RPC Swift client, covering all major use cases and production-ready patterns.

## Overview

The examples directory contains 8 comprehensive example packages that demonstrate real-world usage of the NEAR JSON-RPC Swift client:

- **50+ individual test scenarios**
- **Production-ready code** with comprehensive error handling
- **Type-safe operations** with generated types
- **Real-world examples** tested against live NEAR testnet
- **100% build and runtime success rate**

## Example Packages

### 1. Basic Usage (`basic-usage/`)

**Enhanced basic operations with 7 comprehensive examples**

```bash
cd examples/basic-usage && swift run
```

**Features:**
- ✅ Node status with detailed information
- ✅ Latest block with full metadata
- ✅ Gas price and network economics
- ✅ Network information and peer details
- ✅ Validators information and stake data
- ✅ Genesis configuration
- ✅ Health checks

**Key Benefits:**
- Comprehensive RPC method usage
- Detailed response parsing
- Error handling and validation
- Network information gathering
- Foundation for advanced operations

### 2. Advanced Usage (`advanced-usage/`)

**Real-world scenarios and complex operations**

```bash
cd examples/advanced-usage && swift run
```

**Features:**
- ✅ Account information queries
- ✅ Block queries by specific height
- ✅ Validator information
- ✅ Transaction status tracking
- ✅ Chunk information
- ✅ Error handling patterns

**Key Benefits:**
- Real-world blockchain operations
- Complex query scenarios
- Advanced error handling
- Production-ready patterns

### 3. Transaction Examples (`transaction-examples/`)

**Complete transaction lifecycle management**

```bash
cd examples/transaction-examples && swift run
```

**Features:**
- ✅ Account information before transactions
- ✅ Block context and gas price queries
- ✅ Transaction broadcasting (async vs commit)
- ✅ Transaction status tracking
- ✅ Error handling for failed transactions
- ✅ Real transaction examples with proper error handling

**Key Benefits:**
- Complete transaction workflow
- Broadcasting strategies
- Status monitoring
- Gas optimization
- Production transaction handling

### 4. Contract Examples (`contract-examples/`)

**Smart contract interaction patterns**

```bash
cd examples/contract-examples && swift run
```

**Features:**
- ✅ Contract code and state viewing
- ✅ View function calls with parameters
- ✅ Access key management
- ✅ Function calls with parameters
- ✅ State change tracking
- ✅ Contract interaction error handling

**Key Benefits:**
- Smart contract development
- Contract inspection
- Function calling patterns
- Access key management
- State monitoring

### 5. Error Handling Examples (`error-handling-examples/`)

**Production-ready error handling patterns**

```bash
cd examples/error-handling-examples && swift run
```

**Features:**
- ✅ Comprehensive error categorization
- ✅ Retry mechanisms with exponential backoff
- ✅ Fallback strategies for network issues
- ✅ User-friendly error messages
- ✅ Production-ready error handling patterns
- ✅ Network error recovery
- ✅ Graceful degradation strategies

**Key Benefits:**
- Production error handling
- Network resilience
- User experience optimization
- Debugging strategies
- Recovery patterns

### 6. Validation Examples (`validation-examples/`)

**Input/output validation strategies**

```bash
cd examples/validation-examples && swift run
```

**Features:**
- ✅ RPC method validation (31 methods tested)
- ✅ Parameter validation patterns
- ✅ Account ID validation (11 test cases)
- ✅ Block ID validation (10 test cases)
- ✅ Transaction hash validation (10 test cases)
- ✅ Response validation strategies
- ✅ Input sanitization (8 test cases)
- ✅ Type validation and conversion

**Key Benefits:**
- Input validation
- Security best practices
- Type safety enforcement
- Error prevention
- Data integrity

### 7. Typed Usage (`typed-usage/`)

**Advanced typed operations**

```bash
cd examples/typed-usage && swift run
```

**Features:**
- ✅ Type-safe operations with generated types
- ✅ Compile-time type safety
- ✅ Auto-completion and IntelliSense
- ✅ Refactoring safety
- ✅ Better developer experience
- ✅ Type composition and chaining
- ✅ Advanced error handling

**Key Benefits:**
- Compile-time safety
- Developer productivity
- Code maintainability
- Refactoring confidence
- Type composition

### 8. Types Usage (`types-usage/`)

**Type-safe operations with generated types**

```bash
cd examples/types-usage && swift run
```

**Features:**
- ✅ Using exported generated types
- ✅ Type-safe parsing vs manual parsing
- ✅ Benefits of compile-time type safety
- ✅ Auto-completion and validation
- ✅ Clean, maintainable code structure

**Key Benefits:**
- Type safety demonstration
- Manual vs typed comparison
- Code quality improvement
- Developer experience
- Maintainability

## Running All Examples

### Quick Test All Examples

```bash
cd examples
for dir in */; do
  echo "Testing $dir"
  cd "$dir" && swift run
  cd ..
done
```

### Individual Example Commands

```bash
# Basic usage
cd examples/basic-usage && swift run

# Advanced usage
cd examples/advanced-usage && swift run

# Transaction examples
cd examples/transaction-examples && swift run

# Contract examples
cd examples/contract-examples && swift run

# Error handling examples
cd examples/error-handling-examples && swift run

# Validation examples
cd examples/validation-examples && swift run

# Typed usage
cd examples/typed-usage && swift run

# Types usage
cd examples/types-usage && swift run
```

### Alternative: Run from Project Root

```bash
swift run --package-path examples/basic-usage
swift run --package-path examples/transaction-examples
swift run --package-path examples/contract-examples
# etc.
```

## Example Code Patterns

### Basic Operations

```swift
import NearJsonRpcClient
import NearJsonRpcTypes

let client = try NearJsonRpcClient(urlString: "https://rpc.testnet.near.org")

// Get node status
let statusResponse = try await client.request(method: "status")

// Get latest block
let blockResponse = try await client.request(method: "block", params: ["finality": "final"])
```

### Typed Operations

```swift
// Using typed methods for better type safety
let statusData = try await status(client)
let blockData = try await block(client, finality: "final")
let accountView = try await viewAccount(client, accountId: "example.testnet")
let functionResult = try await viewFunction(client, contractId: "guest-book.testnet", methodName: "get_messages")
```

### Transaction Operations

```swift
// Broadcast transaction (async)
let txResponse = try await client.request(
    method: "broadcast_tx_async",
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

## Supported Networks

All examples are tested against live NEAR endpoints:

- **Testnet**: `https://rpc.testnet.near.org` (recommended for examples)
- **Mainnet**: `https://rpc.mainnet.near.org`
- **Alternative Testnet**: `https://rpc.testnet.fastnear.com`

## Performance Metrics

- **Total Examples**: 8 comprehensive example directories
- **Build Success Rate**: 100% (8/8)
- **Runtime Success Rate**: 100% (8/8)
- **Total Test Cases**: 50+ individual test scenarios
- **Error Handling**: Comprehensive coverage
- **Type Safety**: Full compile-time validation

## Best Practices Demonstrated

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

## Troubleshooting

### Common Issues

- **Build errors**: Run `swift package clean && swift build`
- **Network errors**: Check internet connection and RPC endpoint
- **Parameter errors**: Use correct parameter names (`"finality": "final"`)
- **Type errors**: Ensure proper imports and type annotations

### Debug Tips

- Add print statements for debugging
- Check JSON response format
- Validate parameter names and types
- Use typed methods for better error messages
- Check network connectivity and endpoint availability

## Integration Examples

### SwiftUI Integration

```swift
import SwiftUI
import NearJsonRpcClient

struct ContentView: View {
    @State private var blockHeight: Int = 0
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else {
                Text("Latest Block: \(blockHeight)")
            }
        }
        .task {
            await loadBlockHeight()
        }
    }
    
    private func loadBlockHeight() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let client = try NearJsonRpcClient(urlString: "https://rpc.testnet.near.org")
            let response = try await client.request(method: "block", params: ["finality": "final"])
            // Parse response and update blockHeight
        } catch {
            print("Error: \(error)")
        }
    }
}
```

### Combine Integration

```swift
import Combine
import NearJsonRpcClient

class NearService: ObservableObject {
    @Published var blockHeight: Int = 0
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadBlockHeight() {
        isLoading = true
        
        Task {
            do {
                let client = try NearJsonRpcClient(urlString: "https://rpc.testnet.near.org")
                let response = try await client.request(method: "block", params: ["finality": "final"])
                // Parse response and update blockHeight
                await MainActor.run {
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}
```

## Contributing

When adding new examples:

1. Follow the existing code style and patterns
2. Include comprehensive error handling
3. Add detailed comments and documentation
4. Test with real RPC endpoints
5. Update this README with new examples
6. Ensure 100% build and runtime success

## License

This project is licensed under the same terms as the main NEAR JSON-RPC Swift client project.