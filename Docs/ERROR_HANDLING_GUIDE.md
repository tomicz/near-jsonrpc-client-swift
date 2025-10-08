# Error Handling Guide

Comprehensive guide to error handling in the NEAR Swift RPC Client.

## Error Types

The Swift client provides three main error types, all conforming to Swift's `Error` protocol and `LocalizedError` for detailed descriptions.

### 1. NearRpcClientError

**When it occurs:** Server-side errors from the NEAR RPC node

**Properties:**

- `code: Int` - JSON-RPC error code
- `message: String` - Error description
- `data: AnyCodable?` - Additional error data (optional)

**Common error codes:**

- `-32700` - Parse error (invalid JSON)
- `-32600` - Invalid request
- `-32601` - Method not found
- `-32602` - Invalid parameters
- `-32603` - Internal JSON-RPC error
- `-32000` to `-32099` - Server errors

**Example:**

```swift
do {
    let result = try await client.query(params: ["invalid": "params"])
} catch let error as NearRpcClientError {
    print("RPC Error Code: \(error.code)")
    print("Message: \(error.message)")
    print("Recovery: \(error.recoverySuggestion ?? "No suggestion")")

    // Check specific error codes
    switch error.code {
    case -32601:
        print("Method not found - RPC version might be too old")
    case -32602:
        print("Invalid parameters - check your request format")
    default:
        print("Other RPC error")
    }
}
```

### 2. NearRpcNetworkError

**When it occurs:** Network-level issues (timeouts, connection failures, etc.)

**Properties:**

- `message: String` - Error description
- `originalError: Error?` - Underlying network error (optional)
- `responseBody: String?` - HTTP response body if available (optional)

**Common scenarios:**

- Network timeout
- Connection refused
- Invalid endpoint URL
- HTTP errors (non-200 status codes)
- Request failed after all retries

**Example:**

```swift
do {
    let client = NearRpcClient(endpoint: "https://invalid-endpoint.com")
    let status = try await client.status()
} catch let error as NearRpcNetworkError {
    print("Network Error: \(error.message)")

    if let originalError = error.originalError {
        print("Underlying error: \(originalError.localizedDescription)")
    }

    if let responseBody = error.responseBody {
        print("Response body: \(responseBody)")
    }

    print("Recovery: \(error.recoverySuggestion ?? "Check network connection")")
}
```

### 3. NearRpcValidationError

**When it occurs:** Client-side parameter validation failures

**Properties:**

- `message: String` - Error description
- `field: String?` - Specific field that failed validation (optional)

**Example:**

```swift
do {
    // Validation error from incorrect parameter format
    let result = try await someValidatedMethod(params: invalidParams)
} catch let error as NearRpcValidationError {
    print("Validation Error: \(error.message)")

    if let field = error.field {
        print("Failed field: \(field)")
    }

    print("Recovery: \(error.recoverySuggestion ?? "Check parameters")")
}
```

## Error Handling Patterns

### Basic Try-Catch

```swift
do {
    let status = try await client.status()
    print("Chain: \(status.chain_id)")
} catch {
    print("Error: \(error.localizedDescription)")
}
```

### Specific Error Handling

```swift
do {
    let account = try await client.viewAccount(
        accountId: "example.near",
        finality: "final"
    )
    print("Balance: \(account.amount)")
} catch let error as NearRpcClientError {
    print("RPC Error (\(error.code)): \(error.message)")
} catch let error as NearRpcNetworkError {
    print("Network Error: \(error.message)")
} catch let error as NearRpcValidationError {
    print("Validation Error: \(error.message)")
} catch {
    print("Unknown error: \(error)")
}
```

### Comprehensive Error Handler

