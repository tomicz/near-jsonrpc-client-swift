#!/bin/bash

# Setup Script for New Contributors
# Installs dependencies and builds the project

set -e

echo "🚀 Setting up NEAR Protocol Swift SDK..."
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed. Please install it first:"
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Check Swift version
echo "📋 Checking Swift version..."
swift --version
echo ""

# Install SwiftLint if not already installed
if ! command -v swiftlint &> /dev/null; then
    echo "📦 Installing SwiftLint..."
    brew install swiftlint
    echo "✅ SwiftLint installed"
else
    echo "✅ SwiftLint already installed"
fi
echo ""

# Build all packages
echo "🔨 Building all packages..."
./Scripts/build-all.sh
echo ""

# Run tests
echo "🧪 Running tests..."
./Scripts/test-all.sh
echo ""

echo "🎉 Setup complete!"
echo ""
echo "📚 Next steps:"
echo "   - Read CONTRIBUTING.md for contribution guidelines"
echo "   - Check Examples/BasicExample for usage examples"
echo "   - Run './Scripts/generate.sh' to regenerate code from OpenAPI spec"
echo "   - Run './Scripts/validate.sh' before committing changes"

