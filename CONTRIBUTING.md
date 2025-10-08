# Contributing to NEAR Protocol Swift SDK

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Getting Started

### Prerequisites

- macOS 10.15+
- Xcode 14+ with Swift 6.0
- SwiftLint installed: `brew install swiftlint`

### Setup

1. Fork the repository
2. Clone your fork:

   ```bash
   git clone https://github.com/YOUR_USERNAME/near-jsonrpc-client-swift.git
   cd near-jsonrpc-client-swift
   ```

3. Build the project:

   ```bash
   # Build types package
   cd Packages/NearJsonRpcTypes
   swift build

   # Build client package
   cd ../NearJsonRpcClient
   swift build

   # Run example
   cd ../../Examples/BasicExample
   swift run
   ```

## How to Contribute

### Reporting Bugs

Open an issue with:

- Clear description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Swift/Xcode version
- Code samples if applicable

### Suggesting Features

Open an issue with:

- Clear description of the feature
- Use case and motivation
- Proposed API design (if applicable)

### Submitting Pull Requests

1. **Create a branch** from `main`:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following our code style

3. **Test your changes**:

   ```bash
   swift build
   swift test
   ```

4. **Lint your code**:

   ```bash
   swiftlint lint
   ```

5. **Commit with clear messages**:

   ```bash
   git commit -m "feat: add new feature"
   git commit -m "fix: resolve issue with X"
   git commit -m "docs: update README"
   ```

6. **Push and create PR**:
   ```bash
   git push origin feature/your-feature-name
   ```

## Code Style

### Swift Style Guide

- Follow standard Swift conventions
- Use 4 spaces for indentation
- Maximum line length: 120 characters
- Use meaningful variable and function names

### SwiftLint

We use SwiftLint to enforce code style. Run before committing:

```bash
swiftlint lint
```

Fix auto-fixable issues:

```bash
swiftlint --fix
```

### Code Organization

- Keep functions focused and small
- Add comments for complex logic
- Use `// MARK:` to organize code sections
- Group related functionality together

## Generated Code

**Important:** Do not manually edit generated files:

- `Packages/NearJsonRpcTypes/Types.swift`
- `Packages/NearJsonRpcTypes/Methods.swift`
- `Packages/NearJsonRpcClient/Sources/GeneratedMethods.swift`
- `Packages/NearJsonRpcClient/Sources/ConvenienceMethods.swift`

These files are auto-generated from the OpenAPI spec. To modify them:

1. Update the code generator: `Tools/CodeGenerator/Sources/main.swift`
2. Run the generator: `cd Tools/CodeGenerator && swift run`
3. Verify the output compiles

## Testing

### Running Tests

```bash
# Run all tests
swift test

# Run tests for specific package
cd Packages/NearJsonRpcTypes
swift test
```

### Writing Tests

- Add tests for new features
- Ensure existing tests pass
- Aim for good test coverage
- Use descriptive test names

Example:

```swift
func testClientConfiguration() {
    let config = ClientConfig(endpoint: "https://rpc.testnet.near.org")
    XCTAssertEqual(config.endpoint, "https://rpc.testnet.near.org")
}
```

## Commit Messages

Follow conventional commits format:

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `test:` - Test updates
- `refactor:` - Code refactoring
- `chore:` - Maintenance tasks

Examples:

```
feat: add support for custom headers in client config
fix: resolve timeout issue in retry logic
docs: update README with new examples
test: add tests for error handling
```

## Pull Request Guidelines

### Before Submitting

- ✅ Code builds successfully
- ✅ All tests pass
- ✅ SwiftLint passes with no warnings
- ✅ Documentation is updated
- ✅ Commit messages are clear

### PR Description

Include:

- Summary of changes
- Motivation and context
- Breaking changes (if any)
- Related issues

### Review Process

- Maintainers will review your PR
- Address feedback and comments
- Keep PR focused and small when possible
- Be patient and respectful

## Development Workflow

### Adding a New Feature

1. Check existing issues/PRs to avoid duplication
2. Open an issue to discuss (for large features)
3. Create a branch
4. Implement the feature
5. Add tests
6. Update documentation
7. Submit PR

### Fixing a Bug

1. Verify the bug exists
2. Create a branch
3. Write a failing test (if possible)
4. Fix the bug
5. Ensure test passes
6. Submit PR

## Code Generator Development

### Modifying the Generator

1. Edit `Tools/CodeGenerator/Sources/main.swift`
2. Test changes:
   ```bash
   cd Tools/CodeGenerator
   swift run
   ```
3. Verify generated code compiles:
   ```bash
   cd ../../Packages/NearJsonRpcTypes
   swift build
   ```

### Adding New Type Mappings

Update `mapOpenAPITypeToSwift()` function:

```swift
case ("string", "custom-format"):
    return "CustomType"
```

### Adding Convenience Methods

Update `generateSwiftConvenienceMethods()` function with new helper methods.

## Documentation

### Updating Documentation

- Keep README files up to date
- Add code examples for new features
- Document breaking changes
- Update API references

### Documentation Style

- Be clear and concise
- Include code examples
- Link to related documentation
- Use proper markdown formatting

## Questions?

- Open an issue for questions
- Check existing documentation
- Review closed issues/PRs

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Provide constructive feedback
- Focus on collaboration

---

Thank you for contributing to the NEAR Protocol Swift SDK! 🚀