```swift
func handleNearError(_ error: Error) -> String {
    switch error {
    case let rpcError as NearRpcClientError:
        return """
        RPC Error (\(rpcError.code)): \(rpcError.message)
        Suggestion: \(rpcError.recoverySuggestion ?? "Check RPC documentation")
        """

    case let networkError as NearRpcNetworkError:
        return """
        Network Error: \(networkError.message)
        Suggestion: \(networkError.recoverySuggestion ?? "Check connection")
        """

    case let validationError as NearRpcValidationError:
        return """
        Validation Error: \(validationError.message)
        Field: \(validationError.field ?? "unknown")
        """

    default:
        return "Unknown error: \(error.localizedDescription)"
    }
}

// Usage
do {
    let result = try await client.status()
} catch {
    print(handleNearError(error))
}
```

### Error Conversion

All errors can be converted to `NearRpcError` enum:

```swift
do {
    let status = try await client.status()
} catch {
    let nearError = error.asNearRpcError

    switch nearError {
    case .client(let clientError):
        print("Client error: \(clientError.code)")
    case .network(let networkError):
        print("Network error: \(networkError.message)")
    case .validation(let validationError):
        print("Validation error: \(validationError.message)")
    }
}
```

## Retry Logic

The client automatically retries failed requests with exponential backoff.

### Default Behavior

```swift
let config = ClientConfig(
    endpoint: "https://rpc.mainnet.near.org",
    retries: 3  // Default: 3 retries
)
let client = NearRpcClient(config: config)

// Will retry up to 3 times with exponential backoff:
// - 1st retry after 1 second
// - 2nd retry after 2 seconds
// - 3rd retry after 4 seconds
```

### When Retries DON'T Happen

Client errors (RPC errors from server) are NOT retried:

- Invalid parameters
- Method not found
- Parse errors
- Any `NearRpcClientError`

Only network errors are retried:

- Connection timeouts
- Network failures
- HTTP errors
- Any `NearRpcNetworkError`

### Customizing Retries

```swift
// No retries
let config = ClientConfig(
    endpoint: "https://rpc.mainnet.near.org",
    retries: 0
)

// More retries for unreliable networks
let config = ClientConfig(
    endpoint: "https://rpc.mainnet.near.org",
    retries: 5
)

// Custom timeout + retries
let config = ClientConfig(
    endpoint: "https://rpc.mainnet.near.org",
    timeout: 60.0,  // 60 second timeout
    retries: 5
)
```

### Handling Retry Exhaustion

```swift
do {
    let status = try await client.status()
} catch let error as NearRpcNetworkError {
    if error.message.contains("after all retries") {
        print("All retry attempts failed")
        print("Consider:")
        print("- Checking network connection")
        print("- Trying a different RPC endpoint")
        print("- Increasing timeout or retry count")
    }
}
```

## Common Error Scenarios

### 1. Account Not Found

```swift
do {
    let account = try await client.viewAccount(accountId: "nonexistent.near")
} catch let error as NearRpcClientError where error.message.contains("does not exist") {
    print("Account does not exist")
    // Handle account creation or different logic
}
```

### 2. Method Not Found (Version Issue)

```swift
do {
    let result = try await client.changes(params: ["finality": "final"])
} catch let error as NearRpcClientError where error.code == -32601 {
    print("Method not found - RPC provider version is too old")
    // Fall back to experimental method
    let result = try await client.experimentalChanges(params: ["finality": "final"])
}
```

### 3. Invalid Parameters

```swift
do {
    let block = try await client.block(params: ["block_id": "invalid"])
} catch let error as NearRpcClientError where error.code == -32602 {
    print("Invalid parameters: \(error.message)")
    // Provide valid block ID or finality
}
```

### 4. Network Timeout

```swift
do {
    let result = try await client.query(params: complexQuery)
} catch let error as NearRpcNetworkError {
    if error.message.contains("timeout") {
        print("Request timed out")
        // Increase timeout or simplify query
        let newClient = client.withConfig(timeout: 60.0)
        let result = try await newClient.query(params: complexQuery)
    }
}
```

### 5. Invalid Endpoint

