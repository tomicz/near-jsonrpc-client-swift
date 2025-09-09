# NearJsonRpcTypes

Swift types and schemas for the NEAR Protocol JSON-RPC API, auto-generated from the official NEAR OpenAPI specification.

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(path: "../packages/NearJsonRpcTypes")
]
```

## Usage

### Basic Type Imports

Import Swift types for type safety in your NEAR applications:

```swift
import NearJsonRpcTypes

// Use the generated types
let blockRequest = BlockRequest(blockId: .final)
let accountInfo = Account(accountId: "example.near", amount: "1000000000000000000000000", storageUsage: 0)
```

### Type Safety Benefits

```swift
// Compile-time safety
let request = BlockRequest(blockId: .final) // Type-safe enum

// Auto-completion
let blockHeight = block.header.height // IntelliSense support

// Validation
let account = try Account(from: jsonData) // Automatic validation
```

## Features

- **Swift Types**: Full type definitions for all NEAR RPC methods and responses
- **Auto-generated**: All types are automatically generated from the official NEAR OpenAPI specification
- **Type Safety**: Ensure your NEAR applications are type-safe at compile time
- **Complete Coverage**: Includes all RPC methods, request types, and response types

## API Documentation

For detailed documentation on NEAR RPC methods and their parameters, see the [NEAR RPC API documentation](https://docs.near.org/api/rpc/introduction).

## License

This package is distributed under the MIT license.
