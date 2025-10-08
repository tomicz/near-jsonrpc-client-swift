# Development Scripts

This directory contains helper scripts for developing the NEAR Protocol Swift SDK.

## Available Scripts

### 🚀 setup.sh

Initial setup for new contributors. Installs dependencies and builds the project.

```bash
./Scripts/setup.sh
```

**What it does:**

- Checks Swift version
- Installs SwiftLint (if not already installed)
- Builds all packages
- Runs all tests
- Provides next steps guidance

**When to use:** First time setting up the project on a new machine.

---

### 🔨 build-all.sh

Builds all Swift packages in the correct dependency order.

```bash
./Scripts/build-all.sh
```

**What it does:**

- Builds `NearJsonRpcTypes` (no dependencies)
- Builds `NearJsonRpcClient` (depends on Types)
- Builds `CodeGenerator`
- Builds `BasicExample` (depends on Client)

**When to use:** After making changes to verify everything still compiles.

---

### 🧪 test-all.sh

Runs all test suites for the project.

```bash
./Scripts/test-all.sh
```

**What it does:**

- Runs `NearJsonRpcTypes` tests (50 tests)
- Runs `NearJsonRpcClient` tests (25 tests)

**When to use:** Before committing to ensure no regressions.

---

### 🧹 clean-all.sh

Removes all build artifacts and caches.

```bash
./Scripts/clean-all.sh
```

**What it does:**

- Removes all `.build` directories
- Removes all `Package.resolved` files
- Cleans derived data

**When to use:** When you want a fresh build or experiencing build issues.

---

### 🔧 generate.sh

Regenerates code from the NEAR OpenAPI specification.

```bash
./Scripts/generate.sh
```

**What it does:**

1. Downloads latest OpenAPI spec from NEAR repository
2. Runs the Swift code generator
3. Lints the generated code
4. Verifies generated code compiles
5. Reports generated files

**When to use:**

- After updating the code generator logic
- When NEAR updates their API
- When manually testing code generation

**Output files:**

- `Packages/NearJsonRpcTypes/Types.swift`
- `Packages/NearJsonRpcTypes/Methods.swift`
- `Packages/NearJsonRpcClient/Sources/GeneratedMethods.swift`
- `Packages/NearJsonRpcClient/Sources/ConvenienceMethods.swift`

---

### 🔍 lint.sh

Runs SwiftLint on the generated code.

```bash
./Scripts/lint.sh
```

**What it does:**

- Checks if SwiftLint is installed
- Runs SwiftLint on `NearJsonRpcTypes` package
- Reports any style violations

**When to use:**

- Before committing changes
- After regenerating code
- As part of pre-commit checks

---

### ✅ validate.sh

Comprehensive validation - runs all checks before committing.

```bash
./Scripts/validate.sh
```

**What it does:**

1. Runs linting (SwiftLint)
2. Builds all packages
3. Runs all tests

**When to use:** **Always run before committing!** This ensures your changes pass all checks.

**Exit codes:**

- `0` - All checks passed ✅
- `1` - At least one check failed ❌

---

## Workflow Examples

### Starting Development

```bash
# First time setup
./Scripts/setup.sh

# Start working on code...
```

### During Development

```bash
# After making changes
./Scripts/build-all.sh

# Run tests for the package you changed
cd Packages/NearJsonRpcClient
swift test
```

### Before Committing

```bash
# Run full validation
./Scripts/validate.sh

# If all passes, commit your changes
git add .
git commit -m "your message"
git push
```

### Working on Code Generator

```bash
# Make changes to Tools/CodeGenerator/Sources/main.swift

# Test the generator
./Scripts/generate.sh

# Verify the output
./Scripts/validate.sh
```

### Clean Build

```bash
# Remove all build artifacts
./Scripts/clean-all.sh

# Fresh build
./Scripts/build-all.sh
```

---

## Script Dependencies

### Required Tools

- **Swift 6.0+** - Swift compiler
- **Xcode** - For macOS development
- **Homebrew** - Package manager (for installing SwiftLint)
- **SwiftLint** - Code linting tool

### Installing Dependencies

```bash
# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install SwiftLint
brew install swiftlint

# Verify installations
swift --version
swiftlint version
```

---

## Troubleshooting

### "SwiftLint not found"

```bash
brew install swiftlint
```

### "Permission denied"

Scripts need execute permissions:

```bash
chmod +x Scripts/*.sh
```

### "Build failed"

Try a clean build:

```bash
./Scripts/clean-all.sh
./Scripts/build-all.sh
```

### "Tests failing"

Check if it's a known issue:

```bash
# Run tests with verbose output
cd Packages/NearJsonRpcTypes
swift test --verbose
```

---

## CI/CD Integration

These scripts mirror the CI/CD pipeline in GitHub Actions. Running `./Scripts/validate.sh` locally will catch most issues before pushing.

**GitHub Actions workflows:**

- `.github/workflows/ci.yml` - Runs on every PR/push
- `.github/workflows/codegenerator.yml` - Daily code generation
- `.github/workflows/release-please.yml` - Release automation

---

## Adding New Scripts

When adding new scripts:

1. Create the script in `Scripts/` directory
2. Make it executable: `chmod +x Scripts/your-script.sh`
3. Add proper error handling: `set -e`
4. Add descriptive echo statements
5. Document it in this README
6. Test it thoroughly before committing

**Template:**

```bash
#!/bin/bash

# Your Script Name
# Brief description of what it does

set -e

echo "🎯 Starting your script..."
echo ""

# Your script logic here

echo ""
echo "🎉 Script completed successfully!"
```

---

## Questions?

- See [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution guidelines
- Check [Tools/CodeGenerator/README.md](../Tools/CodeGenerator/README.md) for code generation details
- Open an issue if you encounter problems with these scripts
