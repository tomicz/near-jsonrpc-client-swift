# NEAR Protocol Swift SDK

A type-safe Swift SDK for NEAR Protocol's JSON-RPC API, automatically generated from the official OpenAPI specification.

## 🚀 Features

- **🔧 Auto-generated** Swift types from NEAR's official OpenAPI specification
- **📝 Fully typed** with Swift 6.0 and strict type safety
- **🔄 Automatic updates** via GitHub Actions (daily sync with NEAR's API)
- **📦 Swift Package Manager** ready
- **✅ Compilation tested** on every update

## 📦 What's Included

### Generated Types Package (`packages/NearJsonRpcTypes/`)

- **249+ Swift types** automatically generated from OpenAPI spec
- All types implement `Codable` for seamless JSON serialization
- Comprehensive documentation extracted from OpenAPI descriptions
- Support for all NEAR RPC methods and data structures

### Code Generator (`Tools/CodeGenerator/`)

- Swift-based tool that downloads and parses NEAR's OpenAPI specification
- Generates Swift types following Swift naming conventions
- Handles complex schema types (structs, enums, unions, primitives)
- Automated type mapping from OpenAPI to Swift types

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   OpenAPI Spec  │───▶│  Code Generator  │───▶│ Generated Types │
│  (NEAR Repo)    │    │    (Swift)       │    │   (Swift)       │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                              │
                              ▼
                       ┌──────────────────┐
                       │ GitHub Actions   │
                       │ (Daily Updates)  │
                       └──────────────────┘
```

## 🚀 Getting Started

### Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/tomicz/near-test-swift.git", from: "1.0.0")
]
```

Or in Xcode: File → Add Package Dependencies → Enter the repository URL.

### Basic Usage

```swift
import NearJsonRpcTypes

// Example: Working with generated types
let blockRequest = BlockRequest(
    blockId: BlockId.finality(.final)
)

// All types are Codable for easy JSON handling
let jsonData = try JSONEncoder().encode(blockRequest)
let decodedRequest = try JSONDecoder().decode(BlockRequest.self, from: jsonData)
```

## 🛠️ Development

### Running the Code Generator

To manually generate types from the latest OpenAPI specification:

```bash
cd Tools/CodeGenerator
swift run
```

This will:

1. Download the latest OpenAPI spec from NEAR's repository
2. Generate Swift types in `packages/NearJsonRpcTypes/Types.swift`
3. Test compilation to ensure everything works

### Testing Generated Types

```bash
cd packages/NearJsonRpcTypes
swift build
```

### Project Structure

```
├── packages/
│   └── NearJsonRpcTypes/          # Generated Swift types package
│       ├── Package.swift          # Swift Package Manager configuration
│       └── Types.swift            # Generated types (249+ types)
├── Tools/
│   └── CodeGenerator/             # Swift-based code generator
│       ├── Package.swift
│       ├── Sources/main.swift     # Main generator logic
│       └── open-api-near-spec.json # Latest OpenAPI spec
└── .github/workflows/
    └── codegenerator.yml          # Automated update workflow
```

## 🤖 Automation

The project automatically stays in sync with NEAR's API changes:

- **Daily Updates**: GitHub Actions runs at 6 AM UTC to check for API changes
- **Manual Triggers**: Can be triggered manually from GitHub Actions UI
- **Compilation Testing**: All generated code is tested before committing
- **Clean Git History**: Automated commits with descriptive messages

## 📋 Generated Types Overview

The generator creates Swift types for:

- **Block Operations**: `Block`, `BlockHeader`, `ChunkHeader`
- **Account Management**: `Account`, `AccountView`, `AccessKey`
- **Transactions**: `Transaction`, `SignedTransaction`, `Action`
- **Contract Calls**: `CallFunction`, `ViewFunction`, `ContractCode`
- **Network Info**: `Validator`, `NetworkInfo`, `GasPrice`
- **And 200+ more types** covering all NEAR RPC operations

## 🔮 Roadmap

- [ ] **RPC Client Implementation**: HTTP client for making API calls
- [ ] **Convenience Functions**: Higher-level abstractions for common operations
- [ ] **Error Handling**: Comprehensive Swift error types
- [ ] **Documentation**: Detailed usage examples and guides
- [ ] **Testing**: Unit tests for generated types

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! The project follows these principles:

- **Automated Generation**: All types are generated from OpenAPI specs
- **Type Safety**: Strict Swift typing with no `Any` types
- **Modern Swift**: Uses Swift 6.0 features and best practices
- **Cross-Platform**: Maintains compatibility across all Apple platforms

---

**Note**: This project is inspired by the [near-jsonrpc-client-ts](https://github.com/near/near-jsonrpc-client-ts) TypeScript implementation, bringing the same type safety and automation to the Swift ecosystem.
