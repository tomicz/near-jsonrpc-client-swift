# NEAR JSON-RPC Swift Client Examples

This directory contains comprehensive examples demonstrating how to use the `NearJsonRpcClient` library in various scenarios and environments.

## 📦 Client Architecture

The Swift client provides a clean, type-safe interface for NEAR Protocol's JSON-RPC API:

- **Type Safety**: Auto-generated types from NEAR's OpenAPI specification
- **Async/Await**: Modern Swift concurrency support
- **Error Handling**: Comprehensive error handling with custom error types
- **Platform Support**: macOS 10.15+, iOS 13+, watchOS 6+, tvOS 13+

## 🚀 Examples Overview

### Basic Examples

#### [basic-usage/](basic-usage/)

**Enhanced Basic Usage Example** - Comprehensive demonstration of fundamental RPC operations

- ✅ Node status and version information
- ✅ Latest block details with full metadata
- ✅ Gas price and network economics
- ✅ Network information and peer details
- ✅ Validators information and stake data
- ✅ Genesis configuration
- ✅ Health checks

**To run:**

```bash
cd basic-usage
swift run
```

#### [advanced-usage/](advanced-usage/)

**Advanced Usage Example** - Real-world scenarios and complex operations

- ✅ Account information queries
- ✅ Block queries by specific height
- ✅ Validator information
- ✅ Transaction status tracking
- ✅ Chunk information
- ✅ Error handling patterns

**To run:**

```bash
cd advanced-usage
swift run
```

#### [types-usage/](types-usage/)

**Types Usage Example** - Demonstrating type-safe operations with generated types

- ✅ Using exported generated types
- ✅ Type-safe parsing vs manual parsing
- ✅ Benefits of compile-time type safety
- ✅ Auto-completion and validation

**To run:**

```bash
cd types-usage
swift run
```

### Transaction Examples

#### [transaction-examples/](transaction-examples/)

**Comprehensive Transaction Examples** - Complete transaction lifecycle management

- ✅ Account information before transactions
- ✅ Block context and gas price queries
- ✅ Transaction broadcasting (async vs commit)
- ✅ Transaction status tracking
- ✅ Error handling for failed transactions
- ✅ Real transaction examples with proper error handling

**To run:**

```bash
cd transaction-examples
swift run
```

**Key Features:**

- Transaction broadcasting with `broadcast_tx_async`
- Transaction commitment with `broadcast_tx_commit`
- Transaction status monitoring
- Gas price optimization
- Block context awareness

### Contract Interaction Examples

#### [contract-examples/](contract-examples/)

**Contract Interaction Examples** - Smart contract interaction patterns

- ✅ Contract code viewing
- ✅ Contract state queries
- ✅ View function calls (read-only)
- ✅ Access key management
- ✅ Function calls with parameters
- ✅ State change tracking

**To run:**

```bash
cd contract-examples
swift run
```

**Key Features:**

- Contract code and state inspection
- View function calls with parameters
- Access key listing and management
- State change monitoring
- Contract interaction error handling

### Error Handling Examples

#### [error-handling-examples/](error-handling-examples/)

**Comprehensive Error Handling** - Production-ready error handling patterns

- ✅ Invalid method error handling
- ✅ Invalid parameter error handling
- ✅ Network error recovery
- ✅ Account not found errors
- ✅ Transaction error handling
- ✅ Contract error handling
- ✅ Retry patterns and strategies
- ✅ Graceful degradation

**To run:**

```bash
cd error-handling-examples
swift run
```

**Key Features:**

- Comprehensive error categorization
- Retry mechanisms with exponential backoff
- Fallback strategies for network issues
- User-friendly error messages
- Production-ready error handling patterns

## 🔧 Running All Examples

### Prerequisites

1. **Swift 5.9+** installed
2. **Internet connection** for RPC calls
3. **Xcode** (recommended for development)

### Quick Start

```bash
# Clone the repository
git clone <repository-url>
cd near-jsonrpc-client-swift

# Run any example
cd examples/basic-usage
swift run

# Or run from project root
swift run --package-path examples/basic-usage
```

### Individual Example Commands

```bash
# Basic usage
cd examples/basic-usage && swift run

# Advanced usage
cd examples/advanced-usage && swift run

# Types usage
cd examples/types-usage && swift run

# Transaction examples
cd examples/transaction-examples && swift run

# Contract examples
cd examples/contract-examples && swift run

# Error handling examples
cd examples/error-handling-examples && swift run
```

## 🌐 Available RPC Endpoints

The examples use various NEAR RPC endpoints:

- **Testnet**: `https://rpc.testnet.near.org` (recommended for examples)
- **Mainnet**: `https://rpc.mainnet.near.org`
- **Alternative Testnet**: `https://rpc.testnet.fastnear.com`

## 📚 API Documentation

### Core RPC Methods

```swift
import NearJsonRpcClient
import NearJsonRpcTypes

let client = try NearJsonRpcClient(urlString: "https://rpc.testnet.near.org")

// Basic operations
let status = try await client.request(method: "status")
let block = try await client.request(method: "block", params: ["finality": "final"])
let gasPrice = try await client.request(method: "gas_price", params: ["block_id": "final"])

// Account operations
let account = try await client.request(method: "query", params: [
    "request_type": "view_account",
    "finality": "final",
    "account_id": "example.testnet"
])

// Transaction operations
let txStatus = try await client.request(method: "tx", params: [
    "tx_hash": "transaction_hash",
    "sender_account_id": "sender.testnet"
])
```

### Type-Safe Operations

```swift
// Using generated types for better type safety
let accountView = try await viewAccount(client, accountId: "example.testnet")
let blockData = try await block(client, finality: "final")
let networkInfo = try await networkInfo(client)
```

## 💡 Best Practices

### Error Handling

```swift
do {
    let response = try await client.request(method: "status")
    // Process response
} catch let error as NearRpcError {
    switch error {
    case .httpError(let code):
        print("HTTP error: \(code)")
    case .invalidResponse:
        print("Invalid response format")
    case .networkError(let underlyingError):
        print("Network error: \(underlyingError)")
    }
} catch {
    print("Unexpected error: \(error)")
}
```

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

## 🔗 Integration Examples

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

## 🧪 Testing

All examples include comprehensive error handling and can be used as test cases:

```bash
# Run all examples to verify functionality
for example in basic-usage advanced-usage types-usage transaction-examples contract-examples error-handling-examples; do
    echo "Running $example..."
    cd examples/$example && swift run
    cd ../..
done
```

## 📖 Additional Resources

- **Main Documentation**: See the main README in the project root
- **API Reference**: Check the generated documentation
- **TypeScript Reference**: See `near-jsonrpc-client-ts-reference/` for comparison
- **NEAR Protocol Docs**: [https://docs.near.org/](https://docs.near.org/)

## 🤝 Contributing

When adding new examples:

1. Follow the existing code style and patterns
2. Include comprehensive error handling
3. Add detailed comments and documentation
4. Test with real RPC endpoints
5. Update this README with new examples

## 📄 License

This project is licensed under the same terms as the main NEAR JSON-RPC Swift client project.