```swift
do {
    let client = NearRpcClient(endpoint: "https://invalid.endpoint.com")
    let status = try await client.status()
} catch let error as NearRpcNetworkError {
    print("Connection failed: \(error.message)")
    // Try alternative endpoint
    let fallbackClient = NearRpcClient(endpoint: "https://rpc.mainnet.near.org")
    let status = try await fallbackClient.status()
}
```

## Best Practices

### 1. Always Handle Errors

```swift
// ❌ Bad: Ignoring errors
let status = try! await client.status()

// ✅ Good: Proper error handling
do {
    let status = try await client.status()
} catch {
    print("Error: \(error)")
}
```

### 2. Use Specific Error Types

```swift
// ❌ Less specific
do {
    let account = try await client.viewAccount(accountId: "test.near")
} catch {
    print("Error: \(error)")
}

// ✅ More specific
do {
    let account = try await client.viewAccount(accountId: "test.near")
} catch let error as NearRpcClientError {
    // Handle RPC errors specifically
    print("RPC Error: \(error.code)")
} catch let error as NearRpcNetworkError {
    // Handle network errors specifically
    print("Network Error: \(error.message)")
}
```

### 3. Provide User-Friendly Messages

```swift
do {
    let status = try await client.status()
} catch let error as NearRpcClientError {
    // ❌ Technical error
    throw error

    // ✅ User-friendly message
    throw NSError(
        domain: "MyApp",
        code: 1,
        userInfo: [NSLocalizedDescriptionKey: "Unable to connect to NEAR network. Please try again."]
    )
}
```

### 4. Log Errors for Debugging

```swift
import os.log

do {
    let account = try await client.viewAccount(accountId: accountId)
} catch let error as NearRpcClientError {
    os_log(.error, "RPC Error: %{public}@, Code: %d", error.message, error.code)
    if let data = error.data {
        os_log(.debug, "Error data: %{public}@", String(describing: data))
    }
    throw error
}
```

### 5. Implement Fallback Strategies

```swift
func getAccountWithFallback(accountId: String) async throws -> AccountView {
    // Try primary endpoint
    do {
        return try await primaryClient.viewAccount(accountId: accountId)
    } catch {
        print("Primary endpoint failed, trying fallback")

        // Try fallback endpoint
        return try await fallbackClient.viewAccount(accountId: accountId)
    }
}
```

### 6. Handle Async Errors in SwiftUI

```swift
struct AccountView: View {
    @State private var account: AccountView?
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }
        }
        .task {
            do {
                account = try await client.viewAccount(accountId: "example.near")
            } catch let error as NearRpcClientError {
                errorMessage = "RPC Error: \(error.message)"
            } catch let error as NearRpcNetworkError {
                errorMessage = "Network Error: \(error.message)"
            } catch {
                errorMessage = "Unknown error occurred"
            }
        }
    }
}
```

## Error Testing

### Testing Error Scenarios

```swift
import XCTest
@testable import NearJsonRpcClient

class ErrorHandlingTests: XCTestCase {
    func testAccountNotFound() async throws {
        let client = NearRpcClient(endpoint: "https://rpc.testnet.near.org")

        do {
            _ = try await client.viewAccount(accountId: "nonexistent.near")
            XCTFail("Should have thrown error")
        } catch let error as NearRpcClientError {
            XCTAssertTrue(error.message.contains("does not exist"))
        }
    }

    func testInvalidEndpoint() async throws {
        let client = NearRpcClient(endpoint: "https://invalid.endpoint.com")

        do {
            _ = try await client.status()
            XCTFail("Should have thrown error")
        } catch is NearRpcNetworkError {
            // Expected error
        }
    }
}
```

## Additional Resources

- [Client Configuration](../Packages/NearJsonRpcClient/README.md#client-configuration)
- [RPC Compatibility Notes](./RPC_COMPATIBILITY_NOTES.md)
- [NEAR RPC Documentation](https://docs.near.org/api/rpc/introduction)
