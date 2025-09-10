# GitHub Actions for NEAR JSON-RPC Client Swift

Simple CI workflow that runs tests and builds packages automatically.

## What it does

- **Triggers**: Push to `main`, Pull Requests to `main`
- **Tests**: All packages and examples
- **Platform**: macOS with Swift 5.10

## How to use

1. Push code to GitHub - tests run automatically
2. Check the Actions tab for results
3. All tests must pass before merging

## Manual testing

```bash
# Test packages
cd packages/NearJsonRpcTypes && swift test
cd packages/NearJsonRpcClient && swift test

# Test examples
cd examples/basic-usage && swift test
cd examples/advanced-usage && swift test
cd examples/types-usage && swift test

# Build packages
cd packages/NearJsonRpcTypes && swift build
cd packages/NearJsonRpcClient && swift build
```
